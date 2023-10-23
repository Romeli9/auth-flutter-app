import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MenuTab extends StatefulWidget {
  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  String username = '';
  User? user;
  final _projectNameController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  File? _projectImage;
  List<String> criteria = [];
  List<String> categories = [];
  String imageUrl = '';
  List<ProjectWidget> projects = [];

  // Sample values for Требуется and Категории
  List<String> sampleCriteria = ['Критерий 1', 'Критерий 2', 'Критерий 3'];
  List<String> sampleCategories = ['Категория 1', 'Категория 2', 'Категория 3'];

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 10.0),
              Text(
                'Добро пожаловать, $username!',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Ваши проекты',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {
            _showCreateProjectDialog();
          },
          child: Text('+'),
        ),
        SizedBox(height: 20.0),
        Expanded(
          child: ListView(
            children: projects,
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateProjectDialog() async {
    List<String> selectedCriteria = [];
    List<String> selectedCategories = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Создать проект'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _projectNameController,
                    decoration: InputDecoration(labelText: 'Название проекта'),
                  ),
                  TextField(
                    controller: _projectDescriptionController,
                    decoration: InputDecoration(labelText: 'Описание проекта'),
                  ),
                  Row(
                    children: [
                      Text('Требуется: '),
                      for (var criterion in selectedCriteria)
                        Chip(
                          label: Text(criterion),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          _showCriteriaCategoryDialog(
                            'Требуется',
                            selectedCriteria,
                            sampleCriteria,
                                (selectedValues) {
                              setState(() {
                                selectedCriteria = selectedValues;
                              });
                            },
                          );
                        },
                        child: Text('+'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Категории: '),
                      for (var category in selectedCategories)
                        Chip(
                          label: Text(category),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          _showCriteriaCategoryDialog(
                            'Категории',
                            selectedCategories,
                            sampleCategories,
                                (selectedValues) {
                              setState(() {
                                selectedCategories = selectedValues;
                              });
                            },
                          );
                        },
                        child: Text('+'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      criteria = selectedCriteria;
                      categories = selectedCategories;
                      final url = 'https://i.pravatar.cc/200';
                      createProject(_projectNameController.text, _projectDescriptionController.text, url, criteria, categories);
                      Navigator.of(context).pop();
                    },
                    child: Text('Создать проект'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCriteriaCategoryDialog(
      String title,
      List<String> selectedValues,
      List<String> allValues,
      Function(List<String>) onSelected,
      ) async {
    List<String> tempSelectedValues = List.from(selectedValues);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (var value in allValues)
                Row(
                  children: [
                    Text(value),
                    Spacer(),
                    Checkbox(
                      value: tempSelectedValues.contains(value),
                      onChanged: (bool? newValue) {
                        if (newValue != null && newValue) {
                          tempSelectedValues.add(value);
                        } else {
                          tempSelectedValues.remove(value);
                        }
                        onSelected(tempSelectedValues);
                      },
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  onSelected(tempSelectedValues);
                  Navigator.of(context).pop();
                },
                child: Text('Готово'),
              ),
            ],
          ),
        );
      },
    );
  }


  void createProject(String projectName, String projectDescription, String imageUrl, List<String> criteria, List<String> categories) {
    // Add the created project to the list and display it
    final newProject = ProjectWidget(
      projectName: projectName,
      projectDescription: projectDescription,
      projectAvatarUrl: imageUrl,
      criteria: criteria,
      categories: categories,
    );
    setState(() {
      projects.add(newProject);
    });

    // Save project data to Firestore or perform other actions as needed
    FirebaseFirestore.instance.collection('projects').add({
      'name': projectName,
      'description': projectDescription,
      'avatarUrl': imageUrl,
      'criteria': criteria,
      'categories': categories,
    });
  }
}

class ProjectWidget extends StatelessWidget {
  final String projectName;
  final String projectDescription;
  final String projectAvatarUrl;
  final List<String> criteria;
  final List<String> categories;

  ProjectWidget({
    required this.projectName,
    required this.projectDescription,
    required this.projectAvatarUrl,
    required this.criteria,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(projectAvatarUrl),
          ListTile(
            title: Text(projectName),
            subtitle: Text(projectDescription),
          ),
          Row(
            children: [
              Text('Требуется: '),
              for (var criterion in criteria)
                Chip(
                  label: Text(criterion),
                ),
            ],
          ),
          Row(
            children: [
              Text('Категории: '),
              for (var category in categories)
                Chip(
                  label: Text(category),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
