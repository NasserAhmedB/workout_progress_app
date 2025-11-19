import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/workout_service.dart';
import '../services/settings_service.dart';
import '../services/localization_service.dart';
import '../models/exercise.dart';
import 'exercise_detail_screen.dart';
import 'add_exercise_screen.dart';
import 'edit_exercise_screen.dart';

class MuscleGroupScreen extends StatefulWidget {
  final String category;
  final WorkoutService workoutService;
  final SettingsService settingsService;

  const MuscleGroupScreen({
    super.key,
    required this.category,
    required this.workoutService,
    required this.settingsService,
  });

  @override
  State<MuscleGroupScreen> createState() => _MuscleGroupScreenState();
}

class _MuscleGroupScreenState extends State<MuscleGroupScreen> {
  String _searchQuery = '';
  List<Exercise> _exercises = [];

  String get _language => widget.settingsService.getLanguage();
  
  String _t(String key) {
    return LocalizationService.t(key, _language);
  }

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() {
    setState(() {
      _exercises = widget.workoutService.getExercisesByCategory(widget.category);
      if (_searchQuery.isNotEmpty) {
        _exercises = _exercises
            .where((e) => e.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case 'Chest':
        return Colors.red;
      case 'Back':
        return Colors.blue;
      case 'Shoulders':
        return Colors.orange;
      case 'Legs':
        return Colors.green;
      case 'Arms':
        return Colors.purple;
      case 'Core':
        return Colors.teal;
      default:
        return Colors.deepPurple;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.category) {
      case 'Chest':
        return Icons.fitness_center;
      case 'Back':
        return Icons.accessibility_new;
      case 'Shoulders':
        return Icons.sports_gymnastics;
      case 'Legs':
        return Icons.directions_run;
      case 'Arms':
        return Icons.sports_martial_arts;
      case 'Core':
        return Icons.self_improvement;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 24,
                      child: Icon(
                        _getCategoryIcon(),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '${_exercises.length} ${_t('exercises')}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _t('search_exercises'),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _loadExercises();
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Exercise list
              Expanded(
                child: _exercises.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _t('no_exercises_found'),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = _exercises[index];
                          return _buildExerciseCard(exercise, color);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExerciseScreen(
                workoutService: widget.workoutService,
                preselectedCategory: widget.category != 'All' ? widget.category : null,
              ),
            ),
          );
          if (result == true) {
            _loadExercises();
          }
        },
        backgroundColor: color,
        icon: const Icon(Icons.add),
        label: Text(_t('add_exercise')),
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseDetailScreen(
                exercise: exercise,
                workoutService: widget.workoutService,
                settingsService: widget.settingsService,
              ),
            ),
          ).then((_) => _loadExercises());
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Exercise image or icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: exercise.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.network(
                                exercise.imagePath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.fitness_center,
                                    size: 40,
                                    color: color,
                                  );
                                },
                              )
                            : Image.file(
                                File(exercise.imagePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.fitness_center,
                                    size: 40,
                                    color: color,
                                  );
                                },
                              ),
                      )
                    : Icon(
                        Icons.fitness_center,
                        size: 40,
                        color: color,
                      ),
              ),
              const SizedBox(width: 16),

              // Exercise info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            exercise.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (exercise.tutorialUrl != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_circle_filled,
                                  size: 14,
                                  color: Colors.blue[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _t('tutorial'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (exercise.description != null)
                      Text(
                        exercise.description!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            exercise.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (exercise.isCustom) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 12,
                                  color: Colors.amber[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _t('custom'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'edit') {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditExerciseScreen(
                          exercise: exercise,
                          workoutService: widget.workoutService,
                        ),
                      ),
                    );
                    if (result == true) {
                      _loadExercises();
                    }
                  } else if (value == 'delete') {
                    _confirmDelete(exercise);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit, size: 20),
                        const SizedBox(width: 12),
                        Text(_t('edit')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 20, color: Colors.red),
                        const SizedBox(width: 12),
                        Text(_t('delete'), style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Exercise exercise) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t('delete_exercise')),
        content: Text('${_t('delete_exercise_confirmation')} "${exercise.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_t('delete'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.workoutService.deleteExercise(exercise.id);
      _loadExercises();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${exercise.name} deleted'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
