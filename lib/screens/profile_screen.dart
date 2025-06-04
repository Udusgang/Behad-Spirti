import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../data/static_data.dart';
import 'dart:math' as math;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildQuoteOfTheDay(),
            const SizedBox(height: 24),
            _buildQuickStats(),
            const SizedBox(height: 24),
            _buildAchievements(),
            const SizedBox(height: 24),
            _buildPreferences(),
            const SizedBox(height: 24),
            _buildAboutApp(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: AppTheme.gradientDecoration,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Spiritual Learner',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'On a journey of self-discovery',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<ProgressProvider>(
            builder: (context, progressProvider, child) {
              final stats = progressProvider.getProgressStats();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProfileStat(
                    'Watch Time',
                    stats['totalWatchTime'] as String,
                  ),
                  _buildProfileStat(
                    'Completed',
                    '${stats['completedVideos']} videos',
                  ),
                  _buildProfileStat(
                    'Streak',
                    '${stats['learningStreak']} days',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteOfTheDay() {
    final quote = StaticData.motivationalQuotes[
        math.Random().nextInt(StaticData.motivationalQuotes.length)
    ];

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quote of the Day',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quote,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Consumer2<ProgressProvider, CourseProvider>(
      builder: (context, progressProvider, courseProvider, child) {
        final totalCourses = courseProvider.totalCourseCount;
        final totalVideos = courseProvider.totalVideoCount;
        final completedVideos = progressProvider.userProgress.completedVideosCount;
        final completedCourses = progressProvider.userProgress.completedCoursesCount;

        return Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: AppTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learning Statistics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Courses Progress',
                      '$completedCourses / $totalCourses',
                      completedCourses / totalCourses,
                      Icons.school,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatItem(
                      'Videos Progress',
                      '$completedVideos / $totalVideos',
                      completedVideos / totalVideos,
                      Icons.play_circle_filled,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String title, String subtitle, double progress, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.primaryPurple),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: AppTheme.lightGray,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        final completedVideos = progressProvider.userProgress.completedVideosCount;
        final completedCourses = progressProvider.userProgress.completedCoursesCount;
        final watchTime = progressProvider.userProgress.totalWatchTimeMinutes;

        final achievements = [
          {
            'title': 'First Steps',
            'description': 'Complete your first video',
            'achieved': completedVideos >= 1,
            'icon': Icons.play_arrow,
          },
          {
            'title': 'Dedicated Learner',
            'description': 'Complete 5 videos',
            'achieved': completedVideos >= 5,
            'icon': Icons.star,
          },
          {
            'title': 'Course Master',
            'description': 'Complete your first course',
            'achieved': completedCourses >= 1,
            'icon': Icons.school,
          },
          {
            'title': 'Time Keeper',
            'description': 'Watch for 1 hour total',
            'achieved': watchTime >= 60,
            'icon': Icons.access_time,
          },
        ];

        return Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: AppTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  final achieved = achievement['achieved'] as bool;
                  
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: achieved ? AppTheme.primaryPurple.withOpacity(0.1) : AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(12),
                      border: achieved ? Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          achievement['icon'] as IconData,
                          size: 24,
                          color: achieved ? AppTheme.primaryPurple : AppTheme.mediumGray,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          achievement['title'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: achieved ? AppTheme.primaryPurple : AppTheme.mediumGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement['description'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: achieved ? AppTheme.darkGray : AppTheme.mediumGray,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreferences() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildPreferenceItem(
            'Notifications',
            'Get notified about new content',
            Icons.notifications,
            true,
            (value) {
              // TODO: Handle notification preference
            },
          ),
          _buildPreferenceItem(
            'Auto-play next video',
            'Automatically play the next video in course',
            Icons.skip_next,
            true,
            (value) {
              // TODO: Handle auto-play preference
            },
          ),
          _buildPreferenceItem(
            'Download over WiFi only',
            'Only download content when connected to WiFi',
            Icons.wifi,
            true,
            (value) {
              // TODO: Handle download preference
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutApp() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Spirit',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            AppConstants.appDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Version',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              ),
              Text(
                AppConstants.appVersion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
