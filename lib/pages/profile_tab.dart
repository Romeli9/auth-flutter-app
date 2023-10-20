import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  User? user;
  String username = '';

  @override
  void initState() {
    super.initState();
    // Получить текущего пользователя
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Получить username из Firestore при загрузке страницы
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .get()
          .then((documentSnapshot) {
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          final userUsername = data['username'];
          setState(() {
            username = userUsername;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = user?.email ?? 'No email';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(height: 20.0),
          Text('Email: $email', style: TextStyle(fontSize: 18.0)),
          Text('Username: $username', style: TextStyle(fontSize: 18.0),),
        ],
      ),
    );
  }
}