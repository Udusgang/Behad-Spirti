import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../providers/video_provider.dart';
import '../providers/dynamic_progress_provider.dart';

class VideoScreen extends StatefulWidget {
  final Video video;
  final List<Video> courseVideos;

  const VideoScreen({
    super.key,
    required this.video,
    this.courseVideos = const [],
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoProvider _videoProvider;
  late DynamicProgressProvider _progressProvider;

  @override
  void initState() {
    super.initState();
    _videoProvider = context.read<VideoProvider>();
    _progressProvider = context.read<DynamicProgressProvider>();

    // Initialize video player
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _videoProvider.initializeVideo(widget.video);
    });
  }

  @override
  void dispose() {
    _videoProvider.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.video.title,
          style: TextStyle(
            color: AppTheme.starWhite,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.deepSpace,
              AppTheme.primaryPurple,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<VideoProvider>(
            builder: (context, videoProvider, child) {
              return Column(
                children: [
                  // Video player
                  Container(
                    height: 200,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.accentGold.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: _buildVideoPlayer(videoProvider),
                    ),
                  ),
                  // Video details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.video.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.starWhite,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: AppTheme.accentGold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDuration(widget.video.duration),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.cosmicSilver,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.video.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.cosmicSilver,
                              height: 1.5,
                            ),
                          ),
                          if (videoProvider.error != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      videoProvider.error!,
                                      style: const TextStyle(color: Colors.red, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(VideoProvider videoProvider) {
    if (videoProvider.isLoading) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading video...',
                style: TextStyle(
                  color: AppTheme.starWhite,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (videoProvider.error != null || videoProvider.controller == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load video',
                style: TextStyle(
                  color: AppTheme.starWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your internet connection',
                style: TextStyle(
                  color: AppTheme.cosmicSilver,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  videoProvider.initializeVideo(widget.video);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return YoutubePlayer(
      controller: videoProvider.controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: AppTheme.accentGold,
      progressColors: ProgressBarColors(
        playedColor: AppTheme.accentGold,
        handleColor: AppTheme.accentGold,
        bufferedColor: AppTheme.accentGold.withOpacity(0.3),
        backgroundColor: Colors.grey.withOpacity(0.3),
      ),
      onReady: () {
        print('✅ YouTube player ready');
        // Update progress when video is ready
        _updateVideoProgress(videoProvider);
      },
      onEnded: (metaData) {
        print('🏁 Video ended');
        // Mark video as completed
        _progressProvider.updateVideoProgress(
          videoId: widget.video.id,
          watchedSeconds: metaData.duration.inSeconds,
          totalSeconds: metaData.duration.inSeconds,
          isCompleted: true,
        );
      },
    );
  }

  void _updateVideoProgress(VideoProvider videoProvider) {
    // Update progress every few seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && videoProvider.controller != null) {
        final position = videoProvider.currentPosition;
        final duration = videoProvider.totalDuration;

        if (duration.inSeconds > 0) {
          final isCompleted = position.inSeconds / duration.inSeconds >= 0.9;

          _progressProvider.updateVideoProgress(
            videoId: widget.video.id,
            watchedSeconds: position.inSeconds,
            totalSeconds: duration.inSeconds,
            isCompleted: isCompleted,
          );
        }

        // Continue updating if video is still playing
        if (videoProvider.isPlaying) {
          _updateVideoProgress(videoProvider);
        }
      }
    });
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else {
      return '${minutes}m ${secs}s';
    }
  }
}
