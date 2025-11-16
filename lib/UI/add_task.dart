import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:td3/models/task.dart';
import 'package:td3/ViewModel/task_view_model.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.lightBlue,
          ),
          onPressed: () {
            context.read<TaskViewModel>().addTask(Task.newTask());
            Navigator.pop(context);
          },
          child: const Text("Add Task"),
        ),
      ),
    );
  }
}
