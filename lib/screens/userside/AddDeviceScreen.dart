import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDeviceScreen extends StatefulWidget {
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _deviceNameController = TextEditingController();
  List<String> roomList = [];
  String? selectedRoom;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    fetchRoomsFromFirestore();
  }

  Future<void> fetchRoomsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('devices').get();
      List<String> rooms = querySnapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        roomList = rooms;
      });
    } catch (e) {
      print('Error fetching rooms: $e');
    }
  }

  Future<void> _addDeviceToFirestore() async {
    String deviceName = _deviceNameController.text.trim();

    if (selectedRoom == null || deviceName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All fields are required'),
      ));
      return;
    }

    try {
      CollectionReference roomDevicesRef = _firestore
          .collection('devices')
          .doc(selectedRoom)
          .collection('${selectedRoom}Devices');
      DocumentReference newDeviceRef = roomDevicesRef.doc();
      String deviceId = newDeviceRef.id;
      await newDeviceRef.set({
        'info': {
          'id': deviceId,
          'name': deviceName,
          'location': selectedRoom,
          'addedAt': FieldValue.serverTimestamp(),
          'authtoken': "",
          'pin': ""
        }
      });

      // Display success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Device added successfully!'),
      ));

      _deviceNameController.clear();
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add device: $e'),
      ));
    }
  }

  Future<void> _addNewRoomDialog(BuildContext context) async {
    TextEditingController roomController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Room'),
          content: TextField(
            controller: roomController,
            decoration: InputDecoration(hintText: "Enter room name"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (roomController.text.isNotEmpty) {
                  _addRoomToFirestore(roomController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addRoomToFirestore(String roomName) async {
    try {
      await FirebaseFirestore.instance
          .collection('devices')
          .doc(roomName)
          .set({});
      setState(() {
        roomList.add(roomName);
      });
    } catch (e) {
      print('Error adding new room: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 200,
                  child: DropdownButton<String>(
                    value: selectedRoom,
                    hint: Text('Select Room'),
                    isExpanded: true,
                    items: roomList.map((String room) {
                      return DropdownMenuItem<String>(
                        value: room,
                        child: Text(room),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRoom = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _addNewRoomDialog(context);
                    },
                    child: Text(
                      'Add New Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _deviceNameController,
              decoration: InputDecoration(labelText: 'Device Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addDeviceToFirestore,
              child: Text('Add Device'),
            ),
          ],
        ),
      ),
    );
  }
}
