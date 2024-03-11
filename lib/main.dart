import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todolist/models/todo.dart';
import 'package:flutter_todolist/services/todo_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'ToDo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final todoService = TodoService();
  final _todoController = TextEditingController();
  final List<String> items = List<String>.generate(100, (i) => 'Item $i');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: todoService.getTodos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.hasData) {
                  final todos = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(todos[index].title),
                        value: todos[index].completed,
                        onChanged: (newValue) => todoService.updateTodo(todos[index].id, newValue!),
                      );
                    },
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    todoService.addTodo(_todoController.text);
                    _todoController.text = '';
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
