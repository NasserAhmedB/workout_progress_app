import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/profile_record.dart';
import '../services/workout_service.dart';
import '../services/settings_service.dart';
import '../services/localization_service.dart';

class ProfileScreen extends StatefulWidget {
  final WorkoutService workoutService;
  final SettingsService settingsService;

  const ProfileScreen({
    super.key,
    required this.workoutService,
    required this.settingsService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  List<ProfileRecord> _profileHistory = [];
  ProfileRecord? _latestProfile;

  String get _language => widget.settingsService.getLanguage();
  String get _weightUnit => widget.settingsService.getWeightUnit();
  
  String _t(String key) {
    return LocalizationService.t(key, _language);
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    setState(() {
      _profileHistory = widget.workoutService.getAllProfiles();
      _latestProfile = widget.workoutService.getLatestProfile();
      
      // Pre-fill with latest data if available
      if (_latestProfile != null) {
        _heightController.text = _latestProfile!.heightCm.toStringAsFixed(1);
      }
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t('my_profile')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current BMI Display (if available)
            if (_latestProfile != null) _buildCurrentBMICard(),
            
            const SizedBox(height: 16),
            
            // Input Form
            _buildInputForm(),
            
            const SizedBox(height: 24),
            
            // History Section
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBMICard() {
    final bmi = _latestProfile!.bmi;
    final category = _latestProfile!.bmiCategory;
    
    Color categoryColor;
    String categoryKey;
    switch (category) {
      case 'Underweight':
        categoryColor = Colors.blue;
        categoryKey = 'underweight';
        break;
      case 'Normal':
        categoryColor = Colors.green;
        categoryKey = 'normal';
        break;
      case 'Overweight':
        categoryColor = Colors.orange;
        categoryKey = 'overweight';
        break;
      case 'Obese':
        categoryColor = Colors.red;
        categoryKey = 'obese';
        break;
      default:
        categoryColor = Colors.grey;
        categoryKey = 'normal';
    }

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [categoryColor.withValues(alpha: 0.2), categoryColor.withValues(alpha: 0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              _t('bmi'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: categoryColor),
              ),
              child: Text(
                _t(categoryKey),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoChip(
                  _t('height'),
                  '${_latestProfile!.heightCm.toStringAsFixed(0)} ${_t('cm')}',
                  Icons.height,
                ),
                _buildInfoChip(
                  _t('weight'),
                  widget.settingsService.formatWeight(_latestProfile!.weightKg),
                  Icons.monitor_weight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInputForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t('add_first_profile'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Height Input
              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: _t('height_cm'),
                  prefixIcon: const Icon(Icons.height),
                  suffixText: _t('cm'),
                  border: const OutlineInputBorder(),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _t('enter_height');
                  }
                  if (double.tryParse(value) == null) {
                    return _t('valid_number');
                  }
                  if (double.parse(value) <= 0) {
                    return _t('greater_than_zero');
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Weight Input
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: _t('current_weight'),
                  prefixIcon: const Icon(Icons.monitor_weight),
                  suffixText: _weightUnit,
                  border: const OutlineInputBorder(),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _t('enter_weight_value');
                  }
                  if (double.tryParse(value) == null) {
                    return _t('valid_number');
                  }
                  if (double.parse(value) <= 0) {
                    return _t('greater_than_zero');
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: Text(_t('save_profile')),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _t('profile_history'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_profileHistory.length} ${_t('total')}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        if (_profileHistory.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _t('no_profile_history'),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _profileHistory.length,
            itemBuilder: (context, index) {
              final record = _profileHistory[index];
              return _buildProfileHistoryCard(record);
            },
          ),
      ],
    );
  }

  Widget _buildProfileHistoryCard(ProfileRecord record) {
    final bmi = record.bmi;
    final category = record.bmiCategory;
    
    Color categoryColor;
    String categoryKey;
    switch (category) {
      case 'Underweight':
        categoryColor = Colors.blue;
        categoryKey = 'underweight';
        break;
      case 'Normal':
        categoryColor = Colors.green;
        categoryKey = 'normal';
        break;
      case 'Overweight':
        categoryColor = Colors.orange;
        categoryKey = 'overweight';
        break;
      case 'Obese':
        categoryColor = Colors.red;
        categoryKey = 'obese';
        break;
      default:
        categoryColor = Colors.grey;
        categoryKey = 'normal';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: categoryColor.withValues(alpha: 0.2),
          child: Text(
            bmi.toStringAsFixed(0),
            style: TextStyle(
              color: categoryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${record.heightCm.toStringAsFixed(0)} ${_t('cm')} • ${widget.settingsService.formatWeight(record.weightKg)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _t(categoryKey),
                style: TextStyle(
                  fontSize: 12,
                  color: categoryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - HH:mm').format(record.date),
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(record),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Get weight in KG (convert if needed)
      double weightInKg = double.parse(_weightController.text);
      if (_weightUnit == 'lb') {
        weightInKg = widget.settingsService.convertWeight(weightInKg, toKg: true);
      }

      final record = ProfileRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        heightCm: double.parse(_heightController.text),
        weightKg: weightInKg,
        date: DateTime.now(),
      );

      await widget.workoutService.addProfileRecord(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t('profile_saved')),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear weight input after saving
        _weightController.clear();
        
        // Reload data
        _loadProfileData();
      }
    }
  }

  Future<void> _confirmDelete(ProfileRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t('delete_profile')),
        content: Text(_t('delete_profile_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_t('delete'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.workoutService.deleteProfileRecord(record.id);
      _loadProfileData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t('profile_deleted'))),
        );
      }
    }
  }
}
