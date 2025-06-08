import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/video.dart';
import '../../models/course.dart';
import '../../providers/dynamic_course_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cosmic/starfield_background.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_button.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({super.key});

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _youtubeIdController = TextEditingController();
  final _durationController = TextEditingController();
  final _orderController = TextEditingController();
  final _tagsController = TextEditingController();
  
  String _selectedCourseId = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _youtubeIdController.dispose();
    _durationController.dispose();
    _orderController.dispose();
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
              Icons.video_library,
              color: AppTheme.accentGold,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add Cosmic Video',
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
          'Add a new YouTube video to your cosmic course',
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
                // Video Title
                AuthTextField(
                  controller: _titleController,
                  label: 'Video Title',
                  prefixIcon: Icons.title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter video title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Video Description
                AuthTextField(
                  controller: _descriptionController,
                  label: 'Video Description',
                  prefixIcon: Icons.description,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter video description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // YouTube ID or URL
                AuthTextField(
                  controller: _youtubeIdController,
                  label: 'YouTube Video ID or URL',
                  prefixIcon: Icons.play_circle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter YouTube video ID or URL';
                    }
                    final extractedId = AppHelpers.extractYoutubeId(value);
                    if (extractedId == null || !AppHelpers.isValidYouTubeId(extractedId)) {
                      return 'Please enter a valid YouTube ID or URL';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Auto-extract ID from URL and update preview
                    final extractedId = AppHelpers.extractYoutubeId(value);
                    if (extractedId != null && AppHelpers.isValidYouTubeId(extractedId)) {
                      setState(() {
                        // Update the controller with just the ID if it was a URL
                        if (value != extractedId) {
                          _youtubeIdController.value = TextEditingValue(
                            text: extractedId,
                            selection: TextSelection.collapsed(offset: extractedId.length),
                          );
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Paste YouTube URL or just the video ID\nExample: https://youtube.com/watch?v=dQw4w9WgXcQ or dQw4w9WgXcQ',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.starWhite.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),

                // Course Selection
                _buildCourseDropdown(courseProvider),
                const SizedBox(height: 16),

                // Duration
                AuthTextField(
                  controller: _durationController,
                  label: 'Duration (seconds)',
                  prefixIcon: Icons.timer,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter video duration';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Example: 1800 for 30 minutes',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.starWhite.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),

                // Order Index
                AuthTextField(
                  controller: _orderController,
                  label: 'Order in Course',
                  prefixIcon: Icons.format_list_numbered,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter order number';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
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
                const SizedBox(height: 24),

                // Preview Section
                if (_getValidYouTubeId() != null) ...[
                  _buildVideoPreview(),
                  const SizedBox(height: 24),
                ],

                // Submit Button
                AuthButton(
                  text: 'Add Cosmic Video',
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

  Widget _buildCourseDropdown(DynamicCourseProvider courseProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course',
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
              value: _selectedCourseId.isEmpty ? null : _selectedCourseId,
              hint: const Text('Select Course'),
              isExpanded: true,
              items: courseProvider.courses.map<DropdownMenuItem<String>>((dynamic course) {
                return DropdownMenuItem<String>(
                  value: course.id as String,
                  child: Text(
                    course.title as String,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCourseId = value ?? '';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  String? _getValidYouTubeId() {
    final extractedId = AppHelpers.extractYoutubeId(_youtubeIdController.text);
    if (extractedId != null && AppHelpers.isValidYouTubeId(extractedId)) {
      return extractedId;
    }
    return null;
  }

  Widget _buildVideoPreview() {
    final youtubeId = _getValidYouTubeId();
    if (youtubeId == null) return const SizedBox.shrink();

    final thumbnailUrl = 'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Video Preview',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.accentGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              thumbnailUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCourseId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a course')),
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

      final youtubeId = _getValidYouTubeId();
      if (youtubeId == null) {
        if (mounted) {
          AppHelpers.showErrorSnackBar(context, 'Please enter a valid YouTube ID or URL');
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final thumbnailUrl = 'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg';

      final video = Video(
        id: '', // Will be generated by Firestore
        youtubeId: youtubeId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        thumbnailUrl: thumbnailUrl,
        courseId: _selectedCourseId,
        duration: int.parse(_durationController.text),
        orderIndex: int.parse(_orderController.text),
        tags: tags,
      );

      final courseProvider = context.read<DynamicCourseProvider>();
      final success = await courseProvider.addVideo(video);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(courseProvider.error ?? 'Failed to add video'),
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
