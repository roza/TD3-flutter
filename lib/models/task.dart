import 'package:flutter/material.dart';

class Task {
  static int nb = 0; // Compteur statique pour générer des IDs uniques

  int id;
  String title;
  List<String> tags;
  int nbhours;
  int difficulty;
  String description;
  Color color;

  Task({
    required this.id,
    required this.title,
    required this.tags,
    required this.nbhours,
    required this.difficulty,
    required this.description,
    required this.color,
  });

  // Factory pour créer une nouvelle tâche avec un ID auto-incrémenté
  factory Task.newTask() {
    nb++;
    return Task(
      id: nb,
      title: 'title $nb',
      tags: ['tag $nb'],
      nbhours: nb,
      difficulty: nb % 5,
      description: 'description $nb',
      color: Colors.lightBlue,
    );
  }

  static List<Task> generateTask(int i) {
    List<Task> tasks = [];
    for (int n = 0; n < i; n++) {
      tasks.add(
        Task(
          id: n,
          title: "title $n",
          tags: ['tag $n', 'tag${n + 1}'],
          nbhours: n,
          difficulty: n,
          description: '$n',
          color: Colors.lightBlue,
        ),
      );
    }
    return tasks;
  }

  static Task fromJson(Map<String, dynamic> json) {
    final tags =
        (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];

    return Task(
      id: json['id'],
      title: json['title'],
      tags: tags,
      nbhours: json['nbhours'],
      difficulty: json['difficulty'],
      description: json['description'],
      color: json['color'] != null
          ? Color(int.parse(json['color'], radix: 16))
          : Colors.greenAccent,
    );
  }

  // Conversion en Map pour SQLite
  Map<String, dynamic> toMap({bool includeId = true}) {
    final map = {
      'title': title,
      'tags': tags.join(','), // Stocke les tags comme une chaîne séparée par virgules
      'nbhours': nbhours,
      'difficulty': difficulty,
      'description': description,
      // ignore: deprecated_member_use
      'color': color.value, // Stocke la valeur numérique de la couleur
    };

    // Inclure l'ID seulement si demandé (pour les updates, pas pour les inserts)
    if (includeId) {
      map['id'] = id;
    }

    return map;
  }

  // Création d'une Task depuis une Map SQLite
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      tags: (map['tags'] as String).split(','), // Reconvertit la chaîne en liste
      nbhours: map['nbhours'] as int,
      difficulty: map['difficulty'] as int,
      description: map['description'] as String,
      color: Color(map['color'] as int),
    );
  }
}
