import 'package:flutter/foundation.dart';
import 'package:td3/models/task.dart';

class TaskViewModel extends ChangeNotifier {
  late List<Task> liste;

  TaskViewModel() {
    liste = [];
  }

  void addTask(Task task) {
    liste.add(task);
    notifyListeners();
  }

  void generateTasks() {
    liste = Task.generateTask(50);
    notifyListeners();
  }
}
