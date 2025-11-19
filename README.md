# 💪 Workout Progress - Flutter Fitness Tracking App

A comprehensive Flutter mobile application for tracking gym workout progress with support for multiple muscle groups, exercises, and personal fitness metrics.

![Flutter](https://img.shields.io/badge/Flutter-3.35.4-blue)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## 📱 Features

### 🏋️ Workout Tracking
- **6 Muscle Group Categories**: Chest, Back, Shoulders, Legs, Arms, and Core
- **Exercise Management**: Add, edit, and delete exercises
- **Workout Sets**: Track reps, weight, and notes for each set
- **Personal Bests**: Automatically calculated using Epley formula
- **Exercise Statistics**: View total sets, reps, volume, max/avg weight
- **Workout History**: Complete history of all workout sessions with dates

### 👤 Profile & BMI Tracking
- **Height & Weight Tracking**: Record measurements in CM and KG/LB
- **Automatic BMI Calculation**: Real-time Body Mass Index calculation
- **BMI Categories**: Color-coded health status (Underweight, Normal, Overweight, Obese)
- **Progress History**: Track weight changes over time with complete history
- **Visual Indicators**: Charts and graphs for progress visualization

### 🌍 Internationalization
- **Bilingual Support**: Complete English and Arabic translations
- **Real-time Language Switching**: Instant translation throughout the app
- **100+ Translation Keys**: Every screen fully translated
- **RTL Support Ready**: Foundation for right-to-left languages

### ⚖️ Unit Conversion
- **KG/LB Toggle**: Switch between Kilograms and Pounds
- **Automatic Conversion**: Weight values converted throughout the app
- **Persistent Settings**: Unit preference saved across sessions

### 🎨 Modern UI/UX
- **Material Design 3**: Latest Material Design guidelines
- **Gradient Backgrounds**: Beautiful visual design
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Hero animations and transitions
- **Dark Mode Support**: System-based theme switching

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.35.4 or higher
- Dart SDK 3.9.2 or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/NasserAhmedB/workout_progress_app.git
   cd workout_progress_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For web preview
   flutter run -d chrome

   # For Android device/emulator
   flutter run -d android
   ```

### Building for Production

**Android APK (Release)**
```bash
flutter build apk --release
```

**Android App Bundle (AAB) - For Google Play**
```bash
flutter build appbundle --release
```

**Web Build**
```bash
flutter build web --release
```

## 📦 Dependencies

### Core Dependencies
- **flutter**: SDK for building the app
- **hive**: ^2.2.3 - Local NoSQL database
- **hive_flutter**: ^1.1.0 - Hive Flutter integration
- **shared_preferences**: ^2.5.3 - Key-value storage for settings
- **intl**: ^0.19.0 - Internationalization support
- **path_provider**: ^2.1.5 - File system paths

### UI/UX Dependencies
- **flutter**: Material Design 3 components
- **cupertino_icons**: ^1.0.8 - iOS-style icons

### Development Dependencies
- **flutter_test**: Testing framework
- **flutter_lints**: ^5.0.0 - Code analysis
- **hive_generator**: ^2.0.1 - Code generation for Hive
- **build_runner**: ^2.4.15 - Build system

## 🏗️ Project Structure

```
lib/
├── data/
│   └── exercise_data.dart          # Default exercise definitions
├── models/
│   ├── exercise.dart               # Exercise data model
│   ├── workout_set.dart            # Workout set data model
│   └── profile_record.dart         # Profile/BMI data model
├── screens/
│   ├── main_menu_screen.dart       # Main navigation screen
│   ├── muscle_group_screen.dart    # Exercise list by category
│   ├── exercise_detail_screen.dart # Exercise stats and history
│   ├── add_set_screen.dart         # Add workout set form
│   ├── profile_screen.dart         # Profile and BMI tracking
│   ├── settings_screen.dart        # App settings
│   ├── history_screen.dart         # Workout history
│   ├── add_exercise_screen.dart    # Add custom exercise
│   ├── edit_exercise_screen.dart   # Edit exercise
│   └── tutorial_screen.dart        # Exercise tutorial videos
├── services/
│   ├── workout_service.dart        # Workout data management
│   ├── settings_service.dart       # Settings management
│   └── localization_service.dart   # Translation service
└── main.dart                       # App entry point

android/
├── app/
│   ├── src/main/
│   │   ├── AndroidManifest.xml
│   │   └── kotlin/com/nasser/workout_progress/
│   │       └── MainActivity.kt
│   ├── build.gradle.kts            # Android build configuration
│   └── key.properties              # Signing configuration
└── release-key.jks                 # Release signing keystore

assets/
├── icons/
│   └── app_icon.png                # App icon
└── tutorials/
    ├── bench_press.mp4             # Exercise tutorial videos
    ├── deadlift.mp4
    └── squat.mp4
```

## 🎯 Key Features Breakdown

### 1. Exercise Database
- **Default Exercises**: Pre-populated with common gym exercises
- **Custom Exercises**: Add your own exercises with images
- **Categories**: Organized by muscle groups
- **Tutorial Videos**: Support for exercise demonstration videos

### 2. Workout Tracking
- **Set Recording**: Weight, reps, and notes for each set
- **Quick Adjustments**: +/- buttons for fast weight/rep entry
- **Personal Records**: Automatic tracking of personal bests
- **Statistics**: Comprehensive workout stats (volume, max, average)

### 3. Profile System
- **Body Metrics**: Height (CM), Weight (KG/LB)
- **BMI Calculation**: `weight(kg) / (height(m))²`
- **Health Categories**:
  - Underweight: BMI < 18.5 (Blue)
  - Normal: BMI 18.5-24.9 (Green)
  - Overweight: BMI 25-29.9 (Orange)
  - Obese: BMI ≥ 30 (Red)
- **History Tracking**: View all past measurements

### 4. Data Persistence
- **Hive Database**: Fast, lightweight NoSQL storage
- **Offline First**: All data stored locally
- **Type Safety**: Generated adapters for type-safe operations
- **Efficient Queries**: Optimized data retrieval

## 🔐 Android Signing Configuration

The app includes release signing configuration:

**Location**: `android/app/build.gradle.kts`

**Signing Files**:
- Keystore: `android/release-key.jks`
- Properties: `android/key.properties`

**Key Information**:
- Key Alias: `release`
- Key Algorithm: RSA
- Validity: 10,000 days

## 📱 Package Information

**Package Name**: `com.nasser.workout_progress`
**App Name**: Workout Progress
**Version**: 1.0.0
**Version Code**: 1

## 🌐 Supported Platforms

- ✅ **Android**: Full support with release builds
- ✅ **Web**: Preview and testing support
- ⏳ **iOS**: Compatible code structure (needs configuration)
- ⏳ **Desktop**: Linux, macOS, Windows (needs testing)

## 🔧 Configuration

### Changing App Name
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
android:label="Your App Name"
```

### Changing Package Name
1. Update `android/app/build.gradle.kts` - applicationId
2. Update `android/app/src/main/AndroidManifest.xml` - package
3. Rename MainActivity directory structure
4. Update MainActivity.kt package declaration

### Adding Firebase (Optional)
1. Add Firebase configuration files
2. Update dependencies in `pubspec.yaml`
3. Configure authentication and database rules

## 🧪 Testing

Run unit tests:
```bash
flutter test
```

Run widget tests:
```bash
flutter test test/widget_test.dart
```

## 🐛 Troubleshooting

### Build Errors
```bash
# Clean build cache
flutter clean
rm -rf android/build android/app/build android/.gradle

# Reinstall dependencies
flutter pub get

# Rebuild
flutter build apk --release
```

### Android Signing Issues
- Verify keystore file exists: `android/release-key.jks`
- Check key.properties configuration
- Ensure passwords match in key.properties

### Web Preview Issues
- Clear browser cache (Ctrl+Shift+R)
- Check CORS configuration
- Try incognito/private browsing mode

## 📈 Roadmap

### Planned Features
- [ ] Cloud sync with Firebase
- [ ] Social features (share workouts)
- [ ] Workout plans and programs
- [ ] Progress photos
- [ ] Export data (CSV, PDF)
- [ ] Workout reminders and notifications
- [ ] Exercise video library
- [ ] Nutrition tracking integration
- [ ] iOS App Store release

### Improvements
- [ ] Advanced statistics and charts
- [ ] More language support
- [ ] Wearable device integration
- [ ] AI-powered workout suggestions
- [ ] Community features

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Developer

**Nasser Ahmed**
- GitHub: [@NasserAhmedB](https://github.com/NasserAhmedB)
- Repository: [workout_progress_app](https://github.com/NasserAhmedB/workout_progress_app)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI guidelines
- Hive team for the excellent local database
- The open-source community

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on [GitHub Issues](https://github.com/NasserAhmedB/workout_progress_app/issues)
- Create a discussion on [GitHub Discussions](https://github.com/NasserAhmedB/workout_progress_app/discussions)

---

**Made with ❤️ using Flutter**

**Start tracking your fitness journey today!** 💪🏋️‍♂️
