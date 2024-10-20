import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceDetailScreen extends StatelessWidget {
  final String deviceId;

  DeviceDetailScreen({required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device $deviceId')),
      body: Center(
        child: Text('Details for Device: $deviceId'),
      ),
    );
  }
}
