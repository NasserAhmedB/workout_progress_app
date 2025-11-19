import 'package:hive/hive.dart';

part 'profile_record.g.dart';

@HiveType(typeId: 2)
class ProfileRecord {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double heightCm;

  @HiveField(2)
  final double weightKg;

  @HiveField(3)
  final DateTime date;

  ProfileRecord({
    required this.id,
    required this.heightCm,
    required this.weightKg,
    required this.date,
  });

  double get bmi {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  String getBmiCategory() => bmiCategory;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'date': date.toIso8601String(),
    };
  }

  factory ProfileRecord.fromJson(Map<String, dynamic> json) {
    return ProfileRecord(
      id: json['id'] as String,
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}
