import 'package:hive_flutter/hive_flutter.dart';
import '../models/exercise.dart';
import '../models/workout_set.dart';
import '../models/profile_record.dart';
import '../data/exercise_data.dart';

class WorkoutService {
  static const String exercisesBoxName = 'exercises';
  static const String setsBoxName = 'workout_sets';
  static const String profileBoxName = 'profile_records';

  late Box<Exercise> _exercisesBox;
  late Box<WorkoutSet> _setsBox;
  late Box<ProfileRecord> _profileBox;

  Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ExerciseAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WorkoutSetAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ProfileRecordAdapter());
    }

    // Open boxes
    _exercisesBox = await Hive.openBox<Exercise>(exercisesBoxName);
    _setsBox = await Hive.openBox<WorkoutSet>(setsBoxName);
    _profileBox = await Hive.openBox<ProfileRecord>(profileBoxName);

    // Initialize default exercises if empty
    if (_exercisesBox.isEmpty) {
      await _initializeDefaultExercises();
    }
  }

  Future<void> _initializeDefaultExercises() async {
    final exercises = ExerciseData.getDefaultExercises();
    for (final exercise in exercises) {
      await _exercisesBox.put(exercise.id, exercise);
    }
  }

  // Exercise operations
  List<Exercise> getAllExercises() {
    return _exercisesBox.values.toList();
  }

  List<Exercise> getExercisesByCategory(String category) {
    if (category == 'All') {
      return getAllExercises();
    }
    return _exercisesBox.values.where((e) => e.category == category).toList();
  }

  Exercise? getExercise(String id) {
    return _exercisesBox.get(id);
  }

  Future<void> addExercise(Exercise exercise) async {
    await _exercisesBox.put(exercise.id, exercise);
  }

  Future<void> updateExercise(Exercise exercise) async {
    await _exercisesBox.put(exercise.id, exercise);
  }

  Future<void> deleteExercise(String id) async {
    await _exercisesBox.delete(id);
    // Also delete all sets for this exercise
    final sets = getSetsForExercise(id);
    for (final set in sets) {
      await _setsBox.delete(set.id);
    }
  }

  // Workout set operations
  Future<void> addWorkoutSet(WorkoutSet set) async {
    await _setsBox.put(set.id, set);
  }

  Future<void> deleteWorkoutSet(String id) async {
    await _setsBox.delete(id);
  }

  List<WorkoutSet> getAllSets() {
    return _setsBox.values.toList();
  }

  List<WorkoutSet> getSetsForExercise(String exerciseId) {
    return _setsBox.values
        .where((set) => set.exerciseId == exerciseId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<WorkoutSet> getRecentSets({int days = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _setsBox.values
        .where((set) => set.date.isAfter(cutoffDate))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  WorkoutSet? getPersonalBest(String exerciseId) {
    final sets = getSetsForExercise(exerciseId);
    if (sets.isEmpty) return null;

    // Calculate one-rep max using Epley formula: weight × (1 + reps/30)
    WorkoutSet? best;
    double bestScore = 0;

    for (final set in sets) {
      final score = set.weight * (1 + set.reps / 30);
      if (score > bestScore) {
        bestScore = score;
        best = set;
      }
    }

    return best;
  }

  Map<String, dynamic> getExerciseStats(String exerciseId) {
    final sets = getSetsForExercise(exerciseId);
    
    if (sets.isEmpty) {
      return {
        'totalSets': 0,
        'totalReps': 0,
        'totalVolume': 0.0,
        'averageWeight': 0.0,
        'maxWeight': 0.0,
      };
    }

    final totalSets = sets.length;
    final totalReps = sets.fold<int>(0, (sum, set) => sum + set.reps);
    final totalVolume = sets.fold<double>(0, (sum, set) => sum + (set.weight * set.reps));
    final maxWeight = sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
    final averageWeight = sets.fold<double>(0, (sum, set) => sum + set.weight) / totalSets;

    return {
      'totalSets': totalSets,
      'totalReps': totalReps,
      'totalVolume': totalVolume,
      'averageWeight': averageWeight,
      'maxWeight': maxWeight,
    };
  }

  // Profile operations
  Future<void> addProfileRecord(ProfileRecord record) async {
    await _profileBox.put(record.id, record);
  }

  ProfileRecord? getLatestProfile() {
    if (_profileBox.isEmpty) return null;
    final records = _profileBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return records.first;
  }

  List<ProfileRecord> getAllProfiles() {
    return _profileBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> deleteProfileRecord(String id) async {
    await _profileBox.delete(id);
  }

  void dispose() {
    _exercisesBox.close();
    _setsBox.close();
    _profileBox.close();
  }
}
