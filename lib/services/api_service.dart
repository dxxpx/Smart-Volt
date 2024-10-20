import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/EnergyModel.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchAndSaveDeviceData(
      {required String deviceId, required String authToken}) async {
    final response = await http
        .get(Uri.parse('http://blynk-cloud.com/$authToken/get/V0,V1,V2,V3,V4'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Convert the received data to DeviceData
      DeviceData deviceData = DeviceData(
        deviceId: deviceId,
        voltage: data[0],
        current: data[1],
        vibration: data[2],
        temperature: data[3],
        humidity: data[4],
        onHours: calculateOnHours(data[0], data[1]),
      );

      // Store device data in Firebase Firestore
      await _firestore
          .collection('devices')
          .doc(deviceId)
          .collection('data')
          .doc(DateTime.now().toIso8601String())
          .set(deviceData.toFirestore());
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Calculate ON hours based on voltage/current being non-zero
  double calculateOnHours(double voltage, double current) {
    return (voltage > 0 && current > 0)
        ? 1.0
        : 0.0; // For simplicity, increments by 1 hour.
  }
}
