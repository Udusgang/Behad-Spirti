import '../models/models.dart';

class StaticData {
  // Categories with spiritual themes
  static final List<Category> categories = [
    Category(
      id: 'spiritual',
      name: 'Spiritual Wisdom',
      description: 'Ancient wisdom and spiritual teachings for modern life',
      iconPath: 'assets/icons/spiritual.png',
      color: '#6B46C1', // Purple
      courseIds: ['course_1', 'course_2'],
    ),
    Category(
      id: 'meditation',
      name: 'Meditation & Mindfulness',
      description: 'Guided meditations and mindfulness practices',
      iconPath: 'assets/icons/meditation.png',
      color: '#059669', // Green
      courseIds: ['course_3', 'course_4'],
    ),
    Category(
      id: 'ancient_knowledge',
      name: 'Ancient Knowledge',
      description: 'Timeless wisdom from ancient civilizations',
      iconPath: 'assets/icons/ancient.png',
      color: '#DC2626', // Red
      courseIds: ['course_5'],
    ),
    Category(
      id: 'consciousness',
      name: 'Consciousness',
      description: 'Exploring the depths of human consciousness',
      iconPath: 'assets/icons/consciousness.png',
      color: '#7C3AED', // Violet
      courseIds: ['course_6'],
    ),
  ];

  // Sample courses with YouTube content
  static final List<Course> courses = [
    Course(
      id: 'course_1',
      title: 'Introduction to Spiritual Awakening',
      description: 'A comprehensive guide to beginning your spiritual journey',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      categoryId: 'spiritual',
      videoIds: ['video_1', 'video_2', 'video_3'],
      estimatedDuration: 120,
      difficulty: 'beginner',
      tags: ['spirituality', 'awakening', 'consciousness'],
    ),
    Course(
      id: 'course_2',
      title: 'Advanced Spiritual Practices',
      description: 'Deep dive into advanced spiritual techniques and practices',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      categoryId: 'spiritual',
      videoIds: ['video_4', 'video_5'],
      estimatedDuration: 90,
      difficulty: 'advanced',
      tags: ['spirituality', 'advanced', 'practices'],
    ),
    Course(
      id: 'course_3',
      title: 'Mindfulness for Beginners',
      description: 'Learn the fundamentals of mindfulness meditation',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      categoryId: 'meditation',
      videoIds: ['video_6', 'video_7', 'video_8'],
      estimatedDuration: 75,
      difficulty: 'beginner',
      tags: ['mindfulness', 'meditation', 'beginner'],
    ),
    Course(
      id: 'course_4',
      title: 'Advanced Meditation Techniques',
      description: 'Master advanced meditation and breathing techniques',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      categoryId: 'meditation',
      videoIds: ['video_9', 'video_10'],
      estimatedDuration: 60,
      difficulty: 'intermediate',
      tags: ['meditation', 'advanced', 'breathing'],
    ),
    Course(
      id: 'course_5',
      title: 'Wisdom of the Ancients',
      description: 'Explore timeless wisdom from ancient civilizations',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      categoryId: 'ancient_knowledge',
      videoIds: ['video_11', 'video_12', 'video_13'],
      estimatedDuration: 150,
      difficulty: 'intermediate',
      tags: ['ancient', 'wisdom', 'history'],
    ),
    Course(
      id: 'course_6',
      title: 'Understanding Consciousness',
      description: 'Deep exploration of consciousness and awareness',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      categoryId: 'consciousness',
      videoIds: ['video_14', 'video_15'],
      estimatedDuration: 100,
      difficulty: 'advanced',
      tags: ['consciousness', 'awareness', 'philosophy'],
    ),
  ];

  // Sample videos with YouTube IDs (using placeholder IDs for now)
  static final List<Video> videos = [
    // Spiritual Awakening Course
    Video(
      id: 'video_1',
      youtubeId: 'dQw4w9WgXcQ', // Placeholder YouTube ID
      title: 'What is Spiritual Awakening?',
      description: 'Understanding the fundamentals of spiritual awakening and its significance in modern life.',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      courseId: 'course_1',
      duration: 1800, // 30 minutes
      orderIndex: 1,
      tags: ['spirituality', 'awakening', 'introduction'],
    ),
    Video(
      id: 'video_2',
      youtubeId: 'dQw4w9WgXcQ',
      title: 'Signs of Spiritual Awakening',
      description: 'Recognizing the signs and symptoms of spiritual awakening in your daily life.',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      courseId: 'course_1',
      duration: 2400, // 40 minutes
      orderIndex: 2,
      tags: ['spirituality', 'signs', 'awareness'],
    ),
    Video(
      id: 'video_3',
      youtubeId: 'dQw4w9WgXcQ',
      title: 'Beginning Your Spiritual Journey',
      description: 'Practical steps to start your spiritual journey with confidence and clarity.',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      courseId: 'course_1',
      duration: 3000, // 50 minutes
      orderIndex: 3,
      tags: ['spirituality', 'journey', 'practical'],
    ),
    // Add more videos for other courses...
    Video(
      id: 'video_6',
      youtubeId: 'dQw4w9WgXcQ',
      title: 'Introduction to Mindfulness',
      description: 'Learn the basics of mindfulness and how to incorporate it into daily life.',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      courseId: 'course_3',
      duration: 1500, // 25 minutes
      orderIndex: 1,
      tags: ['mindfulness', 'introduction', 'daily life'],
    ),
    Video(
      id: 'video_7',
      youtubeId: 'dQw4w9WgXcQ',
      title: 'Breathing Meditation Basics',
      description: 'Master the fundamental breathing techniques for meditation.',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      courseId: 'course_3',
      duration: 1800, // 30 minutes
      orderIndex: 2,
      tags: ['breathing', 'meditation', 'basics'],
    ),
    Video(
      id: 'video_8',
      youtubeId: 'dQw4w9WgXcQ',
      title: 'Body Scan Meditation',
      description: 'Learn the powerful body scan meditation technique for deep relaxation.',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      courseId: 'course_3',
      duration: 1200, // 20 minutes
      orderIndex: 3,
      tags: ['body scan', 'meditation', 'relaxation'],
    ),
  ];

  // Sample user progress (static for MVP)
  static final UserProgress sampleUserProgress = UserProgress(
    userId: 'user_1',
    videoProgress: {
      'video_1': VideoProgress(
        videoId: 'video_1',
        isCompleted: true,
        watchedSeconds: 1800,
        lastWatchedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      'video_2': VideoProgress(
        videoId: 'video_2',
        isCompleted: false,
        watchedSeconds: 1200,
        lastWatchedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      'video_6': VideoProgress(
        videoId: 'video_6',
        isCompleted: true,
        watchedSeconds: 1500,
        lastWatchedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    },
    courseProgress: {
      'course_1': CourseProgress(
        courseId: 'course_1',
        isCompleted: false,
        completedVideos: 1,
        totalVideos: 3,
        lastWatchedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      'course_3': CourseProgress(
        courseId: 'course_3',
        isCompleted: false,
        completedVideos: 1,
        totalVideos: 3,
        lastWatchedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    },
    totalWatchTimeMinutes: 85,
    lastWatchedAt: DateTime.now().subtract(const Duration(hours: 5)),
  );

  // Motivational quotes for the profile screen
  static final List<String> motivationalQuotes = [
    "The journey of a thousand miles begins with one step. - Lao Tzu",
    "Be yourself; everyone else is already taken. - Oscar Wilde",
    "The only way to do great work is to love what you do. - Steve Jobs",
    "In the middle of difficulty lies opportunity. - Albert Einstein",
    "The mind is everything. What you think you become. - Buddha",
    "Peace comes from within. Do not seek it without. - Buddha",
    "Your task is not to seek for love, but merely to seek and find all the barriers within yourself that you have built against it. - Rumi",
    "The cave you fear to enter holds the treasure you seek. - Joseph Campbell",
  ];

  // Helper methods
  static List<Course> getCoursesByCategory(String categoryId) {
    return courses.where((course) => course.categoryId == categoryId).toList();
  }

  static List<Video> getVideosByCourse(String courseId) {
    return videos.where((video) => video.courseId == courseId).toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  static Course? getCourseById(String courseId) {
    try {
      return courses.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  static Video? getVideoById(String videoId) {
    try {
      return videos.firstWhere((video) => video.id == videoId);
    } catch (e) {
      return null;
    }
  }

  static Category? getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }
}
