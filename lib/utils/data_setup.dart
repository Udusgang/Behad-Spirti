import '../services/firestore_service.dart';
import '../models/models.dart';

class DataSetup {
  static final FirestoreService _firestoreService = FirestoreService();

  /// Setup initial cosmic data in Firestore
  static Future<void> setupInitialData() async {
    try {
      print('🌌 Setting up initial cosmic data...');
      
      // Setup categories
      await _setupCategories();
      
      // Setup courses
      await _setupCourses();
      
      // Setup videos
      await _setupVideos();
      
      print('✨ Initial cosmic data setup complete!');
    } catch (e) {
      print('❌ Error setting up initial data: $e');
      rethrow;
    }
  }

  static Future<void> _setupCategories() async {
    final categories = [
      Category(
        id: 'cosmic_creation',
        name: 'Cosmic Creation',
        description: 'Discover how the Almighty Authority created the universe and galaxies',
        iconPath: 'assets/icons/galaxy.png',
        color: '#1A0B3D',
        courseIds: [],
        order: 1,
      ),
      Category(
        id: 'stellar_wisdom',
        name: 'Stellar Wisdom',
        description: 'Ancient cosmic knowledge and divine teachings from the stars',
        iconPath: 'assets/icons/stars.png',
        color: '#FFD700',
        courseIds: [],
        order: 2,
      ),
      Category(
        id: 'divine_mysteries',
        name: 'Divine Mysteries',
        description: 'Unlock the sacred mysteries of creation and divine authority',
        iconPath: 'assets/icons/divine.png',
        color: '#4C1D95',
        courseIds: [],
        order: 3,
      ),
      Category(
        id: 'universal_consciousness',
        name: 'Universal Consciousness',
        description: 'Connect with the cosmic consciousness that governs all existence',
        iconPath: 'assets/icons/consciousness.png',
        color: '#1E40AF',
        courseIds: [],
        order: 4,
      ),
    ];

    for (final category in categories) {
      await _firestoreService.addCategory(category);
      print('📂 Added category: ${category.name}');
    }
  }

  static Future<void> _setupCourses() async {
    final courses = [
      Course(
        id: '',
        title: 'Cosmic Meditation: Journey Through the Universe',
        description: 'Experience divine meditation while contemplating the vastness of creation by the Almighty Authority. Journey through galaxies and connect with cosmic energy.',
        thumbnailUrl: 'https://img.youtube.com/vi/1ZYbU82GVz4/maxresdefault.jpg',
        categoryId: 'cosmic_creation',
        videoIds: [],
        estimatedDuration: 120,
        difficulty: 'beginner',
        tags: ['cosmic', 'universe', 'divine', 'creation', 'meditation'],
        featured: true,
      ),
      Course(
        id: '',
        title: 'Stellar Wisdom: Ancient Knowledge from the Stars',
        description: 'Unlock the ancient wisdom encoded in the stars by the supreme creator. Learn how celestial bodies carry divine messages.',
        thumbnailUrl: 'https://img.youtube.com/vi/aIIEI33EUqI/maxresdefault.jpg',
        categoryId: 'stellar_wisdom',
        videoIds: [],
        estimatedDuration: 90,
        difficulty: 'intermediate',
        tags: ['stars', 'wisdom', 'ancient', 'celestial', 'divine'],
        featured: true,
      ),
      Course(
        id: '',
        title: 'Galaxy Formation: Divine Architecture',
        description: 'Witness the magnificent process of galaxy formation as designed by the Almighty Authority. Understand the cosmic blueprint.',
        thumbnailUrl: 'https://img.youtube.com/vi/j734gLbQFbU/maxresdefault.jpg',
        categoryId: 'cosmic_creation',
        videoIds: [],
        estimatedDuration: 150,
        difficulty: 'advanced',
        tags: ['galaxy', 'formation', 'divine', 'architecture', 'cosmos'],
        featured: false,
      ),
      Course(
        id: '',
        title: 'Universal Consciousness Awakening',
        description: 'Awaken to the universal consciousness that connects all beings across the cosmos. Experience oneness with creation.',
        thumbnailUrl: 'https://img.youtube.com/vi/1ZYbU82GVz4/maxresdefault.jpg',
        categoryId: 'universal_consciousness',
        videoIds: [],
        estimatedDuration: 180,
        difficulty: 'intermediate',
        tags: ['consciousness', 'awakening', 'universal', 'oneness', 'cosmic'],
        featured: true,
      ),
    ];

    for (final course in courses) {
      await _firestoreService.addCourse(course);
      print('🎓 Added course: ${course.title}');
    }
  }

  static Future<void> _setupVideos() async {
    // Note: You'll need to replace these with your actual YouTube video IDs
    final videos = [
      Video(
        id: '',
        youtubeId: '1ZYbU82GVz4', // Replace with your actual YouTube ID
        title: 'Cosmic Meditation: Connecting with Universal Energy',
        description: 'Journey through the cosmos and connect with the divine energy that flows through all galaxies. Experience the power of the Almighty Authority.',
        thumbnailUrl: 'https://img.youtube.com/vi/1ZYbU82GVz4/maxresdefault.jpg',
        courseId: 'cosmic_creation', // This will need to be updated with actual course ID
        duration: 1800, // 30 minutes
        orderIndex: 1,
        tags: ['cosmic', 'universe', 'divine energy', 'galaxies'],
      ),
      Video(
        id: '',
        youtubeId: 'aIIEI33EUqI', // Replace with your actual YouTube ID
        title: 'Stellar Relaxation: Floating Among the Stars',
        description: 'Float peacefully among the stars and experience the infinite calm of deep space. Feel the divine presence of the cosmic creator.',
        thumbnailUrl: 'https://img.youtube.com/vi/aIIEI33EUqI/maxresdefault.jpg',
        courseId: 'cosmic_creation',
        duration: 2100, // 35 minutes
        orderIndex: 2,
        tags: ['stars', 'cosmic relaxation', 'divine presence', 'space'],
      ),
      Video(
        id: '',
        youtubeId: 'j734gLbQFbU', // Replace with your actual YouTube ID
        title: 'Galaxy Mindfulness: Awareness of Cosmic Creation',
        description: 'Develop cosmic awareness and witness the magnificent creation of galaxies by the Almighty Authority. Expand your consciousness to universal scales.',
        thumbnailUrl: 'https://img.youtube.com/vi/j734gLbQFbU/maxresdefault.jpg',
        courseId: 'cosmic_creation',
        duration: 2400, // 40 minutes
        orderIndex: 3,
        tags: ['galaxy', 'cosmic awareness', 'creation', 'consciousness'],
      ),
      Video(
        id: '',
        youtubeId: '1ZYbU82GVz4', // Replace with your actual YouTube ID
        title: 'Divine Wisdom from Ancient Stars',
        description: 'Receive ancient wisdom transmitted through starlight across billions of years. Connect with the eternal knowledge of creation.',
        thumbnailUrl: 'https://img.youtube.com/vi/1ZYbU82GVz4/maxresdefault.jpg',
        courseId: 'stellar_wisdom',
        duration: 1500, // 25 minutes
        orderIndex: 1,
        tags: ['divine wisdom', 'ancient', 'stars', 'eternal knowledge'],
      ),
      Video(
        id: '',
        youtubeId: 'aIIEI33EUqI', // Replace with your actual YouTube ID
        title: 'Celestial Messages: Reading the Cosmic Signs',
        description: 'Learn to interpret the divine messages written in the movements of celestial bodies by the supreme creator.',
        thumbnailUrl: 'https://img.youtube.com/vi/aIIEI33EUqI/maxresdefault.jpg',
        courseId: 'stellar_wisdom',
        duration: 1800, // 30 minutes
        orderIndex: 2,
        tags: ['celestial', 'messages', 'cosmic signs', 'divine'],
      ),
    ];

    for (final video in videos) {
      await _firestoreService.addVideo(video);
      print('🎬 Added video: ${video.title}');
    }
  }

  /// Clear all data (for testing purposes)
  static Future<void> clearAllData() async {
    print('🗑️ Clearing all data...');
    // Note: This would require additional methods in FirestoreService
    // to delete all documents in collections
    print('⚠️ Clear data functionality needs to be implemented');
  }

  /// Check if initial data exists
  static Future<bool> hasInitialData() async {
    try {
      // Check if categories exist
      final categoriesStream = _firestoreService.getCategories();
      final categories = await categoriesStream.first;
      return categories.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Setup data only if it doesn't exist
  static Future<void> setupDataIfNeeded() async {
    final hasData = await hasInitialData();
    if (!hasData) {
      print('🌟 No initial data found, setting up...');
      await setupInitialData();
    } else {
      print('✅ Initial data already exists');
    }
  }
}
