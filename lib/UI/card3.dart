import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:td3/models/task.dart';
import 'package:td3/UI/detail.dart';

class Ecran3 extends StatelessWidget {
  const Ecran3({super.key});

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/todos'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        return jsonList.map((json) {
          return Task(
            id: json['id'] ?? 0,
            title: json['title'] ?? '',
            tags: ["user ${json['userId'] ?? 0}"],
            nbhours: 0,
            difficulty: (json['completed'] ?? false) ? 1 : 0,
            description:
                "Tâche ${json['id'] ?? 0} pour l'utilisateur ${json['userId'] ?? 0}\n"
                "Statut : ${(json['completed'] ?? false) ? "Terminée" : "En cours"}",
            color: (json['completed'] ?? false)
                ? Colors.greenAccent
                : Colors.redAccent,
          );
        }).toList();
      } else {
        debugPrint('Status code: ${response.statusCode}');
        return _mockTasks();
      }
    } catch (e) {
      debugPrint('Erreur HTTP: $e');
      return _mockTasks();
    }
  }

  // Fallback tasks si l'API échoue
  List<Task> _mockTasks() {
    return List.generate(10, (index) {
      return Task(
        id: index + 1,
        title: 'Tâche Mock ${index + 1}',
        tags: ['mock user'],
        nbhours: 0,
        difficulty: 0,
        description: 'Description de la tâche mock ${index + 1}',
        color: Colors.blueAccent,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: fetchTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final tasks = snapshot.data ?? [];

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              color: Theme.of(context).cardColor,
              elevation: 7,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 0, 247, 226),
                  child: Text(task.id.toString()),
                ),
                title: Text(task.title),
                subtitle: Text(task.tags.join(" ")),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detail(task: task),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
