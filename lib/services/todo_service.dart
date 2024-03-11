import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_todolist/models/todo.dart';

class TodoService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String todosCollection = 'todos';

  Future<void> addTodo(String title) async {
    final docRef = firestore.collection(todosCollection).doc();
    await docRef.set({
      'title': title,
      'completed': false,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  Stream<List<Todo>> getTodos() {
    return firestore.collection(todosCollection)
      .orderBy('completed')
      .orderBy('updatedAt', descending: true)
      .snapshots().map((snapshot) {
        final todos = snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList();
        return todos;
      });
  }

  Future<void> deleteTodo(String id) async {
    await firestore.collection(todosCollection).doc(id).delete();
  }

  Future<void> updateTodo(String id, bool completed) async {
    await firestore.collection(todosCollection).doc(id).update({'completed': completed, 'updatedAt': Timestamp.now()});
  }
}
