import 'package:flutter/material.dart';

import '../model/task.dart';

class TaskTile extends StatefulWidget {
  const TaskTile(
      {required this.task, required this.onDelete, required this.onChecked});

  final Task task;
  final Future<void> Function(String) onDelete;
  final Future<void> Function(String, bool) onChecked;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _isLoading = false;

  void _handleCheck() async {
    setState(() {
      _isLoading = true;
    });

    await widget.onChecked(widget.task.id ?? "", !(widget.task.status));
    // await customOnChecked(widget.task.id ?? "", !(widget.task.status));

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
    widget.task.status;
  }

  Future<void> customOnChecked(String id, bool status) async {
    // Replace this with your actual implementation
    await Future.delayed(Duration(seconds: 1));

    widget.onChecked(id, status);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.task.status
          ? Color.fromARGB(255, 100, 250, 100)
          : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.texte,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.task.dateAjout.toString()),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => widget.onDelete(widget.task.id ?? ""),
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: widget.task.status
                              ? Icon(Icons.check_box)
                              : Icon(Icons.check_box_outline_blank),
                          onPressed: _handleCheck,
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
