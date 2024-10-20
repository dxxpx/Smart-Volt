import 'package:flutter/material.dart';

const String baseurl =
    "https://62ae-2401-4900-6067-76df-1949-8c0c-8547-82e8.ngrok-free.app";

Color themeColor = Colors.blueAccent;
InputDecoration tbdecor({required String labelT}) {
  return InputDecoration(
      labelText: labelT,
      labelStyle: LabelTstlye(),
      filled: true,
      fillColor: Colors.white);
}

TextStyle LabelTstlye() {
  return TextStyle(color: Colors.grey, fontSize: 20);
}

TextStyle appTstyle() {
  return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
}

ButtonStyle BtnStyle() {
  return ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade200);
}

TextStyle buttonTstlye() {
  return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
}
