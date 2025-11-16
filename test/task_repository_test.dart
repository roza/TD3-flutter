import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:td3/models/task.dart';
import 'package:td3/repository/task_repository.dart';
import 'package:flutter/material.dart';

/// Tests d'intégration pour TaskRepository avec base de données en mémoire
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Database database;
  late TaskRepository repository;

  setUp(() async {
    // Initialize FFI for desktop testing
    sqfliteFfiInit();

    // Create an in-memory database for each test
    database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE tasks (
              id INTEGER PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT,
              tags TEXT,
              nbhours INTEGER,
              difficulty INTEGER,
              color INTEGER
            )
          ''');
        },
      ),
    );

    // Create repository with test database
    repository = TaskRepository(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  group('TaskRepository Integration Tests', () {
    test('create inserts a task into database', () async {
      // Arrange
      final task = Task(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        tags: ['tag1', 'tag2'],
        nbhours: 5,
        difficulty: 3,
        color: Colors.blue,
      );

      // Act
      await repository.create(task);

      // Assert
      final result = await repository.read(1);
      expect(result, isNotNull);
      expect(result?.title, 'Test Task');
      expect(result?.description, 'Test Description');
      expect(result?.tags, ['tag1', 'tag2']);
      expect(result?.nbhours, 5);
      expect(result?.difficulty, 3);
    });

    test('readAll returns all tasks', () async {
      // Arrange
      final task1 = Task(
        id: 1,
        title: 'Task 1',
        description: 'Desc 1',
        tags: ['tag1'],
        nbhours: 1,
        difficulty: 1,
        color: Colors.blue,
      );
      final task2 = Task(
        id: 2,
        title: 'Task 2',
        description: 'Desc 2',
        tags: ['tag2'],
        nbhours: 2,
        difficulty: 2,
        color: Colors.red,
      );

      await repository.create(task1);
      await repository.create(task2);

      // Act
      final tasks = await repository.readAll();

      // Assert
      expect(tasks.length, 2);
      expect(tasks[0].title, 'Task 1');
      expect(tasks[1].title, 'Task 2');
    });

    test('update modifies existing task', () async {
      // Arrange
      final task = Task(
        id: 1,
        title: 'Original',
        description: 'Original Desc',
        tags: ['tag'],
        nbhours: 1,
        difficulty: 1,
        color: Colors.blue,
      );
      await repository.create(task);

      final updatedTask = Task(
        id: 1,
        title: 'Updated',
        description: 'Updated Desc',
        tags: ['new-tag'],
        nbhours: 5,
        difficulty: 5,
        color: Colors.green,
      );

      // Act
      await repository.update(updatedTask);

      // Assert
      final result = await repository.read(1);
      expect(result?.title, 'Updated');
      expect(result?.description, 'Updated Desc');
      expect(result?.tags, ['new-tag']);
      expect(result?.nbhours, 5);
    });

    test('delete removes task from database', () async {
      // Arrange
      final task = Task(
        id: 1,
        title: 'To Delete',
        description: 'Will be deleted',
        tags: ['tag'],
        nbhours: 1,
        difficulty: 1,
        color: Colors.blue,
      );
      await repository.create(task);

      // Act
      await repository.delete(1);

      // Assert
      final result = await repository.read(1);
      expect(result, isNull);
    });

    test('getMaxId returns highest id', () async {
      // Arrange
      final task1 = Task(
        id: 5,
        title: 'Task 5',
        description: 'Desc',
        tags: ['tag'],
        nbhours: 1,
        difficulty: 1,
        color: Colors.blue,
      );
      final task2 = Task(
        id: 10,
        title: 'Task 10',
        description: 'Desc',
        tags: ['tag'],
        nbhours: 1,
        difficulty: 1,
        color: Colors.blue,
      );

      await repository.create(task1);
      await repository.create(task2);

      // Act
      final maxId = await repository.getMaxId();

      // Assert
      expect(maxId, 10);
    });

    test('getMaxId returns 0 when database is empty', () async {
      // Act
      final maxId = await repository.getMaxId();

      // Assert
      expect(maxId, 0);
    });

    test('count returns number of tasks', () async {
      // Arrange
      expect(await repository.count(), 0);

      final task = Task(
        id: 1,
        title: 'Task',
        description: 'Desc',
        tags: ['tag'],
        nbhours: 1,
        difficulty: 1,
        color: Colors.blue,
      );
      await repository.create(task);

      // Act
      final count = await repository.count();

      // Assert
      expect(count, 1);
    });
  });
}
