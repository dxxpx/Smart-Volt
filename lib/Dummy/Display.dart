import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/EnergyModel.dart';

class HomeScreen extends StatelessWidget {
  final String deviceId;

  HomeScreen({required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device $deviceId Monitoring')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('devices')
            .doc(deviceId)
            .collection('data')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final deviceDocs = snapshot.data!.docs;
          if (deviceDocs.isEmpty) {
            return Center(child: Text('No Data Available'));
          }

          final deviceData = DeviceData.fromFirestore(
              deviceDocs.first.data() as Map<String, dynamic>);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Voltage: ${deviceData.voltage} V'),
              Text('Current: ${deviceData.current} A'),
              Text('Vibration: ${deviceData.vibration}'),
              Text('Temperature: ${deviceData.temperature} °C'),
              Text('Humidity: ${deviceData.humidity} %'),
              Text('ON Hours: ${deviceData.onHours} hours'),
            ],
          );
        },
      ),
    );
  }
}
