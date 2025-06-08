import '../models/models.dart';

class StaticData {
  // Empty data - everything will be dynamic from admin panel
  static final List<Category> categories = [];
  static final List<Course> courses = [];
  static final List<Video> videos = [];

  // Empty user progress - will be dynamic
  static final UserProgress sampleUserProgress = UserProgress(
    userId: 'user_1',
    videoProgress: {},
    courseProgress: {},
    totalWatchTimeMinutes: 0,
    lastWatchedAt: DateTime.now(),
  );

  // Cosmic motivational quotes for the profile screen
  static final List<String> motivationalQuotes = [
    "The universe is not only stranger than we imagine, it is stranger than we can imagine. - J.B.S. Haldane",
    "We are all made of star stuff. - Carl Sagan",
    "The cosmos is within us. We are made of star-stuff. - Carl Sagan",
    "Look up at the stars and not down at your feet. - Stephen Hawking",
    "The universe is under no obligation to make sense to you. - Neil deGrasse Tyson",
    "The divine light of the Almighty Authority shines through every star in the cosmos.",
    "In the vastness of space, we find the infinite wisdom of creation.",
    "Peace comes from within. Do not seek it without. - Buddha",
  ];
  // Helper methods for dynamic data
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
      title: 'Cosmic Meditation: Connecting with Universal Energy',
      description: 'Journey through the cosmos and connect with the divine energy that flows through all galaxies. Experience the power of the Almighty Authority.',
      thumbnailUrl: 'https://img.youtube.com/vi/1ZYbU82GVz4/maxresdefault.jpg',
      courseId: 'course_1',
      duration: 1800, // 30 minutes
      orderIndex: 1,
      tags: ['cosmic', 'universe', 'divine energy', 'galaxies'],
    ),
    Video(
      id: 'video_2',
      youtubeId: 'aIIEI33EUqI', // Your second meditation video
      title: 'Stellar Relaxation: Floating Among the Stars',
      description: 'Float peacefully among the stars and experience the infinite calm of deep space. Feel the divine presence of the cosmic creator.',
      thumbnailUrl: 'https://img.youtube.com/vi/aIIEI33EUqI/maxresdefault.jpg',
      courseId: 'course_1',
      duration: 2100, // 35 minutes
      orderIndex: 2,
      tags: ['stars', 'cosmic relaxation', 'divine presence', 'space'],
    ),
    Video(
      id: 'video_3',
      youtubeId: 'j734gLbQFbU', // Your third meditation video
      title: 'Galaxy Mindfulness: Awareness of Cosmic Creation',
      description: 'Develop cosmic awareness and witness the magnificent creation of galaxies by the Almighty Authority. Expand your consciousness to universal scales.',
      thumbnailUrl: 'https://img.youtube.com/vi/j734gLbQFbU/maxresdefault.jpg',
      courseId: 'course_1',
      duration: 2400, // 40 minutes
      orderIndex: 3,
      tags: ['galaxy', 'cosmic awareness', 'creation', 'consciousness'],
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
        totalSeconds: 1800,
        lastWatchedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      'video_2': VideoProgress(
        videoId: 'video_2',
        isCompleted: false,
        watchedSeconds: 1200,
        totalSeconds: 2100,
        lastWatchedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      'video_6': VideoProgress(
        videoId: 'video_6',
        isCompleted: true,
        watchedSeconds: 1500,
        totalSeconds: 1500,
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
