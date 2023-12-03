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

  String emailError = '';
  String usernameError = '';
  String passwordError = '';

  createUserWithEmailAndPassword() async {
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

      // Save user data, including username and image URL, in Firestore
      final user = Users(email: _email.text, username: _username.text, image: downloadURL);
      await FirebaseFirestore.instance.collection('users').doc(_email.text).set(user.toJson());

      setState(() {
        isLoading = false;
        emailError = '';
        usernameError = '';
        passwordError = '';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        emailError = "Неправильная почта";
        usernameError = '';
        passwordError = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBE9DE8),
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
                  onChanged: (text) {
                    setState(() {
                      emailError = ''; // Сбрасываем ошибку при изменении текста
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: emailError.isNotEmpty ? emailError : null,
                  ),
                ),
                TextFormField(
                  controller: _username,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Username is empty";
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      usernameError = ''; // Сбрасываем ошибку при изменении текста
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Username",
                    errorText: usernameError.isNotEmpty ? usernameError : null,
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
                  onChanged: (text) {
                    setState(() {
                      passwordError = ''; // Сбрасываем ошибку при изменении текста
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: passwordError.isNotEmpty ? passwordError : null,
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
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFBE9DE8),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
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
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFBE9DE8),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
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
