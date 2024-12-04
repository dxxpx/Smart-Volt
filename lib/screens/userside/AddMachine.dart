import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../charts/LinearChart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMachineScreen extends StatefulWidget {
  @override
  _AddMachineScreenState createState() => _AddMachineScreenState();
}

class _AddMachineScreenState extends State<AddMachineScreen> {
  final TextEditingController _deviceNameController = TextEditingController();
  String _authToken = '';
  String _pinDetails = '';
  String _scanResult = '';
  final String userid = FirebaseAuth.instance.currentUser!.uid;

  // Simulating a QR Code Scanner using the barcode_scan2 package
  Future<void> _scanQRCode() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      setState(() {
        _scanResult = result.rawContent;
        // For simplicity, assume the QR code contains token and pin in the format "identify all high power consumption equipment "
        List<String> details = _scanResult.split(':');
        if (details.length == 2) {
          _authToken = details[0];
          _pinDetails = details[1];
        } else {
          _authToken = 'Invalid QR Code';
          _pinDetails = '';
        }
      });
    } catch (e) {
      setState(() {
        _scanResult = 'Failed to scan';
      });
    }
  }

  Future<void> _addMachine() async {
    final deviceName = _deviceNameController.text.trim();
    if (deviceName.isEmpty || _authToken.isEmpty || _pinDetails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide all details.')),
      );
      return;
    }

    // Add machine to Firebase
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .collection('machines')
          .add({
        'deviceName': deviceName,
        'authToken': _authToken,
        'pinDetails': _pinDetails,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _deviceNameController.clear();
      setState(() {
        _authToken = '';
        _pinDetails = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Machine added successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add machine: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Machine for Predictive Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _deviceNameController,
              decoration: InputDecoration(
                labelText: 'Device Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Scan QR Code for Auth Token & Pin Details'),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _scanQRCode,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan QR Code'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_box),
                  label: const Text('Add Manually'),
                ),
              ],
            ),
            if (_authToken.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Auth Token: $_authToken'),
                  Text('Pin Details: $_pinDetails'),
                  const Divider(thickness: 1.5, color: Colors.grey),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addMachine,
                    child: Text('Add Machine'),
                  ),
                ],
              ),
            // Spacer(),
            const SizedBox(height: 20),
            const Text(
              'Added Machines:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userid)
                        .collection('machines')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No machines added yet.'));
                      }
                      final machines = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: machines.length,
                          itemBuilder: (context, index) {
                            final machine = machines[index];
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DamagePredictionCharts(),
                                    ),
                                  );
                                },
                                trailing: Icon(Icons.bar_chart_outlined),
                                title: Text(
                                    machine['deviceName'] ?? 'Unknown Device'),
                                subtitle: Text(
                                    'Auth Token : ${machine['authToken']}\nPin Details: ${machine['pinDetails']}'),
                              ),
                            );
                          });
                    })),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Move to the SensorChartScreen (Pass necessary details if needed)
            //     },
            //     child: Text('Proceed to Charts'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
