import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';

class VideoProvider with ChangeNotifier {
  Video? _currentVideo;
  bool _isPlaying = false;
  bool _isFullScreen = false;
  bool _isLoading = false;
  String? _error;
  String _viewMode = 'embedded'; // 'embedded', 'external', 'youtube_app'

  // Getters
  Video? get currentVideo => _currentVideo;
  bool get isPlaying => _isPlaying;
  bool get isFullScreen => _isFullScreen;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get viewMode => _viewMode;

  // Get formatted progress (simplified since we don't track actual playback)
  String get formattedProgress {
    if (_currentVideo == null) return '0:00 / 0:00';
    return '0:00 / ${_currentVideo!.formattedDuration}';
  }

  // Initialize video (simplified - just set current video)
  Future<void> initializeVideo(Video video) async {
    _setLoading(true);
    try {
      _currentVideo = video;
      print('🎬 Setting current video: ${video.title}');
      print('📺 YouTube ID: ${video.youtubeId}');
      print('🔗 YouTube URL: ${video.youtubeUrl}');

      // Simulate brief loading
      await Future.delayed(const Duration(milliseconds: 300));

      _error = null;
      print('✅ Video ready for viewing');
    } catch (e) {
      print('❌ Error setting video: $e');
      _error = 'Failed to load video: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Set view mode for video playback
  void setViewMode(String mode) {
    _viewMode = mode;
    print('📺 View mode set to: $mode');
    notifyListeners();
  }

  // Open video in YouTube app
  Future<void> openInYouTubeApp() async {
    if (_currentVideo == null) return;

    try {
      final youtubeAppUrl = 'youtube://watch?v=${_currentVideo!.youtubeId}';
      final webUrl = _currentVideo!.youtubeUrl;

      // Try to open in YouTube app first
      if (await canLaunchUrl(Uri.parse(youtubeAppUrl))) {
        await launchUrl(Uri.parse(youtubeAppUrl));
        print('✅ Opened in YouTube app');
      } else {
        // Fallback to web browser
        await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
        print('✅ Opened in web browser');
      }
    } catch (e) {
      print('❌ Error opening video: $e');
      _setError('Failed to open video: $e');
    }
  }

  // Open video in web browser
  Future<void> openInBrowser() async {
    if (_currentVideo == null) return;

    try {
      await launchUrl(
        Uri.parse(_currentVideo!.youtubeUrl),
        mode: LaunchMode.externalApplication,
      );
      print('✅ Opened video in browser');
    } catch (e) {
      print('❌ Error opening video in browser: $e');
      _setError('Failed to open video in browser: $e');
    }
  }

  // Simulate play (for UI state)
  void simulatePlay() {
    _isPlaying = true;
    print('▶️ Simulating play state');
    notifyListeners();
  }

  // Simulate pause (for UI state)
  void simulatePause() {
    _isPlaying = false;
    print('⏸️ Simulating pause state');
    notifyListeners();
  }

  // Toggle play/pause simulation
  void togglePlayPause() {
    if (_isPlaying) {
      simulatePause();
    } else {
      simulatePlay();
    }
  }

  // Enter fullscreen
  void enterFullScreen() {
    _isFullScreen = true;
    notifyListeners();
  }

  // Exit fullscreen
  void exitFullScreen() {
    _isFullScreen = false;
    notifyListeners();
  }

  // Toggle fullscreen
  void toggleFullScreen() {
    if (_isFullScreen) {
      exitFullScreen();
    } else {
      enterFullScreen();
    }
  }

  // Get video embed URL for WebView
  String get embedUrl {
    if (_currentVideo == null) return '';
    return 'https://www.youtube.com/embed/${_currentVideo!.youtubeId}?autoplay=0&controls=1&rel=0&showinfo=0&modestbranding=1';
  }

  // Load next video in course
  Future<void> loadNextVideo(List<Video> courseVideos) async {
    if (_currentVideo == null) return;

    final currentIndex = courseVideos.indexWhere((video) => video.id == _currentVideo!.id);
    if (currentIndex != -1 && currentIndex < courseVideos.length - 1) {
      final nextVideo = courseVideos[currentIndex + 1];
      await initializeVideo(nextVideo);
    }
  }

  // Load previous video in course
  Future<void> loadPreviousVideo(List<Video> courseVideos) async {
    if (_currentVideo == null) return;

    final currentIndex = courseVideos.indexWhere((video) => video.id == _currentVideo!.id);
    if (currentIndex > 0) {
      final previousVideo = courseVideos[currentIndex - 1];
      await initializeVideo(previousVideo);
    }
  }

  // Check if there's a next video
  bool hasNextVideo(List<Video> courseVideos) {
    if (_currentVideo == null) return false;
    final currentIndex = courseVideos.indexWhere((video) => video.id == _currentVideo!.id);
    return currentIndex != -1 && currentIndex < courseVideos.length - 1;
  }

  // Check if there's a previous video
  bool hasPreviousVideo(List<Video> courseVideos) {
    if (_currentVideo == null) return false;
    final currentIndex = courseVideos.indexWhere((video) => video.id == _currentVideo!.id);
    return currentIndex > 0;
  }

  // Reset video state
  void resetVideo() {
    _currentVideo = null;
    _isPlaying = false;
    _isFullScreen = false;
    _error = null;
    notifyListeners();
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    resetVideo();
    super.dispose();
  }
}
