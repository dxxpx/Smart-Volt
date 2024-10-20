import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // Data for the profile
  final String email = "deepika@gmail.com";
  final String fcmtoken =
      "dmFzWdDrQoSb0L8A_bcv74:APA91bEXJ-4e1joqZKXd8SvuRUI7MG7DYHTICyOnMGwt6dxNEHhpjmKhHBCkUFo3wiv_daXK_JTXSczq9CBFHd3vV5W43r-YQHeQ3uHB1pIshCqwoEpq8kXEbaOPIQ5AL-Vt3ZXYCtI5";
  final String name = "Deepika";
  final String password = "123456";
  final String targetDuration = "Weekly";
  final int targetValue = 30000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileDetailRow(title: 'Name', value: name),
              ProfileDetailRow(title: 'Email', value: email),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const ProfileDetailRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
