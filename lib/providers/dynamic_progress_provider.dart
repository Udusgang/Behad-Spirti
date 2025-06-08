import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/models.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class DynamicProgressProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  
  UserProgress? _userProgress;
  bool _isLoading = false;
  String? _error;
  
  StreamSubscription<UserProgress?>? _progressSubscription;

  // Getters
  UserProgress? get userProgress => _userProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  DynamicProgressProvider() {
    _initializeProgress();
  }

  @override
  void dispose() {
    _progressSubscription?.cancel();
    super.dispose();
  }

  // Initialize progress tracking
  Future<void> _initializeProgress() async {
    final user = _authService.currentUser;
    if (user == null) return;

    _setLoading(true);
    
    try {
      // Listen to user progress changes
      _progressSubscription = _firestoreService.getUserProgress(user.uid).listen(
        (progress) {
          if (progress == null) {
            // Initialize progress for new user
            _initializeUserProgress(user.uid);
          } else {
            _userProgress = progress;
            notifyListeners();
          }
        },
        onError: (error) {
          _setError('Failed to load progress: $error');
        },
      );
      
      _error = null;
    } catch (e) {
      _setError('Failed to initialize progress tracking: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Initialize progress for new user
  Future<void> _initializeUserProgress(String userId) async {
    try {
      await _firestoreService.initializeUserProgress(userId);
    } catch (e) {
      _setError('Failed to initialize user progress: $e');
    }
  }

  // Update video progress
  Future<void> updateVideoProgress({
    required String videoId,
    required int watchedSeconds,
    required int totalSeconds,
    bool isCompleted = false,
  }) async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      final progress = VideoProgress(
        videoId: videoId,
        watchedSeconds: watchedSeconds,
        totalSeconds: totalSeconds,
        isCompleted: isCompleted,
        lastWatchedAt: DateTime.now(),
      );

      await _firestoreService.updateVideoProgress(user.uid, videoId, progress);
      
      // Update local progress immediately for better UX
      if (_userProgress != null) {
        final updatedVideoProgress = Map<String, VideoProgress>.from(_userProgress!.videoProgress);
        updatedVideoProgress[videoId] = progress;
        
        _userProgress = _userProgress!.copyWith(
          videoProgress: updatedVideoProgress,
          lastWatchedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update video progress: $e');
    }
  }

  // Mark video as completed
  Future<void> markVideoCompleted(String videoId, int totalSeconds) async {
    await updateVideoProgress(
      videoId: videoId,
      watchedSeconds: totalSeconds,
      totalSeconds: totalSeconds,
      isCompleted: true,
    );
  }

  // Update course progress
  Future<void> updateCourseProgress({
    required String courseId,
    required List<String> videoIds,
  }) async {
    final user = _authService.currentUser;
    if (user == null || _userProgress == null) return;

    try {
      // Calculate completed videos in this course
      final completedVideos = videoIds.where((videoId) {
        final videoProgress = _userProgress!.videoProgress[videoId];
        return videoProgress?.isCompleted ?? false;
      }).length;

      final isCompleted = completedVideos == videoIds.length && videoIds.isNotEmpty;

      final progress = CourseProgress(
        courseId: courseId,
        isCompleted: isCompleted,
        completedVideos: completedVideos,
        totalVideos: videoIds.length,
        lastWatchedAt: DateTime.now(),
      );

      await _firestoreService.updateCourseProgress(user.uid, courseId, progress);
      
      // Update local progress
      final updatedCourseProgress = Map<String, CourseProgress>.from(_userProgress!.courseProgress);
      updatedCourseProgress[courseId] = progress;
      
      _userProgress = _userProgress!.copyWith(
        courseProgress: updatedCourseProgress,
        lastWatchedAt: DateTime.now(),
      );
      notifyListeners();
    } catch (e) {
      _setError('Failed to update course progress: $e');
    }
  }

  // Get video progress
  VideoProgress? getVideoProgress(String videoId) {
    return _userProgress?.videoProgress[videoId];
  }

  // Get course progress
  CourseProgress? getCourseProgress(String courseId) {
    return _userProgress?.courseProgress[courseId];
  }

  // Check if video is completed
  bool isVideoCompleted(String videoId) {
    return getVideoProgress(videoId)?.isCompleted ?? false;
  }

  // Check if course is completed
  bool isCourseCompleted(String courseId) {
    return getCourseProgress(courseId)?.isCompleted ?? false;
  }

  // Get course completion percentage
  double getCourseCompletionPercentage(String courseId) {
    final progress = getCourseProgress(courseId);
    if (progress == null || progress.totalVideos == 0) return 0.0;
    return progress.completedVideos / progress.totalVideos;
  }

  // Get video completion percentage
  double getVideoCompletionPercentage(String videoId) {
    final progress = getVideoProgress(videoId);
    if (progress == null || progress.totalSeconds == 0) return 0.0;
    return progress.watchedSeconds / progress.totalSeconds;
  }

  // Get total watch time in minutes
  int getTotalWatchTimeMinutes() {
    if (_userProgress == null) return 0;
    
    return _userProgress!.videoProgress.values
        .fold(0, (total, progress) => total + (progress.watchedSeconds ~/ 60));
  }

  // Get completed videos count
  int getCompletedVideosCount() {
    if (_userProgress == null) return 0;
    
    return _userProgress!.videoProgress.values
        .where((progress) => progress.isCompleted)
        .length;
  }

  // Get completed courses count
  int getCompletedCoursesCount() {
    if (_userProgress == null) return 0;
    
    return _userProgress!.courseProgress.values
        .where((progress) => progress.isCompleted)
        .length;
  }

  // Get learning streak (simplified calculation)
  int getLearningStreak() {
    if (_userProgress == null) return 0;
    
    // This is a simplified calculation
    // In a real app, you'd track daily activity
    final daysSinceLastWatch = DateTime.now()
        .difference(_userProgress!.lastWatchedAt)
        .inDays;
    
    return daysSinceLastWatch <= 1 ? 7 : 0; // Mock streak
  }

  // Get progress statistics
  Map<String, dynamic> getProgressStats() {
    final totalWatchTime = getTotalWatchTimeMinutes();
    final hours = totalWatchTime ~/ 60;
    final minutes = totalWatchTime % 60;
    
    String formattedWatchTime;
    if (hours > 0) {
      formattedWatchTime = '${hours}h ${minutes}m';
    } else {
      formattedWatchTime = '${minutes}m';
    }

    return {
      'totalWatchTime': formattedWatchTime,
      'completedVideos': getCompletedVideosCount(),
      'completedCourses': getCompletedCoursesCount(),
      'learningStreak': getLearningStreak(),
    };
  }

  // Get recent activity (last 5 watched videos)
  List<VideoProgress> getRecentActivity() {
    if (_userProgress == null) return [];
    
    final allProgress = _userProgress!.videoProgress.values.toList();
    allProgress.sort((a, b) => b.lastWatchedAt.compareTo(a.lastWatchedAt));
    
    return allProgress.take(5).toList();
  }

  // Refresh progress data
  Future<void> refreshProgress() async {
    await _initializeProgress();
  }

  // Reset progress (for testing purposes)
  Future<void> resetProgress() async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      await _firestoreService.initializeUserProgress(user.uid);
    } catch (e) {
      _setError('Failed to reset progress: $e');
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

  // Handle user authentication changes
  void onUserChanged() {
    _progressSubscription?.cancel();
    _userProgress = null;
    _initializeProgress();
  }
}
