import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course.dart';
import '../../models/category.dart';
import '../../providers/dynamic_course_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cosmic/starfield_background.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_button.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _tagsController = TextEditingController();
  
  String _selectedCategoryId = '';
  String _selectedDifficulty = 'beginner';
  bool _isFeatured = false;
  bool _isLoading = false;

  final List<String> _difficulties = ['beginner', 'intermediate', 'advanced'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 40,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.add_circle,
              color: AppTheme.accentGold,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add New Cosmic Course',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: AppTheme.accentGold.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Create a new course to share cosmic wisdom',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppTheme.starWhite.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Consumer<DynamicCourseProvider>(
      builder: (context, courseProvider, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.accentGold.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Title
                AuthTextField(
                  controller: _titleController,
                  label: 'Course Title',
                  prefixIcon: Icons.title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter course title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Course Description
                AuthTextField(
                  controller: _descriptionController,
                  label: 'Course Description',
                  prefixIcon: Icons.description,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter course description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Thumbnail URL
                AuthTextField(
                  controller: _thumbnailController,
                  label: 'Thumbnail URL (YouTube)',
                  prefixIcon: Icons.image,
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter thumbnail URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category Selection
                _buildCategoryDropdown(courseProvider),
                const SizedBox(height: 16),

                // Difficulty Selection
                _buildDifficultyDropdown(),
                const SizedBox(height: 16),

                // Tags
                AuthTextField(
                  controller: _tagsController,
                  label: 'Tags (comma separated)',
                  prefixIcon: Icons.tag,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one tag';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Featured Toggle
                _buildFeaturedToggle(),
                const SizedBox(height: 24),

                // Submit Button
                AuthButton(
                  text: 'Create Cosmic Course',
                  onPressed: _isLoading ? null : _handleSubmit,
                  isLoading: _isLoading,
                  backgroundColor: AppTheme.accentGold,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryDropdown(DynamicCourseProvider courseProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
              hint: const Text('Select Category'),
              isExpanded: true,
              items: courseProvider.categories.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value ?? '';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDifficulty,
              isExpanded: true,
              items: _difficulties.map((difficulty) {
                return DropdownMenuItem<String>(
                  value: difficulty,
                  child: Text(difficulty.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value ?? 'beginner';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedToggle() {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: AppTheme.accentGold,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Featured Course',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Switch(
          value: _isFeatured,
          onChanged: (value) {
            setState(() {
              _isFeatured = value;
            });
          },
          activeColor: AppTheme.accentGold,
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final course = Course(
        id: '', // Will be generated by Firestore
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        thumbnailUrl: _thumbnailController.text.trim(),
        categoryId: _selectedCategoryId,
        videoIds: [], // Videos will be added separately
        estimatedDuration: 0, // Will be calculated when videos are added
        difficulty: _selectedDifficulty,
        tags: tags,
        featured: _isFeatured,
      );

      final courseProvider = context.read<DynamicCourseProvider>();
      final success = await courseProvider.addCourse(course);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(courseProvider.error ?? 'Failed to create course'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
