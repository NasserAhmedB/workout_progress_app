import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import '../models/exercise.dart';
import '../models/workout_set.dart';
import '../services/workout_service.dart';
import '../services/settings_service.dart';
import '../services/localization_service.dart';
import 'add_set_screen.dart';
import 'tutorial_screen.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  final WorkoutService workoutService;
  final SettingsService settingsService;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    required this.workoutService,
    required this.settingsService,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late List<WorkoutSet> _sets;
  late Map<String, dynamic> _stats;

  String get _language => widget.settingsService.getLanguage();
  
  String _t(String key) {
    return LocalizationService.t(key, _language);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _sets = widget.workoutService.getSetsForExercise(widget.exercise.id);
      _stats = widget.workoutService.getExerciseStats(widget.exercise.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final personalBest = widget.workoutService.getPersonalBest(widget.exercise.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (widget.exercise.tutorialUrl != null)
            IconButton(
              icon: const Icon(Icons.play_circle_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TutorialScreen(exercise: widget.exercise),
                  ),
                );
              },
              tooltip: _t('watch_tutorial'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Exercise image (if available)
          if (widget.exercise.imagePath != null)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: kIsWeb
                  ? Image.network(
                      widget.exercise.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                        );
                      },
                    )
                  : Image.file(
                      File(widget.exercise.imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                        );
                      },
                    ),
            ),

          // Stats cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tutorial button (if available)
                if (widget.exercise.tutorialUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TutorialScreen(exercise: widget.exercise),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_filled),
                      label: Text(_t('watch_tutorial')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                
                if (widget.exercise.description != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      widget.exercise.description!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        _t('total_sets'),
                        _stats['totalSets'].toString(),
                        Icons.repeat,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        _t('total_reps'),
                        _stats['totalReps'].toString(),
                        Icons.fitness_center,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        _t('max_weight'),
                        widget.settingsService.formatWeight(_stats['maxWeight']),
                        Icons.trending_up,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        _t('avg_weight'),
                        widget.settingsService.formatWeight(_stats['averageWeight']),
                        Icons.analytics,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
                if (personalBest != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade400),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _t('personal_best'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${widget.settingsService.formatWeight(personalBest.weight)} × ${personalBest.reps} ${_t('reps')}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('MMM dd, yyyy').format(personalBest.date),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // History header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _t('history'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${_sets.length} ${_t('sets')}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Sets list
          Expanded(
            child: _sets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _t('no_sets_recorded'),
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _t('tap_to_add_first_set'),
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _sets.length,
                    itemBuilder: (context, index) {
                      final set = _sets[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            '${widget.settingsService.formatWeight(set.weight)} × ${set.reps} ${_t('reps')}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMM dd, yyyy - HH:mm').format(set.date),
                              ),
                              if (set.notes != null && set.notes!.isNotEmpty)
                                Text(
                                  set.notes!,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(set),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSetScreen(
                exercise: widget.exercise,
                workoutService: widget.workoutService,
                settingsService: widget.settingsService,
              ),
            ),
          );
          if (result == true) {
            _loadData();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(_t('add_set')),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(WorkoutSet set) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t('delete_set')),
        content: Text(_t('delete_set_confirmation')),
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
      await widget.workoutService.deleteWorkoutSet(set.id);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t('set_deleted'))),
        );
      }
    }
  }
}
