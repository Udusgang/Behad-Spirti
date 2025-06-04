class AppConstants {
  // App Information
  static const String appName = 'Spirit';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A modern Flutter-based mobile learning application focused on spiritually inspired educational content.';

  // Navigation
  static const String homeRoute = '/home';
  static const String videoRoute = '/video';
  static const String progressRoute = '/progress';
  static const String profileRoute = '/profile';
  static const String courseDetailRoute = '/course-detail';

  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';

  // Default Images
  static const String defaultCategoryIcon = '${iconsPath}default_category.png';
  static const String defaultCourseThumbnail = '${imagesPath}default_course.png';
  static const String defaultVideoThumbnail = '${imagesPath}default_video.png';
  static const String defaultUserAvatar = '${imagesPath}default_avatar.png';

  // YouTube Configuration
  static const String youtubeBaseUrl = 'https://www.youtube.com/watch?v=';
  static const String youtubeThumbnailBaseUrl = 'https://img.youtube.com/vi/';
  static const String youtubeThumbnailSuffix = '/maxresdefault.jpg';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  static const double cardElevation = 2.0;
  static const double modalElevation = 8.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Grid Configuration
  static const int categoriesGridCrossAxisCount = 2;
  static const int coursesGridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.8;

  // Video Player Configuration
  static const double videoPlayerAspectRatio = 16 / 9;
  static const int videoProgressUpdateInterval = 1; // seconds
  static const double videoCompletionThreshold = 0.9; // 90%

  // Progress Configuration
  static const int maxRecentVideos = 5;
  static const int maxFeaturedCourses = 3;
  static const int streakResetDays = 2;

  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String videoLoadErrorMessage = 'Failed to load video. Please try again.';
  static const String dataLoadErrorMessage = 'Failed to load data. Please try again.';

  // Success Messages
  static const String videoCompletedMessage = 'Video completed! Great job!';
  static const String courseCompletedMessage = 'Congratulations! You\'ve completed this course!';
  static const String progressSavedMessage = 'Progress saved successfully.';

  // Placeholder Text
  static const String searchPlaceholder = 'Search courses and videos...';
  static const String noCoursesFound = 'No courses found.';
  static const String noVideosFound = 'No videos found.';
  static const String noProgressYet = 'Start watching to track your progress.';

  // Category IDs (matching static data)
  static const String spiritualCategoryId = 'spiritual';
  static const String meditationCategoryId = 'meditation';
  static const String ancientKnowledgeCategoryId = 'ancient_knowledge';
  static const String consciousnessCategoryId = 'consciousness';

  // Difficulty Levels
  static const String beginnerDifficulty = 'beginner';
  static const String intermediateDifficulty = 'intermediate';
  static const String advancedDifficulty = 'advanced';

  // Bottom Navigation
  static const List<String> bottomNavLabels = [
    'Home',
    'Progress',
    'Profile',
  ];

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Local Storage Keys (for future use)
  static const String userProgressKey = 'user_progress';
  static const String userPreferencesKey = 'user_preferences';
  static const String lastWatchedVideoKey = 'last_watched_video';
  static const String appThemeKey = 'app_theme';

  // API Configuration (for future use)
  static const String baseApiUrl = 'https://api.spirit-learning.com';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Feature Flags (for future use)
  static const bool enableOfflineMode = false;
  static const bool enableDarkMode = false;
  static const bool enableNotifications = false;
  static const bool enableAnalytics = false;
}
