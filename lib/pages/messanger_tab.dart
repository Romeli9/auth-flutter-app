import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessengerTab extends StatefulWidget {
  @override
  _MessengerTabState createState() => _MessengerTabState();
}

class _MessengerTabState extends State<MessengerTab> {
  List<Application> userApplications = [];

  @override
  void initState() {
    super.initState();
    fetchUserApplications();
  }

  Future<void> fetchUserApplications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();

      final username = userData.docs.first['username'];

      final applicationsQuery = await FirebaseFirestore.instance
          .collection('applications')
          .where('projectCreatorName', isEqualTo: username)
          .get();

      final List<Application> fetchedApplications = applicationsQuery.docs
          .map((doc) => Application(
        skills: doc['skills'],
        experience: doc['experience'],
        telegram: doc['telegram'],
      ))
          .toList();

      setState(() {
        userApplications = fetchedApplications;
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ApplicationsList(applications: userApplications),
    );
  }
}


class Application {
  final String skills;
  final String experience;
  final String telegram;

  Application({
    required this.skills,
    required this.experience,
    required this.telegram,
  });
}

class ApplicationsList extends StatelessWidget {
  final List<Application> applications;

  ApplicationsList({required this.applications});

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) {
      return Center(child: Text('Нет заявок.'));
    }

    return ListView.builder(
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];

        return Card(
          margin: EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(
              'Навыки: ${application.skills}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Опыт работы: ${application.experience}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'Телеграмм: ${application.telegram}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
