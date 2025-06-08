import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/dynamic_course_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cosmic/starfield_background.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_button.dart';
import '../../utils/helpers.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorController = TextEditingController();
  
  bool _isLoading = false;
  Color _selectedColor = AppTheme.primaryPurple;

  @override
  void initState() {
    super.initState();
    _colorController.text = AppHelpers.colorToHex(_selectedColor);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 100,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Add New Category',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new category for organizing your cosmic content',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.starWhite.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Name
          AuthTextField(
            controller: _nameController,
            label: 'Category Name',
            prefixIcon: Icons.category,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter category name';
              }
              if (value.length < 3) {
                return 'Category name must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Description
          AuthTextField(
            controller: _descriptionController,
            label: 'Description',
            prefixIcon: Icons.description,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter category description';
              }
              if (value.length < 10) {
                return 'Description must be at least 10 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Color Selection
          Text(
            'Category Color',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildColorPicker(),
          const SizedBox(height: 24),

          // Preview
          _buildCategoryPreview(),
          const SizedBox(height: 24),

          // Submit Button
          AuthButton(
            text: 'Create Category',
            onPressed: _isLoading ? null : _handleSubmit,
            isLoading: _isLoading,
            backgroundColor: AppTheme.accentGold,
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      AppTheme.primaryPurple,
      AppTheme.accentGold,
      AppTheme.secondaryGreen,
      AppTheme.softViolet,
      AppTheme.celestialBlue,
      AppTheme.deepSpace,
      Colors.red.shade400,
      Colors.orange.shade400,
      Colors.pink.shade400,
      Colors.teal.shade400,
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        final isSelected = _selectedColor.value == color.value;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
              _colorController.text = AppHelpers.colorToHex(color);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryPreview() {
    if (_nameController.text.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _selectedColor.withOpacity(0.9),
                _selectedColor.withOpacity(0.7),
                AppTheme.deepSpace.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.accentGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.category,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  _nameController.text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _descriptionController.text.isEmpty 
                      ? 'Category description...'
                      : _descriptionController.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final category = Category(
        id: '', // Will be generated by Firestore
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        iconPath: '', // Optional for now
        color: AppHelpers.colorToHex(_selectedColor),
        courseIds: [],
        order: 0, // Will be set by the provider
      );

      final courseProvider = context.read<DynamicCourseProvider>();
      await courseProvider.addCategory(category);

      if (mounted) {
        AppHelpers.showSuccessSnackBar(context, 'Category created successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppHelpers.showErrorSnackBar(context, 'Failed to create category: $e');
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
