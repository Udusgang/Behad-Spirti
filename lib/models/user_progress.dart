class UserProgress {
  final String userId;
  final Map<String, VideoProgress> videoProgress;
  final Map<String, CourseProgress> courseProgress;
  final int totalWatchTimeMinutes;
  final DateTime lastWatchedAt;

  const UserProgress({
    required this.userId,
    required this.videoProgress,
    required this.courseProgress,
    required this.totalWatchTimeMinutes,
    required this.lastWatchedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'] as String,
      videoProgress: (json['videoProgress'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, VideoProgress.fromJson(value as Map<String, dynamic>)),
      ),
      courseProgress: (json['courseProgress'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, CourseProgress.fromJson(value as Map<String, dynamic>)),
      ),
      totalWatchTimeMinutes: json['totalWatchTimeMinutes'] as int,
      lastWatchedAt: DateTime.parse(json['lastWatchedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'videoProgress': videoProgress.map((key, value) => MapEntry(key, value.toJson())),
      'courseProgress': courseProgress.map((key, value) => MapEntry(key, value.toJson())),
      'totalWatchTimeMinutes': totalWatchTimeMinutes,
      'lastWatchedAt': lastWatchedAt.toIso8601String(),
    };
  }

  // Helper getters
  int get completedVideosCount {
    return videoProgress.values.where((progress) => progress.isCompleted).length;
  }

  int get completedCoursesCount {
    return courseProgress.values.where((progress) => progress.isCompleted).length;
  }

  String get formattedWatchTime {
    if (totalWatchTimeMinutes < 60) {
      return '${totalWatchTimeMinutes}m';
    } else {
      final hours = totalWatchTimeMinutes ~/ 60;
      final minutes = totalWatchTimeMinutes % 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
  }
}

class VideoProgress {
  final String videoId;
  final bool isCompleted;
  final int watchedSeconds;
  final DateTime lastWatchedAt;

  const VideoProgress({
    required this.videoId,
    required this.isCompleted,
    required this.watchedSeconds,
    required this.lastWatchedAt,
  });

  factory VideoProgress.fromJson(Map<String, dynamic> json) {
    return VideoProgress(
      videoId: json['videoId'] as String,
      isCompleted: json['isCompleted'] as bool,
      watchedSeconds: json['watchedSeconds'] as int,
      lastWatchedAt: DateTime.parse(json['lastWatchedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'isCompleted': isCompleted,
      'watchedSeconds': watchedSeconds,
      'lastWatchedAt': lastWatchedAt.toIso8601String(),
    };
  }

  double getProgressPercentage(int totalDuration) {
    if (totalDuration == 0) return 0.0;
    return (watchedSeconds / totalDuration).clamp(0.0, 1.0);
  }
}

class CourseProgress {
  final String courseId;
  final bool isCompleted;
  final int completedVideos;
  final int totalVideos;
  final DateTime lastWatchedAt;

  const CourseProgress({
    required this.courseId,
    required this.isCompleted,
    required this.completedVideos,
    required this.totalVideos,
    required this.lastWatchedAt,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['courseId'] as String,
      isCompleted: json['isCompleted'] as bool,
      completedVideos: json['completedVideos'] as int,
      totalVideos: json['totalVideos'] as int,
      lastWatchedAt: DateTime.parse(json['lastWatchedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'isCompleted': isCompleted,
      'completedVideos': completedVideos,
      'totalVideos': totalVideos,
      'lastWatchedAt': lastWatchedAt.toIso8601String(),
    };
  }

  double get progressPercentage {
    if (totalVideos == 0) return 0.0;
    return (completedVideos / totalVideos).clamp(0.0, 1.0);
  }
}
