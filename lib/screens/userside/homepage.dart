import "package:firebase_messaging/firebase_messaging.dart";
import 'package:flutter/material.dart';
import 'package:smartvolt1/screens/userside/MenuScreen.dart';
import 'package:smartvolt1/tools/UiComponents.dart';
import '../userside/healthScreen1.dart';
import '../../models/Deviceselection.dart';
import '../../screens/userside/feedbackScreen.dart';
import '../userside/user_request _page.dart';
import '../community/community page.dart';
import 'AddMachine.dart';
import 'DashboardScreen.dart';
import 'UserProfile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<DeviceSelection> deviceSelections = [
    DeviceSelection(category: 'Home', selectedDevices: []),
    DeviceSelection(category: 'Office', selectedDevices: []),
    DeviceSelection(category: 'Garden', selectedDevices: []),
    DeviceSelection(category: 'Industry', selectedDevices: []),
  ];
  int _selectedIndex = 1;

  final List<Widget> _pages = <Widget>[
    Dashboardscreen(),
    Menuscreen(),
    QueryListPage(),
    ProfileScreen(),
  ];

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    try {
      messaging.subscribeToTopic('fire_alerts');
      print("Subscribed to FireAlerts");
    } catch (e) {
      print(e);
    }
    print("hello");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => healthscreen1()));
        break;

      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LeaveRequestPage()));
        break;
      case 2:
        Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Volt',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
