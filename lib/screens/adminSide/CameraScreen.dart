import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

late List<CameraDescription> cameras;

class VehicleTracker extends StatefulWidget {
  @override
  _VehicleTrackerState createState() => _VehicleTrackerState();
}

class _VehicleTrackerState extends State<VehicleTracker> {
  CameraController? _controller;
  bool _isProcessing = false;
  String? vehicleRegNumber;
  String? vehicleType;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller?.initialize();
    if (!mounted) return;
    setState(() {});
  }

  void _processFrame() async {
    if (_isProcessing || _controller == null) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulating machine vision detection
    final randomRegNumber = "TN-4";
    final randomType = DateTime.now().second % 2 == 0 ? "Car" : "Bike";

    vehicleRegNumber = randomRegNumber;
    vehicleType = randomType;

    // Check if vehicle already exists

    final vehicleRecords = await _firestore
        .collection('vehicles')
        .where('regNumber', isEqualTo: vehicleRegNumber)
        .get();

    if (vehicleRecords.docs.isEmpty) {
      // New vehicle: Add entry
      await _firestore.collection('vehicles').add({
        'regNumber': vehicleRegNumber,
        'vehicleType': vehicleType,
        'entryTime': FieldValue.serverTimestamp(),
        'exitTime': null,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Entry recorded for $vehicleType ($vehicleRegNumber)')));
    } else {
      // Existing vehicle: Check for active records
      bool activeRecordExists = false;
      for (var doc in vehicleRecords.docs) {
        if (doc.data()['exitTime'] == null) {
          // Active record found: Update exit time
          await _firestore.collection('vehicles').doc(doc.id).update({
            'exitTime': FieldValue.serverTimestamp(),
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Exit recorded for $vehicleType ($vehicleRegNumber)')));
          activeRecordExists = true;
          break;
        }
      }

      if (!activeRecordExists) {
        // No active record: Add a new entry
        await _firestore.collection('vehicles').add({
          'regNumber': vehicleRegNumber,
          'vehicleType': vehicleType,
          'entryTime': FieldValue.serverTimestamp(),
          'exitTime': null,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'New entry recorded for $vehicleType ($vehicleRegNumber)')));
      }
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text("Vehicle Tracker")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: CameraPreview(_controller!),
          ),
          ElevatedButton(
            onPressed: _processFrame,
            child: Text("Scan Vehicle"),
          ),
          Container(child: Text("Parking Records")),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('vehicles')
                      .orderBy('entryTime', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final vehicleRecords = snapshot.data!.docs;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Register Number')),
                          DataColumn(label: Text('Vehicle Type')),
                          DataColumn(label: Text('Entry Time')),
                          DataColumn(label: Text('Exit Time')),
                        ],
                        rows: vehicleRecords.map((record) {
                          final regNumber = record['regNumber'];
                          final type = record['vehicleType'];
                          final entryTime =
                              (record['entryTime'] as Timestamp?)?.toDate();
                          final exitTime =
                              (record['exitTime'] as Timestamp?)?.toDate();

                          return DataRow(cells: [
                            DataCell(Text(regNumber)),
                            DataCell(Text(type)),
                            DataCell(Text(entryTime != null
                                ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(entryTime)
                                : 'Unknown')),
                            DataCell(Text(exitTime != null
                                ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(exitTime)
                                : 'Active')),
                          ]);
                        }).toList(),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
