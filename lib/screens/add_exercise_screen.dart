import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/exercise.dart';
import '../services/workout_service.dart';
import '../data/exercise_data.dart';

class AddExerciseScreen extends StatefulWidget {
  final WorkoutService workoutService;
  final String? preselectedCategory;

  const AddExerciseScreen({
    super.key,
    required this.workoutService,
    this.preselectedCategory,
  });

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  late String _selectedCategory;
  XFile? _selectedImage;
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.preselectedCategory ?? 'Chest';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<String?> _saveImage() async {
    if (_selectedImage == null) return null;

    try {
      if (kIsWeb) {
        // For web, we'll use the network path directly
        return _selectedImage!.path;
      } else {
        // For mobile, save to app documents directory
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String savePath = '${appDir.path}/exercise_images/$fileName';
        
        // Create directory if it doesn't exist
        final Directory imageDir = Directory('${appDir.path}/exercise_images');
        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

        // Copy the file
        final File imageFile = File(_selectedImage!.path);
        await imageFile.copy(savePath);
        
        return savePath;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving image: $e')),
        );
      }
      return null;
    }
  }

  Future<void> _saveExercise() async {
    if (_formKey.currentState!.validate()) {
      // Save the image if one was selected
      if (_selectedImage != null) {
        _savedImagePath = await _saveImage();
      }

      final exercise = Exercise(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        category: _selectedCategory,
        description: _descriptionController.text.isEmpty 
            ? null 
            : _descriptionController.text,
        imagePath: _savedImagePath,
        isCustom: true,
      );

      await widget.workoutService.addExercise(exercise);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercise added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ExerciseData.getCategories()
        .where((c) => c != 'All')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Custom Exercise'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image picker
            Card(
              child: InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: kIsWeb
                              ? Image.network(
                                  _selectedImage!.path,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 64,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to add exercise image',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Exercise name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                hintText: 'e.g., Cable Pull Through',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter exercise name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Category dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Describe how to perform this exercise...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),

            const SizedBox(height: 24),

            // Save button
            FilledButton.icon(
              onPressed: _saveExercise,
              icon: const Icon(Icons.save),
              label: const Text('Save Exercise'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
