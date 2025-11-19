import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_set.dart';
import '../services/workout_service.dart';
import '../services/settings_service.dart';
import '../services/localization_service.dart';

class AddSetScreen extends StatefulWidget {
  final Exercise exercise;
  final WorkoutService workoutService;
  final SettingsService settingsService;

  const AddSetScreen({
    super.key,
    required this.exercise,
    required this.workoutService,
    required this.settingsService,
  });

  @override
  State<AddSetScreen> createState() => _AddSetScreenState();
}

class _AddSetScreenState extends State<AddSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _notesController = TextEditingController();

  String get _language => widget.settingsService.getLanguage();
  String get _weightUnit => widget.settingsService.getWeightUnit();
  
  String _t(String key) {
    return LocalizationService.t(key, _language);
  }

  @override
  void initState() {
    super.initState();
    _loadLastSetData();
  }

  void _loadLastSetData() {
    final sets = widget.workoutService.getSetsForExercise(widget.exercise.id);
    if (sets.isNotEmpty) {
      final lastSet = sets.first;
      _weightController.text = lastSet.weight.toString();
      _repsController.text = lastSet.reps.toString();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_t('add_set_title')} - ${widget.exercise.name}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Weight input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fitness_center, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          _t('weight'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              hintText: '0.0',
                              border: OutlineInputBorder(),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return _t('enter_weight');
                              }
                              if (double.tryParse(value) == null) {
                                return _t('valid_number');
                              }
                              if (double.parse(value) <= 0) {
                                return '${_t('weight')} ${_t('greater_than_zero')}';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _weightUnit,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickButton('-2.5', () => _adjustWeight(-2.5)),
                        _buildQuickButton('-1', () => _adjustWeight(-1)),
                        _buildQuickButton('+1', () => _adjustWeight(1)),
                        _buildQuickButton('+2.5', () => _adjustWeight(2.5)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reps input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.repeat, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          _t('reps'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _repsController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              hintText: '0',
                              border: OutlineInputBorder(),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return _t('enter_reps');
                              }
                              if (int.tryParse(value) == null) {
                                return _t('valid_number');
                              }
                              if (int.parse(value) <= 0) {
                                return '${_t('reps')} ${_t('greater_than_zero')}';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'reps',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickButton('-2', () => _adjustReps(-2)),
                        _buildQuickButton('-1', () => _adjustReps(-1)),
                        _buildQuickButton('+1', () => _adjustReps(1)),
                        _buildQuickButton('+2', () => _adjustReps(2)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notes input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notes, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          _t('notes'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: _t('how_did_it_feel'),
                        border: const OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Save button
            FilledButton.icon(
              onPressed: _saveSet,
              icon: const Icon(Icons.save),
              label: Text(_t('save_set')),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  void _adjustWeight(double delta) {
    final currentWeight = double.tryParse(_weightController.text) ?? 0;
    final newWeight = (currentWeight + delta).clamp(0, 1000);
    _weightController.text = newWeight.toStringAsFixed(1);
  }

  void _adjustReps(int delta) {
    final currentReps = int.tryParse(_repsController.text) ?? 0;
    final newReps = (currentReps + delta).clamp(0, 100);
    _repsController.text = newReps.toString();
  }

  Future<void> _saveSet() async {
    if (_formKey.currentState!.validate()) {
      final set = WorkoutSet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        exerciseId: widget.exercise.id,
        reps: int.parse(_repsController.text),
        weight: double.parse(_weightController.text),
        date: DateTime.now(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      await widget.workoutService.addWorkoutSet(set);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t('set_saved')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }
}
