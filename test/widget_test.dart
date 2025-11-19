// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';
import 'package:flutter_app/services/workout_service.dart';
import 'package:flutter_app/services/settings_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Create a mock workout service for testing
    final workoutService = WorkoutService();
    await workoutService.initialize();
    
    final settingsService = SettingsService();
    await settingsService.initialize();

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(
      workoutService: workoutService,
      settingsService: settingsService,
    ));

    // Verify that the app title is present
    expect(find.text('Gym Progress Tracker'), findsOneWidget);
  });
}
