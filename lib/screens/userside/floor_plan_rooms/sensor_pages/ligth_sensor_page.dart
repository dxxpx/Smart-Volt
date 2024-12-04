import 'dart:math';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../../../../services/BlynkService.dart';

import '../../../../tools/Custom_Led_Switch.dart';

class LedControlPage extends StatefulWidget {
  final BlynkService blynkService;
  final String pin;
  final int? people;

  LedControlPage({required this.blynkService, required this.pin, this.people});

  @override
  _LedControlPageState createState() => _LedControlPageState();
}

class _LedControlPageState extends State<LedControlPage> {
  double ledBrightness = 50.0; // Dummy value for brightness (0-100)
  final ValueNotifier<bool> _controller = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _fetchInitialLEDStatus();
  }

  Future<void> _fetchInitialLEDStatus() async {
    String pinstatus = await widget.blynkService.readPin(widget.pin);
    bool pin = '1' == pinstatus;
    if (widget.people == 0 && pin) {
      await widget.blynkService.writePin(widget.pin, '0');
      pin = !pin;
      _controller.value = pin;
    }
    setState(() {
      _controller.value = pin;
      ledBrightness = 50.0;
    });
  }

  void _onLedSwitchChanged(bool state) async {
    print("Switch Toggled: $state");
    try {
      await widget.blynkService.writePin(widget.pin, state ? '1' : '0');
      setState(() {
        _controller.value = state;
      });
    } catch (e) {
      print('Error updating LED status: $e');
    }
  }

  void _onSliderChanged(double value) {
    setState(() {
      ledBrightness = value;
    });
    // await widget.blynkService.writePin('V2', value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LED Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _controller.value != true && _controller.value != false
                ? CircularProgressIndicator()
                : AdvancedSwitch(
                    height: 55,
                    width: 160,
                    controller: _controller,
                    activeColor: Colors.yellow,
                    inactiveColor: Colors.grey,
                    onChanged: (value) {
                      _controller.value = value;
                      _onLedSwitchChanged(_controller.value);
                    },
                  ),
            SizedBox(height: 20),
            Text(
              'Brightness: ${ledBrightness.toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 20),
            ),
            Slider(
              value: ledBrightness,
              min: 0.0,
              max: 100.0,
              divisions: 100,
              onChanged: _onSliderChanged,
              activeColor: Colors.yellow,
              inactiveColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
