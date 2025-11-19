import '../models/exercise.dart';

class ExerciseData {
  static List<Exercise> getDefaultExercises() {
    return [
      // Chest Exercises
      Exercise(
        id: 'bench_press',
        name: 'Bench Press',
        category: 'Chest',
        description: 'Barbell or dumbbell press on flat bench',
        tutorialUrl: 'assets/tutorials/bench_press.mp4',
      ),
      Exercise(
        id: 'incline_press',
        name: 'Incline Press',
        category: 'Chest',
        description: 'Press on incline bench',
      ),
      Exercise(
        id: 'chest_fly',
        name: 'Chest Fly Machine',
        category: 'Chest',
        description: 'Machine fly for chest isolation',
      ),
      Exercise(
        id: 'cable_crossover',
        name: 'Cable Crossover',
        category: 'Chest',
        description: 'Cable chest exercise',
      ),

      // Back Exercises
      Exercise(
        id: 'lat_pulldown',
        name: 'Lat Pulldown',
        category: 'Back',
        description: 'Cable pulldown for lats',
      ),
      Exercise(
        id: 'seated_row',
        name: 'Seated Row',
        category: 'Back',
        description: 'Cable or machine row',
      ),
      Exercise(
        id: 'deadlift',
        name: 'Deadlift',
        category: 'Back',
        description: 'Barbell deadlift',
        tutorialUrl: 'assets/tutorials/deadlift.mp4',
      ),
      Exercise(
        id: 'pull_up',
        name: 'Pull-up',
        category: 'Back',
        description: 'Bodyweight or assisted pull-up',
      ),
      Exercise(
        id: 't_bar_row',
        name: 'T-Bar Row',
        category: 'Back',
        description: 'T-bar rowing machine',
      ),

      // Shoulder Exercises
      Exercise(
        id: 'shoulder_press',
        name: 'Shoulder Press',
        category: 'Shoulders',
        description: 'Overhead press with dumbbells or barbell',
      ),
      Exercise(
        id: 'lateral_raise',
        name: 'Lateral Raise',
        category: 'Shoulders',
        description: 'Side lateral raise',
      ),
      Exercise(
        id: 'rear_delt_fly',
        name: 'Rear Delt Fly',
        category: 'Shoulders',
        description: 'Rear deltoid isolation',
      ),
      Exercise(
        id: 'front_raise',
        name: 'Front Raise',
        category: 'Shoulders',
        description: 'Front shoulder raise',
      ),

      // Legs Exercises
      Exercise(
        id: 'leg_press',
        name: 'Leg Press',
        category: 'Legs',
        description: 'Machine leg press',
      ),
      Exercise(
        id: 'squat',
        name: 'Squat',
        category: 'Legs',
        description: 'Barbell or machine squat',
        tutorialUrl: 'assets/tutorials/squat.mp4',
      ),
      Exercise(
        id: 'leg_extension',
        name: 'Leg Extension',
        category: 'Legs',
        description: 'Quadriceps isolation machine',
      ),
      Exercise(
        id: 'leg_curl',
        name: 'Leg Curl',
        category: 'Legs',
        description: 'Hamstring curl machine',
      ),
      Exercise(
        id: 'calf_raise',
        name: 'Calf Raise',
        category: 'Legs',
        description: 'Standing or seated calf raise',
      ),
      Exercise(
        id: 'hack_squat',
        name: 'Hack Squat',
        category: 'Legs',
        description: 'Hack squat machine',
      ),

      // Arms Exercises
      Exercise(
        id: 'bicep_curl',
        name: 'Bicep Curl',
        category: 'Arms',
        description: 'Dumbbell or barbell curl',
      ),
      Exercise(
        id: 'tricep_pushdown',
        name: 'Tricep Pushdown',
        category: 'Arms',
        description: 'Cable tricep extension',
      ),
      Exercise(
        id: 'hammer_curl',
        name: 'Hammer Curl',
        category: 'Arms',
        description: 'Neutral grip bicep curl',
      ),
      Exercise(
        id: 'tricep_dip',
        name: 'Tricep Dip',
        category: 'Arms',
        description: 'Dip machine or bodyweight',
      ),
      Exercise(
        id: 'preacher_curl',
        name: 'Preacher Curl',
        category: 'Arms',
        description: 'Preacher bench curl',
      ),

      // Core Exercises
      Exercise(
        id: 'ab_crunch',
        name: 'Ab Crunch Machine',
        category: 'Core',
        description: 'Machine ab crunches',
      ),
      Exercise(
        id: 'cable_crunch',
        name: 'Cable Crunch',
        category: 'Core',
        description: 'Cable rope crunches',
      ),
      Exercise(
        id: 'leg_raise',
        name: 'Leg Raise',
        category: 'Core',
        description: 'Hanging or supported leg raise',
      ),
    ];
  }

  static List<String> getCategories() {
    return ['All', 'Chest', 'Back', 'Shoulders', 'Legs', 'Arms', 'Core'];
  }
}
