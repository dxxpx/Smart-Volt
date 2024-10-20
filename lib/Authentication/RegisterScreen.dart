import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../tools/UiComponents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController deptIDController = TextEditingController();
  String fcm = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfcmToken();
  }

  void getfcmToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging.requestPermission();
    fcm = (await _firebaseMessaging.getToken())!;
    print("FCM TOKEN IS = $fcm");
  }

  Future<void> _registerUser() async {
    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: registerEmailController.text,
        password: registerPasswordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': registerEmailController.text,
        'password': registerPasswordController.text,
        'name': nameController.text,
        'fcmtoken': fcm
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registered successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      // Handle registration errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: EdgeInsets.all(10),
            color: Colors.purple.shade100,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: registerEmailController,
                    decoration: tbdecor(labelT: "Enter your Email: "),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: registerPasswordController,
                    obscureText: true,
                    decoration: tbdecor(labelT: "Enter your password : "),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: tbdecor(labelT: "Enter your Name : "),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _registerUser, child: Text('Register'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
