import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:td3/models/task.dart';
import 'package:td3/ViewModel/task_view_model.dart';

class TaskForm extends StatefulWidget {
  final Task? task; // null = mode création, non-null = mode édition

  const TaskForm({super.key, this.task});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  late TextEditingController _nbhoursController;
  late TextEditingController _difficultyController;

  bool get isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    // Initialise les contrôleurs avec les valeurs existantes ou vides
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _tagsController =
        TextEditingController(text: widget.task?.tags.join(', ') ?? '');
    _nbhoursController =
        TextEditingController(text: widget.task?.nbhours.toString() ?? '0');
    _difficultyController =
        TextEditingController(text: widget.task?.difficulty.toString() ?? '0');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _nbhoursController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final taskViewModel = context.read<TaskViewModel>();

      // Parse les tags (séparés par des virgules)
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      if (isEditMode) {
        // Mode édition : met à jour la tâche existante
        final updatedTask = Task(
          id: widget.task!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          tags: tags,
          nbhours: int.parse(_nbhoursController.text),
          difficulty: int.parse(_difficultyController.text),
          color: widget.task!.color,
        );
        await taskViewModel.updateTask(updatedTask);
      } else {
        // Mode création : utilise Task.newTask() pour gérer l'auto-incrémentation
        Task.nb++; // Incrémente d'abord le compteur
        final newTask = Task(
          id: Task.nb,
          title: _titleController.text,
          description: _descriptionController.text,
          tags: tags,
          nbhours: int.parse(_nbhoursController.text),
          difficulty: int.parse(_difficultyController.text),
          color: Colors.lightBlue,
        );
        await taskViewModel.addTask(newTask);
      }

      // Retour à l'écran précédent
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _deleteTask() async {
    // Affiche une confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la tâche ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<TaskViewModel>().deleteTask(widget.task!.id);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Modifier la tâche' : 'Nouvelle tâche'),
        actions: isEditMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: _deleteTask,
                ),
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Titre
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                icon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le titre est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                icon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La description est requise';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Tags
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (séparés par des virgules)',
                icon: Icon(Icons.label),
                border: OutlineInputBorder(),
                hintText: 'tag1, tag2, tag3',
              ),
            ),
            const SizedBox(height: 16),

            // Nombre d'heures
            TextFormField(
              controller: _nbhoursController,
              decoration: const InputDecoration(
                labelText: 'Nombre d\'heures',
                icon: Icon(Icons.schedule),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le nombre d\'heures est requis';
                }
                if (int.tryParse(value) == null) {
                  return 'Doit être un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Difficulté
            TextFormField(
              controller: _difficultyController,
              decoration: const InputDecoration(
                labelText: 'Difficulté (0-20)',
                icon: Icon(Icons.trending_up),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La difficulté est requise';
                }
                final difficulty = int.tryParse(value);
                if (difficulty == null) {
                  return 'Doit être un nombre';
                }
                if (difficulty < 0 || difficulty > 20) {
                  return 'Doit être entre 0 et 20';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Bouton Enregistrer
            ElevatedButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save),
              label: Text(isEditMode ? 'Enregistrer' : 'Créer'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
