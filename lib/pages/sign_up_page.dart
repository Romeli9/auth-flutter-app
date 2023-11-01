import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/class_user.dart';


class SignUp extends StatefulWidget {
  final void Function()? onPressed;

  const SignUp({super.key, required this.onPressed});

  @override
  State<SignUp> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );

      // Get the download URL for "no_avatar.png" from Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('avatars/no-avatar.png');
      final downloadURL = await storageRef.getDownloadURL();

      // Function to save user data in Firestore with retry
      await saveUserDataWithRetry(downloadURL);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("The password provided is too weak."),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("The account already exists for that email."),
            ),
          );
        }
      } else {
        print(e);
      }
    }
  }

  // Function to save user data in Firestore with retry
  Future<void> saveUserDataWithRetry(String downloadURL) async {
    for (int i = 0; i < 5; i++) {
      try {
        final user = Users(email: _email.text, username: _username.text, image: downloadURL);
        print('я начал');
        await FirebaseFirestore.instance.collection('users').doc(_email.text).set(user.toJson());
        print('я закончил');
        return;
      } catch (e) {
        // Handle the error (e.g., log or show a message)
        print('Error saving user data: $e');
      }
      // Add a delay before the next retry (you can adjust this as needed)
      await Future.delayed(Duration(seconds: 1));
    }
    // Handle the case when all retries fail
    print('Failed to save user data after 3 retries.');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: OverflowBar(
              overflowSpacing: 20,
              children: [
                TextFormField(
                  controller: _email,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Email is empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),
                TextFormField(
                  controller: _username, // Add username field
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Username is empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Username",
                  ),
                ),
                TextFormField(
                  controller: _password,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Password is empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        createUserWithEmailAndPassword();
                      }
                    },
                    child: isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : const Text("Sign Up"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: widget.onPressed,
                    child: const Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}