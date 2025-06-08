import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String categoriesCollection = 'categories';
  static const String coursesCollection = 'courses';
  static const String videosCollection = 'videos';
  static const String userProgressCollection = 'user_progress';
  static const String usersCollection = 'users';

  // ==================== CATEGORIES ====================
  
  /// Get all categories
  Stream<List<Category>> getCategories() {
    return _firestore
        .collection(categoriesCollection)
        .orderBy('order', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Category.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Add a new category
  Future<String> addCategory(Category category) async {
    final docRef = await _firestore
        .collection(categoriesCollection)
        .add(category.toJson());
    return docRef.id;
  }

  /// Update category
  Future<void> updateCategory(String categoryId, Category category) async {
    await _firestore
        .collection(categoriesCollection)
        .doc(categoryId)
        .update(category.toJson());
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    await _firestore
        .collection(categoriesCollection)
        .doc(categoryId)
        .delete();
  }

  // ==================== COURSES ====================
  
  /// Get all courses
  Stream<List<Course>> getCourses() {
    return _firestore
        .collection(coursesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Course.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Get courses by category
  Stream<List<Course>> getCoursesByCategory(String categoryId) {
    return _firestore
        .collection(coursesCollection)
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Course.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Add a new course
  Future<String> addCourse(Course course) async {
    final courseData = course.toJson();
    courseData['createdAt'] = FieldValue.serverTimestamp();
    courseData['updatedAt'] = FieldValue.serverTimestamp();
    
    final docRef = await _firestore
        .collection(coursesCollection)
        .add(courseData);
    return docRef.id;
  }

  /// Update course
  Future<void> updateCourse(String courseId, Course course) async {
    final courseData = course.toJson();
    courseData['updatedAt'] = FieldValue.serverTimestamp();
    
    await _firestore
        .collection(coursesCollection)
        .doc(courseId)
        .update(courseData);
  }

  /// Delete course
  Future<void> deleteCourse(String courseId) async {
    await _firestore
        .collection(coursesCollection)
        .doc(courseId)
        .delete();
  }

  // ==================== VIDEOS ====================
  
  /// Get videos by course
  Stream<List<Video>> getVideosByCourse(String courseId) {
    return _firestore
        .collection(videosCollection)
        .where('courseId', isEqualTo: courseId)
        .orderBy('orderIndex', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Video.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Get all videos
  Stream<List<Video>> getAllVideos() {
    return _firestore
        .collection(videosCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Video.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Add a new video
  Future<String> addVideo(Video video) async {
    final videoData = video.toJson();
    videoData['createdAt'] = FieldValue.serverTimestamp();
    videoData['updatedAt'] = FieldValue.serverTimestamp();
    
    final docRef = await _firestore
        .collection(videosCollection)
        .add(videoData);
    return docRef.id;
  }

  /// Update video
  Future<void> updateVideo(String videoId, Video video) async {
    final videoData = video.toJson();
    videoData['updatedAt'] = FieldValue.serverTimestamp();
    
    await _firestore
        .collection(videosCollection)
        .doc(videoId)
        .update(videoData);
  }

  /// Delete video
  Future<void> deleteVideo(String videoId) async {
    await _firestore
        .collection(videosCollection)
        .doc(videoId)
        .delete();
  }

  // ==================== USER PROGRESS ====================
  
  /// Get user progress
  Stream<UserProgress?> getUserProgress(String userId) {
    return _firestore
        .collection(userProgressCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            return UserProgress.fromJson({...doc.data()!, 'userId': doc.id});
          }
          return null;
        });
  }

  /// Update video progress
  Future<void> updateVideoProgress(String userId, String videoId, VideoProgress progress) async {
    await _firestore
        .collection(userProgressCollection)
        .doc(userId)
        .set({
          'videoProgress.$videoId': progress.toJson(),
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  /// Update course progress
  Future<void> updateCourseProgress(String userId, String courseId, CourseProgress progress) async {
    await _firestore
        .collection(userProgressCollection)
        .doc(userId)
        .set({
          'courseProgress.$courseId': progress.toJson(),
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  /// Initialize user progress
  Future<void> initializeUserProgress(String userId) async {
    final userProgress = UserProgress(
      userId: userId,
      videoProgress: {},
      courseProgress: {},
      totalWatchTimeMinutes: 0,
      lastWatchedAt: DateTime.now(),
    );

    await _firestore
        .collection(userProgressCollection)
        .doc(userId)
        .set(userProgress.toJson());
  }

  // ==================== UTILITY METHODS ====================
  
  /// Search courses
  Future<List<Course>> searchCourses(String query) async {
    final snapshot = await _firestore
        .collection(coursesCollection)
        .get();
    
    return snapshot.docs
        .map((doc) => Course.fromJson({...doc.data(), 'id': doc.id}))
        .where((course) => 
            course.title.toLowerCase().contains(query.toLowerCase()) ||
            course.description.toLowerCase().contains(query.toLowerCase()) ||
            course.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  /// Get featured courses
  Future<List<Course>> getFeaturedCourses() async {
    final snapshot = await _firestore
        .collection(coursesCollection)
        .where('featured', isEqualTo: true)
        .limit(5)
        .get();
    
    return snapshot.docs
        .map((doc) => Course.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// Batch operations for initial data setup
  Future<void> setupInitialData() async {
    final batch = _firestore.batch();
    
    // This method can be used to populate initial data
    // Implementation depends on your specific needs
    
    await batch.commit();
  }
}
