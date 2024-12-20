import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/adminSide/adminHome.dart';
import '../screens/adminSide/adminHomeScreen.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController adminEmailController =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController adminPasswordController =
      TextEditingController(text: "123456");

  Future<void> _adminsignIn() async {
    try {
      if (adminEmailController.text == "admin@gmail.com" &&
          adminPasswordController.text == "123456") {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmailController.text,
          password: adminPasswordController.text,
        );

        // Navigate to the category screen after successful login
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Login')));
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
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
                    controller: adminEmailController,
                    decoration: const InputDecoration(
                        labelText: "Enter your Email : ",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: adminPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Enter your Password : ",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: _adminsignIn,
                      child: const Text('Admin Login',
                          style: TextStyle(fontWeight: FontWeight.bold)))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
