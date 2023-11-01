import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled2/pages/auth_page.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("TTT 123");
  FirebaseFirestore.instance.collection('projects').add({
    'name': 'Название проекта',
    'description': 'Описание проекта',
    'creator': 'Имя создателя',
    // Другие поля и данные, которые вы хотите добавить
  }).then((DocumentReference document) {
    print('TTT SUCCES555 Данные успешно добавлены с идентификатором: ${document.id}');
  }).catchError((error) {
    print('TTT ERROR555 Ошибка при добавлении данных: $error');
  });
  runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const AuthPage(),
    );
  }
}
