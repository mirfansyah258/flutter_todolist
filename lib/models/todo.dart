import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final bool completed;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Todo({required this.id, required this.title, required this.completed, required this.createdAt, required this.updatedAt});

  factory Todo.fromFirestore(DocumentSnapshot snapshot) {
    return Todo(
      id: snapshot.id,
      title: snapshot.get('title') as String,
      completed: snapshot.get('completed') as bool,
      createdAt: snapshot.get('createdAt') as Timestamp,
      updatedAt: snapshot.get('updatedAt') as Timestamp,
    );
  }
}