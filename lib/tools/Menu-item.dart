import 'package:flutter/material.dart';

Widget Menu_item(
    {required BuildContext context,
    required Widget navigate_to,
    required String item_name,
    required IconData icon}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => navigate_to,
            ));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.blue.shade50),
        child: Column(
          children: [
            Icon(
              icon,
              size: 35,
            ),
            const SizedBox(height: 10),
            Text(
              item_name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ),
  );
}
