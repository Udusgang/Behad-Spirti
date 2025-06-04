import 'package:flutter/foundation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/models.dart';

class VideoProvider with ChangeNotifier {
  YoutubePlayerController? _controller;
  Video? _currentVideo;
  bool _isPlaying = false;
  bool _isFullScreen = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isLoading = false;
  String? _error;

  // Getters
  YoutubePlayerController? get controller => _controller;
  Video? get currentVideo => _currentVideo;
  bool get isPlaying => _isPlaying;
  bool get isFullScreen => _isFullScreen;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize video player
  Future<void> initializeVideo(Video video) async {
    _setLoading(true);
    try {
      // Dispose previous controller if exists
      await disposeController();

      _currentVideo = video;
      
      _controller = YoutubePlayerController(
        initialVideoId: video.youtubeId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          captionLanguage: 'en',
          forceHD: false,
          loop: false,
        ),
      );

      // Add listeners
      _controller!.addListener(_onPlayerStateChanged);

      _error = null;
    } catch (e) {
      _error = 'Failed to initialize video: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Player state change listener
  void _onPlayerStateChanged() {
    if (_controller == null) return;

    final playerState = _controller!.value.playerState;
    final position = _controller!.value.position;
    final duration = _controller!.value.metaData.duration;

    _isPlaying = playerState == PlayerState.playing;
    _currentPosition = position;
    _totalDuration = duration;

    notifyListeners();
  }

  // Play video
  Future<void> play() async {
    if (_controller != null) {
      _controller!.play();
    }
  }

  // Pause video
  Future<void> pause() async {
    if (_controller != null) {
      _controller!.pause();
    }
  }

  // Seek to position
  Future<void> seekTo(Duration position) async {
    if (_controller != null) {
      _controller!.seekTo(position);
    }
  }

  // Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  // Set volume
  Future<void> setVolume(int volume) async {
    if (_controller != null) {
      _controller!.setVolume(volume);
    }
  }

  // Toggle mute
  Future<void> toggleMute() async {
    if (_controller != null) {
      if (_controller!.value.volume > 0) {
        _controller!.setVolume(0);
      } else {
        _controller!.setVolume(100);
      }
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

  // Get current playback position in seconds
  int get currentPositionSeconds => _currentPosition.inSeconds;

  // Get total duration in seconds
  int get totalDurationSeconds => _totalDuration.inSeconds;

  // Get progress percentage
  double get progressPercentage {
    if (_totalDuration.inSeconds == 0) return 0.0;
    return (_currentPosition.inSeconds / _totalDuration.inSeconds).clamp(0.0, 1.0);
  }

  // Check if video is near completion (90% watched)
  bool get isNearCompletion {
    return progressPercentage >= 0.9;
  }

  // Format duration to string
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Get formatted current position
  String get formattedCurrentPosition => formatDuration(_currentPosition);

  // Get formatted total duration
  String get formattedTotalDuration => formatDuration(_totalDuration);

  // Get formatted progress (e.g., "5:30 / 10:45")
  String get formattedProgress => '$formattedCurrentPosition / $formattedTotalDuration';

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

  // Dispose controller
  Future<void> disposeController() async {
    if (_controller != null) {
      _controller!.removeListener(_onPlayerStateChanged);
      _controller!.dispose();
      _controller = null;
    }
    _currentVideo = null;
    _isPlaying = false;
    _isFullScreen = false;
    _currentPosition = Duration.zero;
    _totalDuration = Duration.zero;
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

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }
}
