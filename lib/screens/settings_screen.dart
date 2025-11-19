import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/localization_service.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;
  final VoidCallback onSettingsChanged;

  const SettingsScreen({
    super.key,
    required this.settingsService,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _weightUnit;
  late String _language;

  @override
  void initState() {
    super.initState();
    _weightUnit = widget.settingsService.getWeightUnit();
    _language = widget.settingsService.getLanguage();
  }

  String _t(String key) {
    return LocalizationService.t(key, _language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t('settings')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Weight Unit Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _t('weight_unit'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'kg',
                        label: Text(_t('kg')),
                        icon: const Icon(Icons.straighten),
                      ),
                      ButtonSegment(
                        value: 'lb',
                        label: Text(_t('lb')),
                        icon: const Icon(Icons.scale),
                      ),
                    ],
                    selected: {_weightUnit},
                    onSelectionChanged: (Set<String> newSelection) async {
                      setState(() {
                        _weightUnit = newSelection.first;
                      });
                      await widget.settingsService.setWeightUnit(_weightUnit);
                      widget.onSettingsChanged();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _weightUnit == 'kg'
                                  ? 'Weight unit changed to Kilograms'
                                  : 'Weight unit changed to Pounds',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _weightUnit == 'kg'
                        ? 'All weights will be displayed in kilograms (kg)'
                        : 'All weights will be displayed in pounds (lb)',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Language Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _t('language'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'en',
                        label: Text(_t('english')),
                        icon: const Icon(Icons.translate),
                      ),
                      ButtonSegment(
                        value: 'ar',
                        label: Text(_t('arabic')),
                        icon: const Icon(Icons.translate),
                      ),
                    ],
                    selected: {_language},
                    onSelectionChanged: (Set<String> newSelection) async {
                      setState(() {
                        _language = newSelection.first;
                      });
                      await widget.settingsService.setLanguage(_language);
                      widget.onSettingsChanged();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _language == 'en'
                                  ? 'Language changed to English'
                                  : 'تم تغيير اللغة إلى العربية',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _language == 'en'
                        ? 'All text will be displayed in English'
                        : 'سيتم عرض جميع النصوص باللغة العربية',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Info Card
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _language == 'en'
                          ? 'Changes will take effect immediately throughout the app'
                          : 'ستصبح التغييرات سارية على الفور في جميع أنحاء التطبيق',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
