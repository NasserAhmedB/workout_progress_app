import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 0)
class Exercise {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String? imagePath;

  @HiveField(5)
  final String? tutorialUrl;

  @HiveField(6)
  final bool isCustom;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.imagePath,
    this.tutorialUrl,
    this.isCustom = false,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? imagePath,
    String? tutorialUrl,
    bool? isCustom,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      tutorialUrl: tutorialUrl ?? this.tutorialUrl,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'imagePath': imagePath,
      'tutorialUrl': tutorialUrl,
      'isCustom': isCustom,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      imagePath: json['imagePath'] as String?,
      tutorialUrl: json['tutorialUrl'] as String?,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }
}
