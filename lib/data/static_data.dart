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
      title: 'Essential Meditation Collection',
      description: 'A beautiful collection of guided meditations for inner peace, relaxation, and mindfulness practice',
      thumbnailUrl: 'https://img.youtube.com/vi/1ZYbU82GVz4/maxresdefault.jpg',
      categoryId: 'meditation',
      videoIds: ['video_1', 'video_2', 'video_3'],
      estimatedDuration: 120,
      difficulty: 'beginner',
      tags: ['meditation', 'guided', 'peace'],
    ),
    Course(
      id: 'course_2',
      title: 'Advanced Spiritual Meditation',
      description: 'Deep spiritual practices including chakra healing and awakening meditation for advanced practitioners',
      thumbnailUrl: 'https://img.youtube.com/vi/sfSDQRdIvTc/maxresdefault.jpg',
      categoryId: 'spiritual',
      videoIds: ['video_4', 'video_5'],
      estimatedDuration: 95,
      difficulty: 'advanced',
      tags: ['spiritual', 'chakra', 'awakening'],
    ),
    Course(
      id: 'course_3',
      title: 'Daily Mindfulness Practice',
      description: 'Practical meditation sessions for daily stress relief, better sleep, and mindful living',
      thumbnailUrl: 'https://img.youtube.com/vi/aIIEI33EUqI/maxresdefault.jpg',
      categoryId: 'meditation',
      videoIds: ['video_6', 'video_7', 'video_8'],
      estimatedDuration: 75,
      difficulty: 'beginner',
      tags: ['mindfulness', 'daily practice', 'stress relief'],
    ),
    Course(
      id: 'course_4',
      title: 'Advanced Meditation Techniques',
      description: 'Master advanced meditation and breathing techniques for deeper spiritual connection',
      thumbnailUrl: 'https://img.youtube.com/vi/SEfs5TJZ6Nk/maxresdefault.jpg',
      categoryId: 'meditation',
      videoIds: ['video_9', 'video_10'],
      estimatedDuration: 60,
      difficulty: 'intermediate',
      tags: ['meditation', 'advanced', 'breathing'],
    ),
    Course(
      id: 'course_5',
      title: 'Wisdom of the Ancients',
      description: 'Explore timeless wisdom from ancient civilizations and sacred traditions',
      thumbnailUrl: 'https://img.youtube.com/vi/ZToicYcHIOU/maxresdefault.jpg',
      categoryId: 'ancient_knowledge',
      videoIds: ['video_11', 'video_12', 'video_13'],
      estimatedDuration: 150,
      difficulty: 'intermediate',
      tags: ['ancient', 'wisdom', 'history'],
    ),
    Course(
      id: 'course_6',
      title: 'Understanding Consciousness',
      description: 'Deep exploration of consciousness, awareness, and the nature of reality',
      thumbnailUrl: 'https://img.youtube.com/vi/StrbppmsZJw/maxresdefault.jpg',
      categoryId: 'consciousness',
      videoIds: ['video_14', 'video_15'],
      estimatedDuration: 100,
      difficulty: 'advanced',
      tags: ['consciousness', 'awareness', 'philosophy'],
    ),
  ];

  // Real meditation videos with your provided YouTube links
  static final List<Video> videos = [
    // Meditation & Mindfulness Course - Your Real Videos
    Video(
      id: 'video_1',
      youtubeId: '1ZYbU82GVz4', // Your first meditation video
      title: 'Guided Meditation for Inner Peace',
      description: 'A beautiful guided meditation session to help you find inner peace and tranquility. Perfect for beginners and experienced practitioners.',
      thumbnailUrl: 'https://img.youtube.com/vi/1ZYbU82GVz4/maxresdefault.jpg',
      courseId: 'course_1',
      duration: 1800, // 30 minutes
      orderIndex: 1,
      tags: ['meditation', 'inner peace', 'guided'],
    ),
    Video(
      id: 'video_2',
      youtubeId: 'aIIEI33EUqI', // Your second meditation video
      title: 'Deep Relaxation Meditation',
      description: 'Experience deep relaxation and stress relief through this powerful meditation practice. Let go of tension and find your center.',
      thumbnailUrl: 'https://img.youtube.com/vi/aIIEI33EUqI/maxresdefault.jpg',
      courseId: 'course_1',
      duration: 2100, // 35 minutes
      orderIndex: 2,
      tags: ['meditation', 'relaxation', 'stress relief'],
    ),
    Video(
      id: 'video_3',
      youtubeId: 'j734gLbQFbU', // Your third meditation video
      title: 'Mindfulness Meditation Practice',
      description: 'Develop mindfulness and present moment awareness through this comprehensive meditation practice. Cultivate inner wisdom.',
      thumbnailUrl: 'https://img.youtube.com/vi/j734gLbQFbU/maxresdefault.jpg',
      courseId: 'course_1',
      duration: 2400, // 40 minutes
      orderIndex: 3,
      tags: ['mindfulness', 'awareness', 'practice'],
    ),
    // Advanced Meditation Course - Your Additional Videos
    Video(
      id: 'video_4',
      youtubeId: 'sfSDQRdIvTc', // Your fourth meditation video
      title: 'Chakra Healing Meditation',
      description: 'Balance and align your chakras through this powerful healing meditation. Experience energy flow and spiritual awakening.',
      thumbnailUrl: 'https://img.youtube.com/vi/sfSDQRdIvTc/maxresdefault.jpg',
      courseId: 'course_2',
      duration: 2700, // 45 minutes
      orderIndex: 1,
      tags: ['chakra', 'healing', 'energy'],
    ),
    Video(
      id: 'video_5',
      youtubeId: 'Dzorasi7G64', // Your fifth meditation video
      title: 'Spiritual Awakening Meditation',
      description: 'Awaken your spiritual consciousness through this transformative meditation practice. Connect with your higher self.',
      thumbnailUrl: 'https://img.youtube.com/vi/Dzorasi7G64/maxresdefault.jpg',
      courseId: 'course_2',
      duration: 3000, // 50 minutes
      orderIndex: 2,
      tags: ['spiritual', 'awakening', 'consciousness'],
    ),

    // Additional Mindfulness Course
    Video(
      id: 'video_6',
      youtubeId: '1ZYbU82GVz4', // Reusing your first video for variety
      title: 'Daily Mindfulness Practice',
      description: 'Incorporate mindfulness into your daily routine with this practical meditation guide.',
      thumbnailUrl: 'https://img.youtube.com/vi/1ZYbU82GVz4/maxresdefault.jpg',
      courseId: 'course_3',
      duration: 1500, // 25 minutes
      orderIndex: 1,
      tags: ['mindfulness', 'daily practice', 'routine'],
    ),
    Video(
      id: 'video_7',
      youtubeId: 'aIIEI33EUqI', // Reusing your second video
      title: 'Stress Relief Meditation',
      description: 'Release stress and tension with this calming meditation session designed for busy lifestyles.',
      thumbnailUrl: 'https://img.youtube.com/vi/aIIEI33EUqI/maxresdefault.jpg',
      courseId: 'course_3',
      duration: 1800, // 30 minutes
      orderIndex: 2,
      tags: ['stress relief', 'relaxation', 'calm'],
    ),
    Video(
      id: 'video_8',
      youtubeId: 'j734gLbQFbU', // Reusing your third video
      title: 'Evening Meditation for Sleep',
      description: 'Prepare for restful sleep with this gentle evening meditation practice.',
      thumbnailUrl: 'https://img.youtube.com/vi/j734gLbQFbU/maxresdefault.jpg',
      courseId: 'course_3',
      duration: 1200, // 20 minutes
      orderIndex: 3,
      tags: ['evening', 'sleep', 'relaxation'],
    ),

    // Advanced Spiritual Practices
    Video(
      id: 'video_4',
      youtubeId: 'Jyy0ra2WcQQ', // Real chakra meditation
      title: 'Chakra Meditation & Energy Healing',
      description: 'Explore the seven chakras and learn powerful energy healing techniques for spiritual growth.',
      thumbnailUrl: 'https://img.youtube.com/vi/Jyy0ra2WcQQ/maxresdefault.jpg',
      courseId: 'course_2',
      duration: 2700, // 45 minutes
      orderIndex: 1,
      tags: ['chakra', 'energy', 'healing'],
    ),
    Video(
      id: 'video_5',
      youtubeId: 'StrbppmsZJw', // Real manifestation video
      title: 'Manifestation & Law of Attraction',
      description: 'Learn the ancient art of manifestation and how to align with the law of attraction for spiritual abundance.',
      thumbnailUrl: 'https://img.youtube.com/vi/StrbppmsZJw/maxresdefault.jpg',
      courseId: 'course_2',
      duration: 2100, // 35 minutes
      orderIndex: 2,
      tags: ['manifestation', 'law of attraction', 'abundance'],
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
