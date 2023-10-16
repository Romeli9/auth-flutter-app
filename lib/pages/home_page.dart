import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MenuTab(),
    MessengerTab(),
    ProfileTab(),
  ];

  final Map<String, Icon> _navigationItems = {
    'Menu': Platform.isIOS ? Icon(CupertinoIcons.house_fill) : Icon(Icons.home),
    'Messenger': Icon(Icons.message),
    'Profile': Icon(Icons.person),
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

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'No email';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150'),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(height: 20.0),
          Text('Email: $email', style: TextStyle(fontSize: 18.0)),
        ],
      ),
    );
  }
}


class MessengerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("This is Messenger");
  }
}

class MenuTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("This is Menu");
  }
}