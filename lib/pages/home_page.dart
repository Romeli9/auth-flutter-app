import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final user = FirebaseAuth.instance.currentUser;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Page"),
        actions: [IconButton(
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.login)
        ),
        ],
      ),
      body: Center(
        child: Text(user!.email.toString()),
      ),
    );
  }
}