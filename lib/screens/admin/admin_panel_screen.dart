import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/dynamic_course_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cosmic/starfield_background.dart';
import 'add_course_screen.dart';
import 'add_video_screen.dart';
import 'manage_content_screen.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarfieldBackground(
        starCount: 60,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildQuickActions(context),
                const SizedBox(height: 32),
                _buildContentStats(context),
                const SizedBox(height: 32),
                _buildDataSourceToggle(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.admin_panel_settings,
                  color: AppTheme.accentGold,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Cosmic Admin Panel',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
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
              'Manage the cosmic content of Almighty Authority',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppTheme.starWhite.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome, ${authProvider.currentUser?.displayName ?? 'Admin'}',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.cosmicSilver.withOpacity(0.7),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              context,
              'Add Course',
              'Create new cosmic course',
              Icons.add_circle,
              AppTheme.celestialBlue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCourseScreen()),
              ),
            ),
            _buildActionCard(
              context,
              'Add Video',
              'Upload new YouTube content',
              Icons.video_library,
              AppTheme.accentGold,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddVideoScreen()),
              ),
            ),
            _buildActionCard(
              context,
              'Manage Content',
              'Edit existing courses & videos',
              Icons.edit,
              AppTheme.softViolet,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageContentScreen()),
              ),
            ),
            _buildActionCard(
              context,
              'Analytics',
              'View cosmic insights',
              Icons.analytics,
              AppTheme.secondaryGreen,
              () => _showComingSoon(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.starWhite.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentStats(BuildContext context) {
    return Consumer<DynamicCourseProvider>(
      builder: (context, courseProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Statistics',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.accentGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Categories',
                      '${courseProvider.categories.length}',
                      Icons.category,
                      AppTheme.celestialBlue,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Courses',
                      '${courseProvider.totalCourseCount}',
                      Icons.school,
                      AppTheme.accentGold,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Videos',
                      '${courseProvider.totalVideoCount}',
                      Icons.play_circle,
                      AppTheme.softViolet,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppTheme.starWhite.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildDataSourceToggle(BuildContext context) {
    return Consumer<DynamicCourseProvider>(
      builder: (context, courseProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Source',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.secondaryGreen.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    courseProvider.useFirestore ? Icons.cloud : Icons.storage,
                    color: courseProvider.useFirestore 
                        ? AppTheme.secondaryGreen 
                        : AppTheme.accentGold,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courseProvider.useFirestore ? 'Firebase (Dynamic)' : 'Static Data',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          courseProvider.useFirestore 
                              ? 'Real-time data from Firestore'
                              : 'Local static data for testing',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.starWhite.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: courseProvider.useFirestore,
                    onChanged: (value) async {
                      await courseProvider.toggleDataSource();
                    },
                    activeColor: AppTheme.secondaryGreen,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text('This feature will be available in the next cosmic update!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
