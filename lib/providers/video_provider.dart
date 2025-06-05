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
      print('🎬 Initializing video: ${video.title}');
      print('📺 YouTube ID: ${video.youtubeId}');

      _controller = YoutubePlayerController(
        initialVideoId: video.youtubeId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false, // Disable captions to reduce loading issues
          forceHD: false,
          loop: false,
          isLive: false,
          controlsVisibleAtStart: true,
          hideControls: false,
          hideThumbnail: false,
          disableDragSeek: false,
          useHybridComposition: true, // Better WebView performance
        ),
      );

      // Add listeners
      _controller!.addListener(_onPlayerStateChanged);

      // Wait longer for controller to properly initialize
      await Future.delayed(const Duration(milliseconds: 800));

      // Verify controller is ready
      int retryCount = 0;
      while (!_controller!.value.isReady && retryCount < 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        retryCount++;
        print('⏳ Waiting for controller to be ready... (attempt $retryCount)');
      }

      if (_controller!.value.isReady) {
        print('✅ YouTube controller initialized and ready');
        _error = null;
      } else {
        print('⚠️ Controller initialized but not ready after retries');
        // Don't set error here, let it try to work
      }
    } catch (e) {
      print('❌ Error initializing video: $e');
      _error = 'Failed to initialize video: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Player state change listener
  void _onPlayerStateChanged() {
    if (_controller == null) return;

    try {
      // Check if controller is ready before accessing values
      if (_controller!.value.isReady) {
        final playerState = _controller!.value.playerState;
        final position = _controller!.value.position;
        final duration = _controller!.value.metaData.duration;

        _isPlaying = playerState == PlayerState.playing;
        _currentPosition = position;
        _totalDuration = duration;

        // Clear any previous errors when controller is working
        if (_error != null) {
          _error = null;
        }

        print('🎵 Player state: ${playerState.toString()}, Position: ${position.inSeconds}s');
      } else {
        print('⏳ Controller not ready in state change listener');
      }
    } catch (e) {
      print('❌ Error in player state change: $e');
      // Don't set error here as it might be temporary
    }

    notifyListeners();
  }

  // Play video
  Future<void> play() async {
    if (_controller != null) {
      if (_controller!.value.isReady) {
        try {
          _controller!.play();
          _isPlaying = true;
          notifyListeners();
        } catch (e) {
          print('❌ Error playing video: $e');
          _setError('Failed to play video');
        }
      } else {
        print('⏳ Controller not ready for play - waiting...');
        // Try to wait for controller to be ready
        await _waitForControllerReady();
        if (_controller != null && _controller!.value.isReady) {
          await play(); // Retry
        } else {
          print('❌ Controller still not ready after waiting');
          _setError('Video player not ready. Please try again.');
        }
      }
    } else {
      print('❌ No controller available for play');
      _setError('Video player not initialized');
    }
  }

  // Pause video
  Future<void> pause() async {
    if (_controller != null) {
      if (_controller!.value.isReady) {
        try {
          _controller!.pause();
          _isPlaying = false;
          notifyListeners();
        } catch (e) {
          print('❌ Error pausing video: $e');
          _setError('Failed to pause video');
        }
      } else {
        print('⏳ Controller not ready for pause');
      }
    } else {
      print('❌ No controller available for pause');
    }
  }

  // Seek to position
  Future<void> seekTo(Duration position) async {
    if (_controller != null && _controller!.value.isReady) {
      try {
        _controller!.seekTo(position);
      } catch (e) {
        print('Error seeking video: $e');
      }
    } else {
      print('Controller not ready for seeking');
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
    if (_controller != null && _controller!.value.isReady) {
      try {
        _controller!.setVolume(volume);
      } catch (e) {
        print('Error setting volume: $e');
      }
    } else {
      print('Controller not ready for volume control');
    }
  }

  // Toggle mute
  Future<void> toggleMute() async {
    if (_controller != null && _controller!.value.isReady) {
      try {
        if (_controller!.value.volume > 0) {
          _controller!.setVolume(0);
        } else {
          _controller!.setVolume(100);
        }
      } catch (e) {
        print('Error toggling mute: $e');
      }
    } else {
      print('Controller not ready for mute control');
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Helper method to wait for controller to be ready
  Future<void> _waitForControllerReady() async {
    if (_controller == null) return;

    int attempts = 0;
    const maxAttempts = 15;
    const delayMs = 200;

    while (!_controller!.value.isReady && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: delayMs));
      attempts++;
      print('⏳ Waiting for controller readiness... (attempt $attempts/$maxAttempts)');
    }

    if (_controller!.value.isReady) {
      print('✅ Controller is now ready');
    } else {
      print('❌ Controller failed to become ready after $maxAttempts attempts');
    }
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }
}
