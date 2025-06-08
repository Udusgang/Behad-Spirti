import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dynamic_course_provider.dart';
import '../providers/progress_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh progress data if needed
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressOverview(),
              const SizedBox(height: 24),
              _buildLearningStreak(),
              const SizedBox(height: 24),
              _buildRecentActivity(),
              const SizedBox(height: 24),
              _buildInProgressCourses(),
              const SizedBox(height: 24),
              _buildCompletedCourses(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        final stats = progressProvider.getProgressStats();
        
        return Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: AppTheme.gradientDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Learning Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Watch Time',
                      stats['totalWatchTime'] as String,
                      Icons.access_time,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Videos Completed',
                      '${stats['completedVideos']}',
                      Icons.play_circle_filled,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Courses Completed',
                      '${stats['completedCourses']}',
                      Icons.school,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'In Progress',
                      '${stats['inProgressCourses']}',
                      Icons.trending_up,
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

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningStreak() {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        final streak = progressProvider.getLearningStreak();
        final lastWatched = progressProvider.userProgress.lastWatchedAt;
        
        return Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: AppTheme.cardDecoration,
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: streak > 0 ? Colors.orange.withOpacity(0.1) : AppTheme.lightGray,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: streak > 0 ? Colors.orange : AppTheme.mediumGray,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learning Streak',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      streak > 0 
                          ? '$streak day${streak > 1 ? 's' : ''} in a row!'
                          : 'Start your learning streak today!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    Text(
                      'Last activity: ${AppHelpers.formatTimeAgo(lastWatched)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentActivity() {
    return Consumer2<ProgressProvider, DynamicCourseProvider>(
      builder: (context, progressProvider, courseProvider, child) {
        final recentVideoIds = progressProvider.getRecentlyWatchedVideoIds(limit: 3);
        
        if (recentVideoIds.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: AppTheme.cardDecoration,
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'No recent activity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Start watching videos to see your activity here',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ...recentVideoIds.map((videoId) {
              final video = courseProvider.getVideoById(videoId);
              final videoProgress = progressProvider.getVideoProgress(videoId);
              
              if (video == null || videoProgress == null) {
                return const SizedBox.shrink();
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: AppTheme.cardDecoration,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.lightGray,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          video.youtubeThumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.play_arrow,
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Watched ${AppHelpers.formatTimeAgo(videoProgress.lastWatchedAt)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ProgressIndicatorWidget(
                            progress: videoProgress.getProgressPercentage(video.duration),
                            height: 3,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      videoProgress.isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                      color: videoProgress.isCompleted ? Colors.green : AppTheme.primaryPurple,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildInProgressCourses() {
    return Consumer2<ProgressProvider, DynamicCourseProvider>(
      builder: (context, progressProvider, courseProvider, child) {
        final inProgressCourseIds = progressProvider.getInProgressCourseIds();
        
        if (inProgressCourseIds.isEmpty) {
          return const SizedBox.shrink();
        }

        final inProgressCourses = inProgressCourseIds
            .map((id) => courseProvider.getCourseById(id))
            .where((course) => course != null)
            .cast<Course>()
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Continue Learning',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: inProgressCourses.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final course = inProgressCourses[index];
                  return SizedBox(
                    width: 200,
                    child: CourseCard(
                      course: course,
                      onTap: () => _navigateToCourseDetail(context, course),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompletedCourses() {
    return Consumer2<ProgressProvider, DynamicCourseProvider>(
      builder: (context, progressProvider, courseProvider, child) {
        final completedCourseIds = progressProvider.getCompletedCourseIds();
        
        if (completedCourseIds.isEmpty) {
          return const SizedBox.shrink();
        }

        final completedCourses = completedCourseIds
            .map((id) => courseProvider.getCourseById(id))
            .where((course) => course != null)
            .cast<Course>()
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed Courses',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppHelpers.getGridCrossAxisCount(context),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: AppConstants.gridChildAspectRatio,
              ),
              itemCount: completedCourses.length,
              itemBuilder: (context, index) {
                final course = completedCourses[index];
                return CourseCard(
                  course: course,
                  onTap: () => _navigateToCourseDetail(context, course),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToCourseDetail(BuildContext context, Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(course: course),
      ),
    );
  }
}
