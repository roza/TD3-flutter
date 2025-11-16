import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:td3/UI/task_form.dart';
import 'package:td3/ViewModel/task_view_model.dart';

class Ecran1 extends StatelessWidget {
  const Ecran1({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskViewModel>().liste;

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Theme.of(context).cardColor,
          elevation: 7,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Text(tasks[index].id.toString()),
            ),
            title: Text(tasks[index].title),
            subtitle: Text(tasks[index].tags.join(" ")),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskForm(task: tasks[index]), // Mode édition
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}