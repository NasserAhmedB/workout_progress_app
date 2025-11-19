import 'package:hive/hive.dart';

part 'workout_set.g.dart';

@HiveType(typeId: 1)
class WorkoutSet {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String exerciseId;

  @HiveField(2)
  final int reps;

  @HiveField(3)
  final double weight;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String? notes;

  WorkoutSet({
    required this.id,
    required this.exerciseId,
    required this.reps,
    required this.weight,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'reps': reps,
      'weight': weight,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      reps: json['reps'] as int,
      weight: (json['weight'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
  }
}
