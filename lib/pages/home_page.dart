import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:untitled2/pages/profile_tab.dart';
import 'package:untitled2/pages/menu_tab.dart';
import 'package:untitled2/pages/messanger_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ProfileTab(),
    MenuTab(),
    MessengerTab()
  ];

  final Map<String, Icon> _navigationItems = {
    'Profile': Icon(Icons.person),
    'Menu': Platform.isIOS ? Icon(CupertinoIcons.house_fill) : Icon(Icons.home),
    'Messenger': Icon(Icons.message)
  };

  void _loadScreen() {
    // Implement loading of the selected screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team IT'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Handle logout action here
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Platform.isIOS
          ? CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _loadScreen();
        },
        items: _navigationItems.entries
            .map<BottomNavigationBarItem>(
              (entry) => BottomNavigationBarItem(
            icon: entry.value,
            label: entry.key,
          ),
        )
            .toList(),
      )
          : BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _loadScreen();
        },
        items: _navigationItems.entries
            .map<BottomNavigationBarItem>(
              (entry) => BottomNavigationBarItem(
            icon: entry.value,
            label: entry.key,
          ),
        )
            .toList(),
      ),
    );
  }
}

class TabContent extends StatelessWidget {
  final String title;

  TabContent({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Content of $title Tab'),
    );
  }
}
