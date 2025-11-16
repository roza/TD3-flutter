import 'package:flutter/foundation.dart';
import 'package:td3/models/task.dart';
import 'package:td3/repository/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  List<Task> liste = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  TaskViewModel() {
    _initializeViewModel();
  }

  // Initialiser le ViewModel et le compteur d'IDs
  Future<void> _initializeViewModel() async {
    // Charger le dernier ID pour continuer la numérotation
    final maxId = await _repository.getMaxId();
    Task.nb = maxId;

    // Charger les tâches existantes
    await loadTasks();
  }

  // Charger toutes les tâches depuis la base de données
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      liste = await _repository.readAll();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement des tâches: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajouter une tâche et la persister
  Future<void> addTask(Task task) async {
    try {
      await _repository.create(task);
      liste.add(task);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'ajout de la tâche: $e');
      }
    }
  }

  // Générer des tâches et les persister
  Future<void> generateTasks() async {
    try {
      // Vérifie si des tâches existent déjà
      final count = await _repository.count();
      if (count > 0) {
        // Si des tâches existent déjà, on les charge simplement
        await loadTasks();
        return;
      }

      // Sinon, on génère 50 nouvelles tâches
      final tasks = Task.generateTask(50);
      for (var task in tasks) {
        await _repository.create(task);
      }
      await loadTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la génération des tâches: $e');
      }
    }
  }

  // Supprimer une tâche
  Future<void> deleteTask(int id) async {
    try {
      await _repository.delete(id);
      liste.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression de la tâche: $e');
      }
    }
  }

  // Mettre à jour une tâche
  Future<void> updateTask(Task task) async {
    try {
      await _repository.update(task);
      final index = liste.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        liste[index] = task;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour de la tâche: $e');
      }
    }
  }
}
