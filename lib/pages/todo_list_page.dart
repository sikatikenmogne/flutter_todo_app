import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/task.dart';
import 'add_task_page.dart';
import 'task_tile.dart';

class ToDoListPage extends StatefulWidget {
  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  final List<Task> todoList = [];

  @override
  void initState() {
    _refreshToDoList();
    super.initState();
  }

  Future _refreshToDoList() async {
    var results = await database.collection("Tasks").get();
    todoList.clear();
    for (var doc in results.docs) {
      todoList.add(Task.convertFromMap(doc.id, doc.data()));
    }
    setState(() {});  
  }

  Future _addTask(Task newTask) async {
    try {
      database.collection("Tasks").add(Task.convertToMap(newTask)).then((doc) {
        _refreshToDoList();
      });
    } catch (e) {
      if (e is FirebaseException) {
        // Handle FirebaseException here
        print(e.message);
      } else {
        // Re-throw the exception if it's not a FirebaseException
        rethrow;
      }
    }
  }

  Future<void> _checkTask(String id, bool newStatus) async {
    database
        .collection("Tasks")
        .doc(id)
        .update({"status": newStatus.toString()}).then((doc) {
      _refreshToDoList();
    });
  }

  Future<void> _deleteTask(String id) async {
    database.collection("Tasks").doc(id).delete().then((doc) {
      _refreshToDoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ma TODO List"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            final Task task = todoList[index];
            return TaskTile(
              task: task,
              onDelete: (id) => _deleteTask(id),
              onChecked: () => _refreshToDoList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Task newTask = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddTaskPage()))
              as Task;
          _addTask(newTask);
        },
      ),
    );
  }
}
