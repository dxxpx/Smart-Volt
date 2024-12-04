import 'package:flutter/material.dart';
import './AdminMenuSection.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 1;

  // List of screens to display for each tab
  final List<Widget> _screens = [
    Center(child: Text('Announcements Page', style: TextStyle(fontSize: 24))),
    MenuSectionAdmin(),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Highlight the selected item
        selectedItemColor: Colors.blue, // Blue color for selected item
        unselectedItemColor: Colors.grey, // Grey color for unselected items
        onTap: _onItemTapped, // Handle item tap
        showUnselectedLabels: true, // Always show labels
        type: BottomNavigationBarType.fixed, // Fixed layout for all items
      ),
    );
  }
}
