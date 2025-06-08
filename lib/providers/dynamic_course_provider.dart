import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/models.dart';
import '../services/firestore_service.dart';
import '../data/static_data.dart';

class DynamicCourseProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<Category> _categories = [];
  List<Course> _courses = [];
  List<Video> _videos = [];
  
  bool _isLoading = false;
  String? _error;
  bool _useFirestore = true; // Toggle between Firestore and static data
  
  // Stream subscriptions
  StreamSubscription<List<Category>>? _categoriesSubscription;
  StreamSubscription<List<Course>>? _coursesSubscription;
  StreamSubscription<List<Video>>? _videosSubscription;

  // Getters
  List<Category> get categories => _categories;
  List<Course> get courses => _courses;
  List<Video> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get useFirestore => _useFirestore;

  DynamicCourseProvider() {
    _initializeData();
  }

  @override
  void dispose() {
    _categoriesSubscription?.cancel();
    _coursesSubscription?.cancel();
    _videosSubscription?.cancel();
    super.dispose();
  }

  // Initialize data loading
  Future<void> _initializeData() async {
    _setLoading(true);
    
    if (_useFirestore) {
      await _loadFirestoreData();
    } else {
      await _loadStaticData();
    }
    
    _setLoading(false);
  }

  // Load data from Firestore
  Future<void> _loadFirestoreData() async {
    try {
      // Listen to categories
      _categoriesSubscription = _firestoreService.getCategories().listen(
        (categories) {
          _categories = categories;
          notifyListeners();
        },
        onError: (error) {
          _setError('Failed to load categories: $error');
        },
      );

      // Listen to courses
      _coursesSubscription = _firestoreService.getCourses().listen(
        (courses) {
          _courses = courses;
          notifyListeners();
        },
        onError: (error) {
          _setError('Failed to load courses: $error');
        },
      );

      // Listen to videos
      _videosSubscription = _firestoreService.getAllVideos().listen(
        (videos) {
          _videos = videos;
          notifyListeners();
        },
        onError: (error) {
          _setError('Failed to load videos: $error');
        },
      );

      _error = null;
    } catch (e) {
      _setError('Failed to initialize Firestore: $e');
      // Fallback to static data
      await _loadStaticData();
    }
  }

  // Load static data (fallback)
  Future<void> _loadStaticData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _categories = StaticData.categories;
      _courses = StaticData.courses;
      _videos = StaticData.videos;
      
      _error = null;
    } catch (e) {
      _setError('Failed to load static data: $e');
    }
  }

  // Toggle between Firestore and static data
  Future<void> toggleDataSource() async {
    _useFirestore = !_useFirestore;
    await _initializeData();
  }

  // Refresh data
  Future<void> refreshData() async {
    await _initializeData();
  }

  // ==================== COURSE MANAGEMENT ====================
  
  // Add new course (Firestore only)
  Future<bool> addCourse(Course course) async {
    if (!_useFirestore) return false;
    
    try {
      _setLoading(true);
      await _firestoreService.addCourse(course);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to add course: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update course (Firestore only)
  Future<bool> updateCourse(String courseId, Course course) async {
    if (!_useFirestore) return false;
    
    try {
      _setLoading(true);
      await _firestoreService.updateCourse(courseId, course);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update course: $e');
      _setLoading(false);
      return false;
    }
  }

  // Delete course (Firestore only)
  Future<bool> deleteCourse(String courseId) async {
    if (!_useFirestore) return false;
    
    try {
      _setLoading(true);
      await _firestoreService.deleteCourse(courseId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete course: $e');
      _setLoading(false);
      return false;
    }
  }

  // ==================== VIDEO MANAGEMENT ====================
  
  // Add new video (Firestore only)
  Future<bool> addVideo(Video video) async {
    if (!_useFirestore) return false;
    
    try {
      _setLoading(true);
      await _firestoreService.addVideo(video);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to add video: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update video (Firestore only)
  Future<bool> updateVideo(String videoId, Video video) async {
    if (!_useFirestore) return false;
    
    try {
      _setLoading(true);
      await _firestoreService.updateVideo(videoId, video);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update video: $e');
      _setLoading(false);
      return false;
    }
  }

  // Delete video (Firestore only)
  Future<bool> deleteVideo(String videoId) async {
    if (!_useFirestore) return false;
    
    try {
      _setLoading(true);
      await _firestoreService.deleteVideo(videoId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete video: $e');
      _setLoading(false);
      return false;
    }
  }

  // ==================== QUERY METHODS ====================
  
  // Get courses by category
  List<Course> getCoursesByCategory(String categoryId) {
    return _courses.where((course) => course.categoryId == categoryId).toList();
  }

  // Get videos by course
  List<Video> getVideosByCourse(String courseId) {
    return _videos
        .where((video) => video.courseId == courseId)
        .toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  // Get course by ID
  Course? getCourseById(String courseId) {
    try {
      return _courses.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  // Get video by ID
  Video? getVideoById(String videoId) {
    try {
      return _videos.firstWhere((video) => video.id == videoId);
    } catch (e) {
      return null;
    }
  }

  // Get category by ID
  Category? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  // Search functionality
  Future<List<Course>> searchCourses(String query) async {
    if (_useFirestore) {
      try {
        return await _firestoreService.searchCourses(query);
      } catch (e) {
        _setError('Search failed: $e');
        return [];
      }
    } else {
      if (query.isEmpty) return _courses;
      
      final lowercaseQuery = query.toLowerCase();
      return _courses.where((course) {
        return course.title.toLowerCase().contains(lowercaseQuery) ||
               course.description.toLowerCase().contains(lowercaseQuery) ||
               course.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
      }).toList();
    }
  }

  // Get featured courses
  Future<List<Course>> getFeaturedCourses() async {
    if (_useFirestore) {
      try {
        return await _firestoreService.getFeaturedCourses();
      } catch (e) {
        _setError('Failed to load featured courses: $e');
        return [];
      }
    } else {
      return _courses.take(3).toList();
    }
  }

  // Get recent courses
  List<Course> getRecentCourses() {
    return _courses.reversed.take(3).toList();
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

  // Statistics
  int get totalCourseCount => _courses.length;
  int get totalVideoCount => _videos.length;
  
  int getCourseCountByCategory(String categoryId) {
    return getCoursesByCategory(categoryId).length;
  }
  
  int getVideoCountByCourse(String courseId) {
    return getVideosByCourse(courseId).length;
  }
}
