import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/exercise.dart';
import '../services/workout_service.dart';
import '../data/exercise_data.dart';

class EditExerciseScreen extends StatefulWidget {
  final Exercise exercise;
  final WorkoutService workoutService;

  const EditExerciseScreen({
    super.key,
    required this.exercise,
    required this.workoutService,
  });

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  
  late String _selectedCategory;
  XFile? _selectedImage;
  String? _currentImagePath;
  bool _removeImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise.name);
    _descriptionController = TextEditingController(text: widget.exercise.description ?? '');
    _selectedCategory = widget.exercise.category;
    _currentImagePath = widget.exercise.imagePath;
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
          _removeImage = false;
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
    if (_selectedImage == null) return _currentImagePath;

    try {
      if (kIsWeb) {
        return _selectedImage!.path;
      } else {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String savePath = '${appDir.path}/exercise_images/$fileName';
        
        final Directory imageDir = Directory('${appDir.path}/exercise_images');
        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

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
      return _currentImagePath;
    }
  }

  Future<void> _saveExercise() async {
    if (_formKey.currentState!.validate()) {
      String? imagePath = _currentImagePath;
      
      if (_removeImage) {
        imagePath = null;
      } else if (_selectedImage != null) {
        imagePath = await _saveImage();
      }

      final updatedExercise = widget.exercise.copyWith(
        name: _nameController.text,
        category: _selectedCategory,
        description: _descriptionController.text.isEmpty 
            ? null 
            : _descriptionController.text,
        imagePath: imagePath,
      );

      await widget.workoutService.updateExercise(updatedExercise);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercise updated successfully!'),
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
        title: const Text('Edit Exercise'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image section
            Card(
              child: Column(
                children: [
                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: _removeImage
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 64,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to add image',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: kIsWeb
                                      ? Image.network(
                                          _selectedImage!.path,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : Image.file(
                                          File(_selectedImage!.path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                )
                              : _currentImagePath != null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: kIsWeb
                                          ? Image.network(
                                              _currentImagePath!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder: (context, error, stackTrace) {
                                                return _buildPlaceholder();
                                              },
                                            )
                                          : Image.file(
                                              File(_currentImagePath!),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder: (context, error, stackTrace) {
                                                return _buildPlaceholder();
                                              },
                                            ),
                                    )
                                  : _buildPlaceholder(),
                    ),
                  ),
                  if (_currentImagePath != null && !_removeImage)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _removeImage = true;
                          _selectedImage = null;
                        });
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Remove Image',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Exercise name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
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
              label: const Text('Save Changes'),
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

  Widget _buildPlaceholder() {
    return Column(
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
    );
  }
}
