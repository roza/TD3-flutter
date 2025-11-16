import 'package:sqflite/sqflite.dart';
import 'package:td3/database/database_helper.dart';
import 'package:td3/models/task.dart';

class TaskRepository {
  final String tableName = 'tasks';

  // Créer une tâche
  Future<Task> create(Task task) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(tableName, task.toMap());
    return task;
  }

  // Lire toutes les tâches
  Future<List<Task>> readAll() async {
    final db = await DatabaseHelper.instance.database;
    const orderBy = 'id ASC';
    final result = await db.query(tableName, orderBy: orderBy);

    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Lire une tâche par ID
  Future<Task?> read(int id) async {
    final db = await DatabaseHelper.instance.database;
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
    final db = await DatabaseHelper.instance.database;
    return db.update(
      tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Supprimer une tâche
  Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Supprimer toutes les tâches
  Future<int> deleteAll() async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(tableName);
  }

  // Compter le nombre de tâches
  Future<int> count() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Obtenir le dernier ID utilisé
  Future<int> getMaxId() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery('SELECT MAX(id) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
