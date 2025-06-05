import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class VideoScreen extends StatefulWidget {
  final Video video;
  final List<Video> courseVideos;

  const VideoScreen({
    super.key,
    required this.video,
    required this.courseVideos,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoProvider>().initializeVideo(widget.video);
    });
  }

  @override
  void dispose() {
    context.read<VideoProvider>().disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (videoProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (videoProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    videoProvider.error!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      videoProvider.initializeVideo(widget.video);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (videoProvider.controller == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return videoProvider.isFullScreen
              ? _buildFullScreenPlayer(videoProvider)
              : _buildNormalPlayer(videoProvider);
        },
      ),
    );
  }

  Widget _buildFullScreenPlayer(VideoProvider videoProvider) {
    return YoutubePlayer(
      controller: videoProvider.controller!,
      showVideoProgressIndicator: true,
      onReady: () {
        // Player is ready
      },
      onEnded: (metaData) {
        _onVideoEnded();
      },
    );
  }

  Widget _buildNormalPlayer(VideoProvider videoProvider) {
    return SafeArea(
      child: Column(
        children: [
          _buildPlayerSection(videoProvider),
          Expanded(
            child: _buildVideoDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerSection(VideoProvider videoProvider) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          _buildAppBar(),
          AspectRatio(
            aspectRatio: AppConstants.videoPlayerAspectRatio,
            child: YoutubePlayer(
              controller: videoProvider.controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppTheme.primaryPurple,
              progressColors: ProgressBarColors(
                playedColor: AppTheme.primaryPurple,
                handleColor: AppTheme.primaryPurple,
              ),
              onReady: () {
                // Player is ready
              },
              onEnded: (metaData) {
                _onVideoEnded();
              },
            ),
          ),
          _buildPlayerControls(videoProvider),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Consumer<VideoProvider>(
            builder: (context, videoProvider, child) {
              return IconButton(
                icon: Icon(
                  videoProvider.isFullScreen
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
                  color: Colors.white,
                ),
                onPressed: () {
                  videoProvider.toggleFullScreen();
                  if (videoProvider.isFullScreen) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight,
                    ]);
                  } else {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerControls(VideoProvider videoProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (videoProvider.hasPreviousVideo(widget.courseVideos))
            IconButton(
              icon: const Icon(Icons.skip_previous, color: Colors.white),
              onPressed: () {
                videoProvider.loadPreviousVideo(widget.courseVideos);
              },
            ),
          IconButton(
            icon: Icon(
              videoProvider.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              videoProvider.togglePlayPause();
            },
          ),
          if (videoProvider.hasNextVideo(widget.courseVideos))
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white),
              onPressed: () {
                videoProvider.loadNextVideo(widget.courseVideos);
              },
            ),
          const Spacer(),
          Text(
            videoProvider.formattedProgress,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoDetails() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoInfo(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildVideoDescription(),
            const SizedBox(height: 24),
            _buildNextVideoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.video.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              widget.video.formattedDuration,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
            const SizedBox(width: 16),
            Consumer<ProgressProvider>(
              builder: (context, progressProvider, child) {
                final isCompleted = progressProvider.isVideoCompleted(widget.video.id);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green.withOpacity(0.1) : AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                        size: 16,
                        color: isCompleted ? Colors.green : AppTheme.mediumGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCompleted ? 'Completed' : 'In Progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isCompleted ? Colors.green : AppTheme.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        final isCompleted = progressProvider.isVideoCompleted(widget.video.id);

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isCompleted) {
                        progressProvider.markVideoNotCompleted(
                          widget.video.id,
                          widget.video.courseId,
                        );
                        AppHelpers.showInfoSnackBar(context, 'Video marked as not completed');
                      } else {
                        progressProvider.markVideoCompleted(
                          widget.video.id,
                          widget.video.courseId,
                        );
                        AppHelpers.showSuccessSnackBar(context, AppConstants.videoCompletedMessage);
                      }
                    },
                    icon: Icon(isCompleted ? Icons.replay : Icons.check),
                    label: Text(isCompleted ? 'Mark as Not Completed' : 'Mark as Completed'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openInYouTube(),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open in YouTube'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareVideo(),
                    icon: const Icon(Icons.share),
                    label: const Text('Share Video'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          widget.video.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (widget.video.tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Tags',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.video.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  tag,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildNextVideoSection() {
    final currentIndex = widget.courseVideos.indexWhere((v) => v.id == widget.video.id);
    if (currentIndex == -1 || currentIndex >= widget.courseVideos.length - 1) {
      return const SizedBox.shrink();
    }

    final nextVideo = widget.courseVideos[currentIndex + 1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Up Next',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            context.read<VideoProvider>().initializeVideo(nextVideo);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.cardDecoration,
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.lightGray,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      nextVideo.youtubeThumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.play_arrow,
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextVideo.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nextVideo.formattedDuration,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.play_arrow,
                  color: AppTheme.primaryPurple,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onVideoEnded() {
    // Mark video as completed when it ends
    context.read<ProgressProvider>().markVideoCompleted(
      widget.video.id,
      widget.video.courseId,
    );

    AppHelpers.showSuccessSnackBar(context, AppConstants.videoCompletedMessage);

    // Auto-play next video if available
    final videoProvider = context.read<VideoProvider>();
    if (videoProvider.hasNextVideo(widget.courseVideos)) {
      Future.delayed(const Duration(seconds: 2), () {
        videoProvider.loadNextVideo(widget.courseVideos);
      });
    }
  }

  void _openInYouTube() {
    // For now, just show the YouTube URL in a dialog
    // In a real app, you would use url_launcher package to open the URL
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('YouTube Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Video URL:'),
            const SizedBox(height: 8),
            SelectableText(
              widget.video.youtubeUrl,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Copy this URL to open in YouTube app or browser.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _shareVideo() {
    // For now, just show the share dialog with video info
    // In a real app, you would use share_plus package
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Video'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.video.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.video.description),
            const SizedBox(height: 16),
            const Text('YouTube URL:'),
            const SizedBox(height: 4),
            SelectableText(
              widget.video.youtubeUrl,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
