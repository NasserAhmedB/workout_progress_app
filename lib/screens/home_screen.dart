import 'package:flutter/material.dart';
import '../services/workout_service.dart';
import '../services/settings_service.dart';
import '../data/exercise_data.dart';
import '../models/exercise.dart';
import 'exercise_detail_screen.dart';
import 'history_screen.dart';
import 'add_exercise_screen.dart';

class HomeScreen extends StatefulWidget {
  final WorkoutService workoutService;
  final SettingsService settingsService;

  const HomeScreen({
    super.key,
    required this.workoutService,
    required this.settingsService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final categories = ExerciseData.getCategories();
    List<Exercise> exercises = widget.workoutService.getExercisesByCategory(_selectedCategory);

    if (_searchQuery.isNotEmpty) {
      exercises = exercises
          .where((e) => e.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Progress'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(workoutService: widget.workoutService),
                ),
              );
            },
            tooltip: 'Workout History',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Category chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Exercise list
          Expanded(
            child: exercises.isEmpty
                ? const Center(
                    child: Text('No exercises found'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(exercise.category),
                            child: Icon(
                              _getCategoryIcon(exercise.category),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            exercise.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(exercise.category),
                          trailing: const Icon(Icons.chevron_right),
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
                            );
                          },
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
              builder: (context) => AddExerciseScreen(workoutService: widget.workoutService),
            ),
          );
          if (result == true) {
            setState(() {
              // Refresh the list
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Exercise'),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
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
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
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
}
