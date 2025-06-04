import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../models/course.dart';
import '../models/video.dart';
import '../data/static_data.dart';

class CourseProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Course> _courses = [];
  List<Video> _videos = [];
  
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Category> get categories => _categories;
  List<Course> get courses => _courses;
  List<Video> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CourseProvider() {
    _loadData();
  }

  // Load static data (simulating API call)
  Future<void> _loadData() async {
    _setLoading(true);
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      _categories = StaticData.categories;
      _courses = StaticData.courses;
      _videos = StaticData.videos;
      
      _error = null;
    } catch (e) {
      _error = 'Failed to load data: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await _loadData();
  }

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
  List<Course> searchCourses(String query) {
    if (query.isEmpty) return _courses;
    
    final lowercaseQuery = query.toLowerCase();
    return _courses.where((course) {
      return course.title.toLowerCase().contains(lowercaseQuery) ||
             course.description.toLowerCase().contains(lowercaseQuery) ||
             course.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  List<Video> searchVideos(String query) {
    if (query.isEmpty) return _videos;
    
    final lowercaseQuery = query.toLowerCase();
    return _videos.where((video) {
      return video.title.toLowerCase().contains(lowercaseQuery) ||
             video.description.toLowerCase().contains(lowercaseQuery) ||
             video.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Filter courses by difficulty
  List<Course> getCoursesByDifficulty(String difficulty) {
    return _courses.where((course) => course.difficulty == difficulty).toList();
  }

  // Get featured courses (first 3 courses for now)
  List<Course> getFeaturedCourses() {
    return _courses.take(3).toList();
  }

  // Get recently added courses (last 3 courses for now)
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

  // Get total course count
  int get totalCourseCount => _courses.length;

  // Get total video count
  int get totalVideoCount => _videos.length;

  // Get course count by category
  int getCourseCountByCategory(String categoryId) {
    return getCoursesByCategory(categoryId).length;
  }

  // Get video count by course
  int getVideoCountByCourse(String courseId) {
    return getVideosByCourse(courseId).length;
  }

  // Get total duration by course
  int getTotalDurationByCourse(String courseId) {
    final videos = getVideosByCourse(courseId);
    return videos.fold(0, (total, video) => total + video.duration);
  }

  // Get formatted total duration by course
  String getFormattedTotalDurationByCourse(String courseId) {
    final totalSeconds = getTotalDurationByCourse(courseId);
    final minutes = totalSeconds ~/ 60;
    
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0 ? '${hours}h ${remainingMinutes}m' : '${hours}h';
    }
  }
}
