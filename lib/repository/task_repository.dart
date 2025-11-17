import 'package:sqflite/sqflite.dart';
import 'package:td3/database/database_helper.dart';
import 'package:td3/models/task.dart';

class TaskRepository {
  final String tableName = 'tasks';
  final Database? _testDatabase;

  // Constructor permettant l'injection d'une base de données pour les tests
  TaskRepository({Database? database}) : _testDatabase = database;

  // Récupère la base de données (test ou production)
  Future<Database> get _database async {
    if (_testDatabase != null) {
      return _testDatabase!;
    }
    return await DatabaseHelper.instance.database;
  }

  // Créer une tâche
  Future<Task> create(Task task) async {
    final db = await _database;
    // Utiliser toMap(includeId: false) pour laisser SQLite générer l'ID
    final id = await db.insert(tableName, task.toMap(includeId: false));
    // Retourner la tâche avec son ID généré par la base de données
    task.id = id;
    return task;
  }

  // Lire toutes les tâches
  Future<List<Task>> readAll() async {
    final db = await _database;
    const orderBy = 'id ASC';
    final result = await db.query(tableName, orderBy: orderBy);

    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Lire une tâche par ID
  Future<Task?> read(int id) async {
    final db = await _database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Mettre à jour une tâche
  Future<int> update(Task task) async {
    final db = await _database;
    return db.update(
      tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Supprimer une tâche
  Future<int> delete(int id) async {
    final db = await _database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Supprimer toutes les tâches
  Future<int> deleteAll() async {
    final db = await _database;
    return await db.delete(tableName);
  }

  // Compter le nombre de tâches
  Future<int> count() async {
    final db = await _database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Obtenir le dernier ID utilisé
  Future<int> getMaxId() async {
    final db = await _database;
    final result = await db.rawQuery('SELECT MAX(id) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
