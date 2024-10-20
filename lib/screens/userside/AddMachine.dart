import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../charts/LinearChart.dart'; // Assuming the chart screen is in a separate file

class AddMachineScreen extends StatefulWidget {
  @override
  _AddMachineScreenState createState() => _AddMachineScreenState();
}

class _AddMachineScreenState extends State<AddMachineScreen> {
  final TextEditingController _deviceNameController = TextEditingController();
  String _authToken = '';
  String _pinDetails = '';
  String _scanResult = '';

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
            SizedBox(height: 20),
            Text('Scan QR Code for Auth Token & Pin Details'),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _scanQRCode,
              icon: Icon(Icons.qr_code_scanner),
              label: Text('Scan QR Code'),
            ),
            SizedBox(height: 20),
            if (_authToken.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Auth Token: $_authToken'),
                  Text('Pin Details: $_pinDetails'),
                ],
              ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Move to the SensorChartScreen (Pass necessary details if needed)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DamagePredictionCharts(),
                    ),
                  );
                },
                child: Text('Proceed to Charts'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
