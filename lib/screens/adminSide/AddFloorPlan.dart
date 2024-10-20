import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../tools/UiComponents.dart';
import 'dart:async';

class RectangleManager extends StatefulWidget {
  @override
  _RectangleManagerState createState() => _RectangleManagerState();
}

class _RectangleManagerState extends State<RectangleManager> {
  final List<Rectangle> rectangles = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController blockController =
      TextEditingController(); // Controller for block name
  String blockName = '', userid = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  String? selectedBlock;
  List<String> blocks = [];

  //GetBlocks Alone Added
  Future<List<String>> getBlocks() async {
    QuerySnapshot snapshot = await _firestore.collection('blocks').get();
    List<String> blockNames = [];
    snapshot.docs.forEach((doc) {
      blockNames.add(doc.id); // Assuming block document IDs are the block names
    });
    return blockNames;
  }

  Future<String?> getCurrentUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      userid = user.uid; // Get the user's UID
      return userid; // Return the UID as a string
    } else {
      return null; // Return null if no user is signed in
    }
  }

  void addRectangle() async {
    String blockId = blockController.text.trim();
    String floorId = '1';
    Color selectedColor = Colors.blue; // Default color
    String? name = await showDialog<String>(
      context: context,
      builder: (context) {
        String rectangleName = '';
        return AlertDialog(
          title: Text('Enter Room Name :'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  rectangleName = value;
                },
                decoration: InputDecoration(hintText: "Name"),
              ),
              SizedBox(height: 10),
              Text('Select a color:'),
              Wrap(
                spacing: 8.0,
                children: [
                  _colorButton(Colors.red, () {
                    selectedColor = Colors.red;
                  }),
                  _colorButton(Colors.green, () {
                    selectedColor = Colors.green;
                  }),
                  _colorButton(Colors.blue, () {
                    selectedColor = Colors.blue;
                  }),
                  _colorButton(Colors.yellow, () {
                    selectedColor = Colors.yellow;
                  }),
                  _colorButton(Colors.orange, () {
                    selectedColor = Colors.orange;
                  }),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(rectangleName);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (name != null && name.isNotEmpty && blockName.isNotEmpty) {
      setState(() {
        rectangles.add(Rectangle(
          id: rectangles.length,
          width: 100,
          height: 100,
          position: Offset(50.0, 50.0),
          name: name,
          color: selectedColor,
          blockId: blockId,
          floorId: floorId,
        ));
      });
      await saveRoomDataToFirestore(name, selectedColor);
    }
  }

  Future<void> saveRoomDataToFirestore(String roomName, Color color) async {
    String blockId = blockController.text.trim(); // Get block ID from input
    String floorId = '1';

    if (blockId.isNotEmpty) {
      try {
        // Save the room data to Firestore
        await _firestore
            .collection('blocks')
            .doc(blockId)
            .collection('floors')
            .doc(floorId)
            .collection('rooms')
            .doc(roomName)
            .set({
          'name': roomName,
          'color': color.value, // Store color as an integer
          'width': 100, // Default width, you can modify as needed
          'height': 100, // Default height, you can modify as needed
          'position': {'x': 50.0, 'y': 50.0}, // Save the position as a map
        });
        print('Room data saved to Firestore');
      } catch (e) {
        print('Error saving room data: $e');
      }
    } else {
      print('Block ID is empty');
    }
  }

  Widget _colorButton(Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addRectangle,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              child: TextField(
                controller: blockController,
                decoration: InputDecoration(
                  labelText: 'Enter Block Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  blockName = value; // Update the block name when user types
                },
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: rectangles.map((rect) {
                return DraggableRectangle(
                  rect: rect,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RectangleDetailPage(rect.id),
                      ),
                    );
                  },
                  onDelete: () {
                    _confirmDelete(rect);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Rectangle rect) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Rectangle'),
          content: Text('Are you sure you want to delete ${rect.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  rectangles.remove(rect);
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class DraggableRectangle extends StatefulWidget {
  final Rectangle rect;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  DraggableRectangle(
      {required this.rect, required this.onTap, required this.onDelete});

  @override
  _DraggableRectangleState createState() => _DraggableRectangleState();
}

class _DraggableRectangleState extends State<DraggableRectangle> {
  double? width;
  double? height;
  bool showDeleteIcon = false;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    width = widget.rect.width;
    height = widget.rect.height;
  }

  Color getTextColor(Color backgroundColor) {
    return (backgroundColor.computeLuminance() > 0.5)
        ? Colors.black
        : Colors.white;
  }

  void _startUpdateTimer() {
    _updateTimer?.cancel(); // Cancel any existing timer
    _updateTimer = Timer(Duration(seconds: 1), () {
      _updateRectangleInFirestore(); // Call the Firestore update method after 1 second
    });
  }

  void _updateRectangleInFirestore() async {
    String blockId = ""; // Get the appropriate block ID
    String floorId = '1'; // Assuming you have a single floor

    try {
      await FirebaseFirestore.instance
          .collection('blocks')
          .doc(blockId)
          .collection('floors')
          .doc(floorId)
          .collection('rooms')
          .doc(widget.rect.name) // Using the rectangle's name as doc ID
          .update({
        'position': {
          'x': widget.rect.position.dx,
          'y': widget.rect.position.dy,
        },
        'width': width,
        'height': height,
      });
      print('Rectangle data updated in Firestore');
    } catch (e) {
      print('Error updating rectangle data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.rect.position.dx,
      top: widget.rect.position.dy,
      child: Stack(
        children: [
          GestureDetector(
            onTap: widget.onTap,
            onDoubleTap: () {
              setState(() {
                showDeleteIcon = true;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                widget.rect.position += details.delta;
              });
            },
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: widget.rect.color,
                border:
                    Border.all(color: Colors.black, width: 2), // Thin border
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      widget.rect.name,
                      style: TextStyle(color: getTextColor(widget.rect.color)),
                    ),
                  ),
                  if (showDeleteIcon)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: widget.onDelete,
                        child: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Increased size of resizing handle at the bottom right corner
          Positioned(
            right: -25,
            bottom: -25,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  width =
                      (width! + details.delta.dx).clamp(50.0, double.infinity);
                  height =
                      (height! + details.delta.dy).clamp(50.0, double.infinity);
                  widget.rect.width = width!;
                  widget.rect.height = height!;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                color: Colors.red,
                child: Icon(Icons.drag_handle, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Rectangle {
  final int id;
  double width;
  double height;
  Offset position;
  String name;
  Color color;
  String blockId; // Added block ID
  String floorId; // Added floor ID

  Rectangle({
    required this.id,
    required this.width,
    required this.height,
    required this.position,
    required this.name,
    required this.color,
    required this.blockId,
    required this.floorId,
  });
}

class RectangleDetailPage extends StatelessWidget {
  final int id;

  RectangleDetailPage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details of Room $id',
          style: appTstyle(),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('This is details page for Room $id'),
      ),
    );
  }
}
