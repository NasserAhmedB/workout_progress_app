import 'package:flutter/material.dart';
import 'services/workout_service.dart';
import 'services/settings_service.dart';
import 'screens/main_menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final workoutService = WorkoutService();
    await workoutService.initialize();
    
    final settingsService = SettingsService();
    await settingsService.initialize();
    
    runApp(MyApp(
      workoutService: workoutService,
      settingsService: settingsService,
    ));
  } catch (e) {
    // If initialization fails, show error
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error initializing app: $e'),
            ],
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatefulWidget {
  final WorkoutService workoutService;
  final SettingsService settingsService;

  const MyApp({
    super.key,
    required this.workoutService,
    required this.settingsService,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String _currentLanguage;
  late String _currentWeightUnit;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.settingsService.getLanguage();
    _currentWeightUnit = widget.settingsService.getWeightUnit();
  }

  void _onSettingsChanged() {
    setState(() {
      _currentLanguage = widget.settingsService.getLanguage();
      _currentWeightUnit = widget.settingsService.getWeightUnit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Progress',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.zero,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.zero,
        ),
      ),
      themeMode: ThemeMode.system,
      home: MainMenuScreen(
        key: ValueKey('$_currentLanguage-$_currentWeightUnit'),
        workoutService: widget.workoutService,
        settingsService: widget.settingsService,
        onSettingsChanged: _onSettingsChanged,
      ),
    );
  }
}
