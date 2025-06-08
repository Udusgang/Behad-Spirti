import 'package:flutter/foundation.dart';
import '../models/models.dart';


class ProgressProvider with ChangeNotifier {
  UserProgress _userProgress = UserProgress(
    userId: 'user_1',
    videoProgress: {},
    courseProgress: {},
    totalWatchTimeMinutes: 0,
    lastWatchedAt: DateTime.now(),
  );
  bool _isLoading = false;
  String? _error;

  // Getters
  UserProgress get userProgress => _userProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Video progress methods
  VideoProgress? getVideoProgress(String videoId) {
    return _userProgress.videoProgress[videoId];
  }

  bool isVideoCompleted(String videoId) {
    final progress = getVideoProgress(videoId);
    return progress?.isCompleted ?? false;
  }

  double getVideoProgressPercentage(String videoId, int totalDuration) {
    final progress = getVideoProgress(videoId);
    if (progress == null) return 0.0;
    return progress.getProgressPercentage(totalDuration);
  }

  // Course progress methods
  CourseProgress? getCourseProgress(String courseId) {
    return _userProgress.courseProgress[courseId];
  }

  bool isCourseCompleted(String courseId) {
    final progress = getCourseProgress(courseId);
    return progress?.isCompleted ?? false;
  }

  double getCourseProgressPercentage(String courseId) {
    final progress = getCourseProgress(courseId);
    return progress?.progressPercentage ?? 0.0;
  }

  // Update video progress
  Future<void> updateVideoProgress({
    required String videoId,
    required String courseId,
    required int watchedSeconds,
    required int totalDuration,
    bool? isCompleted,
  }) async {
    _setLoading(true);
    try {
      final now = DateTime.now();
      final completed = isCompleted ?? (watchedSeconds >= totalDuration * 0.9);

      // Update video progress
      final newVideoProgress = VideoProgress(
        videoId: videoId,
        isCompleted: completed,
        watchedSeconds: watchedSeconds,
        totalSeconds: totalDuration,
        lastWatchedAt: now,
      );

      final updatedVideoProgress = Map<String, VideoProgress>.from(_userProgress.videoProgress);
      updatedVideoProgress[videoId] = newVideoProgress;

      // Update course progress
      // Note: This will need to be updated to use dynamic course provider
      final courseVideos = <Video>[]; // Empty for now - will be dynamic
      final completedVideosInCourse = courseVideos.where((video) {
        final progress = updatedVideoProgress[video.id];
        return progress?.isCompleted ?? false;
      }).length;

      final newCourseProgress = CourseProgress(
        courseId: courseId,
        isCompleted: completedVideosInCourse == courseVideos.length,
        completedVideos: completedVideosInCourse,
        totalVideos: courseVideos.length,
        lastWatchedAt: now,
      );

      final updatedCourseProgress = Map<String, CourseProgress>.from(_userProgress.courseProgress);
      updatedCourseProgress[courseId] = newCourseProgress;

      // Calculate new total watch time
      final additionalMinutes = (watchedSeconds / 60).ceil();
      final newTotalWatchTime = _userProgress.totalWatchTimeMinutes + additionalMinutes;

      // Update user progress
      _userProgress = UserProgress(
        userId: _userProgress.userId,
        videoProgress: updatedVideoProgress,
        courseProgress: updatedCourseProgress,
        totalWatchTimeMinutes: newTotalWatchTime,
        lastWatchedAt: now,
      );

      _error = null;
    } catch (e) {
      _error = 'Failed to update progress: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Mark video as completed
  Future<void> markVideoCompleted(String videoId, String courseId) async {
    final video = StaticData.getVideoById(videoId);
    if (video != null) {
      await updateVideoProgress(
        videoId: videoId,
        courseId: courseId,
        watchedSeconds: video.duration,
        totalDuration: video.duration,
        isCompleted: true,
      );
    }
  }

  // Mark video as not completed
  Future<void> markVideoNotCompleted(String videoId, String courseId) async {
    _setLoading(true);
    try {
      final now = DateTime.now();
      final currentProgress = getVideoProgress(videoId);

      final newVideoProgress = VideoProgress(
        videoId: videoId,
        isCompleted: false,
        watchedSeconds: currentProgress?.watchedSeconds ?? 0,
        totalSeconds: currentProgress?.totalSeconds ?? 0,
        lastWatchedAt: now,
      );

      final updatedVideoProgress = Map<String, VideoProgress>.from(_userProgress.videoProgress);
      updatedVideoProgress[videoId] = newVideoProgress;

      // Update course progress
      // Note: This will need to be updated to use dynamic course provider
      final courseVideos = <Video>[]; // Empty for now - will be dynamic
      final completedVideosInCourse = courseVideos.where((video) {
        final progress = updatedVideoProgress[video.id];
        return progress?.isCompleted ?? false;
      }).length;

      final newCourseProgress = CourseProgress(
        courseId: courseId,
        isCompleted: false, // Course can't be completed if we're unmarking a video
        completedVideos: completedVideosInCourse,
        totalVideos: courseVideos.length,
        lastWatchedAt: now,
      );

      final updatedCourseProgress = Map<String, CourseProgress>.from(_userProgress.courseProgress);
      updatedCourseProgress[courseId] = newCourseProgress;

      _userProgress = UserProgress(
        userId: _userProgress.userId,
        videoProgress: updatedVideoProgress,
        courseProgress: updatedCourseProgress,
        totalWatchTimeMinutes: _userProgress.totalWatchTimeMinutes,
        lastWatchedAt: now,
      );

      _error = null;
    } catch (e) {
      _error = 'Failed to update progress: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Get completed videos
  List<String> getCompletedVideoIds() {
    return _userProgress.videoProgress.entries
        .where((entry) => entry.value.isCompleted)
        .map((entry) => entry.key)
        .toList();
  }

  // Get completed courses
  List<String> getCompletedCourseIds() {
    return _userProgress.courseProgress.entries
        .where((entry) => entry.value.isCompleted)
        .map((entry) => entry.key)
        .toList();
  }

  // Get in-progress courses
  List<String> getInProgressCourseIds() {
    return _userProgress.courseProgress.entries
        .where((entry) => !entry.value.isCompleted && entry.value.completedVideos > 0)
        .map((entry) => entry.key)
        .toList();
  }

  // Get recently watched videos
  List<String> getRecentlyWatchedVideoIds({int limit = 5}) {
    final sortedEntries = _userProgress.videoProgress.entries.toList()
      ..sort((a, b) => b.value.lastWatchedAt.compareTo(a.value.lastWatchedAt));
    
    return sortedEntries
        .take(limit)
        .map((entry) => entry.key)
        .toList();
  }

  // Get learning streak (consecutive days with watch activity)
  int getLearningStreak() {
    // This is a simplified implementation
    // In a real app, you'd track daily activity more precisely
    final daysSinceLastWatch = DateTime.now().difference(_userProgress.lastWatchedAt).inDays;
    return daysSinceLastWatch <= 1 ? 1 : 0; // Simplified streak calculation
  }

  // Get total progress statistics
  Map<String, dynamic> getProgressStats() {
    return {
      'totalWatchTime': _userProgress.formattedWatchTime,
      'completedVideos': _userProgress.completedVideosCount,
      'completedCourses': _userProgress.completedCoursesCount,
      'inProgressCourses': getInProgressCourseIds().length,
      'learningStreak': getLearningStreak(),
      'lastWatchedAt': _userProgress.lastWatchedAt,
    };
  }

  // Reset all progress (for testing purposes)
  Future<void> resetProgress() async {
    _setLoading(true);
    try {
      _userProgress = UserProgress(
        userId: _userProgress.userId,
        videoProgress: {},
        courseProgress: {},
        totalWatchTimeMinutes: 0,
        lastWatchedAt: DateTime.now(),
      );
      _error = null;
    } catch (e) {
      _error = 'Failed to reset progress: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
