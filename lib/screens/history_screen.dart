import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout_set.dart';
import '../services/workout_service.dart';

class HistoryScreen extends StatefulWidget {
  final WorkoutService workoutService;

  const HistoryScreen({super.key, required this.workoutService});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedDays = 30;
  late List<WorkoutSet> _sets;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _sets = widget.workoutService.getRecentSets(days: _selectedDays);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Group sets by date
    final groupedSets = <String, List<WorkoutSet>>{};
    for (final set in _sets) {
      final dateKey = DateFormat('yyyy-MM-dd').format(set.date);
      groupedSets.putIfAbsent(dateKey, () => []).add(set);
    }

    // Calculate totals
    final totalSets = _sets.length;
    final totalReps = _sets.fold<int>(0, (sum, set) => sum + set.reps);
    final totalVolume = _sets.fold<double>(0, (sum, set) => sum + (set.weight * set.reps));
    final uniqueExercises = _sets.map((s) => s.exerciseId).toSet().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Time filter
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeFilterChip('7 Days', 7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTimeFilterChip('30 Days', 30),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTimeFilterChip('90 Days', 90),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTimeFilterChip('All', 365),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Summary stats
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat('Sets', totalSets.toString(), Icons.repeat),
                _buildSummaryStat('Reps', totalReps.toString(), Icons.fitness_center),
                _buildSummaryStat('Volume', '${totalVolume.toStringAsFixed(0)} kg', Icons.trending_up),
                _buildSummaryStat('Exercises', uniqueExercises.toString(), Icons.sports_gymnastics),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Workout sessions list
          Expanded(
            child: _sets.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No workout history',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: groupedSets.length,
                    itemBuilder: (context, index) {
                      final dateKey = groupedSets.keys.elementAt(index);
                      final sets = groupedSets[dateKey]!;
                      final date = DateTime.parse(dateKey);
                      
                      final dayTotal = sets.fold<double>(0, (sum, set) => sum + (set.weight * set.reps));

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              DateFormat('dd').format(date),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            DateFormat('EEEE, MMM dd').format(date),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${sets.length} sets • ${dayTotal.toStringAsFixed(0)} kg total',
                          ),
                          children: sets.map((set) {
                            final exercise = widget.workoutService.getExercise(set.exerciseId);
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.fitness_center, size: 20),
                              title: Text(
                                exercise?.name ?? 'Unknown Exercise',
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                DateFormat('HH:mm').format(set.date),
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                '${set.weight} kg × ${set.reps}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilterChip(String label, int days) {
    final isSelected = _selectedDays == days;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedDays = days;
          _loadData();
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: isSelected ? FontWeight.bold : null,
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.onPrimaryContainer),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
