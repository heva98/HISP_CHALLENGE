import 'package:flutter/material.dart';
import 'package:hisp/screens/auth_ui/welcome/todolist.dart';

void main() {
  runApp(MyApp());
}

class Todo {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final String created;
  final String lastUpdated;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.created,
    required this.lastUpdated,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      created: json['created'],
      lastUpdated: json['lastUpdated'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

