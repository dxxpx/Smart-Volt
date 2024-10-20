import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Authentication/LoginScreen.dart';
import 'firebase_options.dart';
import 'Authentication/SignInPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    await _firebaseMessaging.requestPermission();

    final String? fcmtoken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmtoken');
  } catch (e) {
    print('Error initializing Firebase or Firebase Messaging: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.subscribeToTopic('fire_alerts');
    return MaterialApp(
      title: 'Smart Volt',
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
