import 'package:flutter/material.dart';
import '../services/workout_service.dart';
import '../services/settings_service.dart';
import '../services/localization_service.dart';
import 'muscle_group_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

class MainMenuScreen extends StatefulWidget {
  final WorkoutService workoutService;
  final SettingsService settingsService;
  final VoidCallback onSettingsChanged;

  const MainMenuScreen({
    super.key,
    required this.workoutService,
    required this.settingsService,
    required this.onSettingsChanged,
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String get _language => widget.settingsService.getLanguage();
  
  String _t(String key) {
    return LocalizationService.t(key, _language);
  }

  @override
  Widget build(BuildContext context) {
    final muscleGroups = [
      {
        'name': 'Chest',
        'icon': Icons.fitness_center,
        'color': Colors.red,
        'gradient': [Colors.red.shade400, Colors.red.shade700],
      },
      {
        'name': 'Back',
        'icon': Icons.accessibility_new,
        'color': Colors.blue,
        'gradient': [Colors.blue.shade400, Colors.blue.shade700],
      },
      {
        'name': 'Shoulders',
        'icon': Icons.sports_gymnastics,
        'color': Colors.orange,
        'gradient': [Colors.orange.shade400, Colors.orange.shade700],
      },
      {
        'name': 'Legs',
        'icon': Icons.directions_run,
        'color': Colors.green,
        'gradient': [Colors.green.shade400, Colors.green.shade700],
      },
      {
        'name': 'Arms',
        'icon': Icons.sports_martial_arts,
        'color': Colors.purple,
        'gradient': [Colors.purple.shade400, Colors.purple.shade700],
      },
      {
        'name': 'Core',
        'icon': Icons.self_improvement,
        'color': Colors.teal,
        'gradient': [Colors.teal.shade400, Colors.teal.shade700],
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Profile and Settings Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              workoutService: widget.workoutService,
                              settingsService: widget.settingsService,
                            ),
                          ),
                        );
                      },
                      tooltip: _t('profile'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                              settingsService: widget.settingsService,
                              onSettingsChanged: () {
                                widget.onSettingsChanged();
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                      tooltip: _t('settings'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _t('main_menu_title'),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _t('main_menu_subtitle'),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Muscle Groups Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: muscleGroups.length,
                    itemBuilder: (context, index) {
                      final group = muscleGroups[index];
                      return _buildMuscleGroupCard(
                        context,
                        group['name'] as String,
                        group['icon'] as IconData,
                        group['gradient'] as List<Color>,
                      );
                    },
                  ),
                ),
              ),

              // Bottom Action Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryScreen(
                                workoutService: widget.workoutService,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.history),
                        label: Text(_t('history')),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MuscleGroupScreen(
                                category: 'All',
                                workoutService: widget.workoutService,
                                settingsService: widget.settingsService,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.list),
                        label: Text(_t('all_exercises')),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMuscleGroupCard(
    BuildContext context,
    String name,
    IconData icon,
    List<Color> gradient,
  ) {
    return Hero(
      tag: 'muscle_$name',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MuscleGroupScreen(
                  category: name,
                  workoutService: widget.workoutService,
                  settingsService: widget.settingsService,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 56,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  _t(name.toLowerCase() == 'back' ? 'back_muscle' : name.toLowerCase()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<int>(
                  future: _getExerciseCount(name),
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    return Text(
                      '$count ${_t('exercises')}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> _getExerciseCount(String category) async {
    final exercises = widget.workoutService.getExercisesByCategory(category);
    return exercises.length;
  }
}
