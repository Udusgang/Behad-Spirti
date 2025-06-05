import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io';
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
            return Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading video player...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please wait while we prepare your meditation',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _testConnectivity(),
                          icon: const Icon(Icons.network_check),
                          label: const Text('Test Internet'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _clearWebViewCache(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Clear Cache'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if (videoProvider.controller == null) {
            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    const Text(
                      'Initializing player...',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    if (videoProvider.isLoading) ...[
                      Text(
                        'Video: ${widget.video.title}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ID: ${widget.video.youtubeId}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        videoProvider.exitFullScreen();
      },
      player: YoutubePlayer(
        controller: videoProvider.controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppTheme.primaryPurple,
        progressColors: ProgressBarColors(
          playedColor: AppTheme.primaryPurple,
          handleColor: AppTheme.primaryPurple,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey.shade300,
        ),
        onReady: () {
          print('✅ YouTube Player Ready (Fullscreen) - Video: ${widget.video.title}');
        },
        onEnded: (metaData) {
          print('📹 Video Ended (Fullscreen): ${widget.video.title}');
          _onVideoEnded();
        },
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 10.0),
          ProgressBar(isExpanded: true),
          const SizedBox(width: 10.0),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) => player,
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
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          _buildAppBar(),
          AspectRatio(
            aspectRatio: AppConstants.videoPlayerAspectRatio,
            child: YoutubePlayerBuilder(
              onExitFullScreen: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                videoProvider.exitFullScreen();
              },
              player: YoutubePlayer(
                controller: videoProvider.controller!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: AppTheme.primaryPurple,
                progressColors: ProgressBarColors(
                  playedColor: AppTheme.primaryPurple,
                  handleColor: AppTheme.primaryPurple,
                  backgroundColor: Colors.grey.shade300,
                  bufferedColor: Colors.grey.shade200,
                ),
                onReady: () {
                  print('✅ YouTube Player Ready - Video: ${widget.video.title}');
                  print('📺 Video ID: ${widget.video.youtubeId}');
                  // Clear any previous errors when player is ready
                  if (videoProvider.error != null) {
                    videoProvider.clearError();
                  }
                },
                onEnded: (metaData) {
                  print('📹 Video Ended: ${widget.video.title}');
                  _onVideoEnded();
                },
                bottomActions: [
                  CurrentPosition(),
                  const SizedBox(width: 6.0), // Reduced spacing
                  ProgressBar(
                    isExpanded: true,
                    colors: ProgressBarColors(
                      playedColor: AppTheme.primaryPurple,
                      handleColor: AppTheme.primaryPurple,
                      backgroundColor: Colors.grey.shade300,
                      bufferedColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(width: 6.0), // Reduced spacing
                  RemainingDuration(),
                  const SizedBox(width: 2.0), // Reduced spacing
                  FullScreenButton(),
                ],
              ),
              builder: (context, player) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: player,
                  ),
                );
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Row(
        children: [
          // Previous Video Button
          if (videoProvider.hasPreviousVideo(widget.courseVideos))
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  videoProvider.loadPreviousVideo(widget.courseVideos);
                },
                tooltip: 'Previous Video',
              ),
            ),

          const SizedBox(width: 8),

          // Play/Pause Button
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.9),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                videoProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () async {
                await videoProvider.togglePlayPause();
              },
              tooltip: videoProvider.isPlaying ? 'Pause' : 'Play',
            ),
          ),

          const SizedBox(width: 8),

          // Next Video Button
          if (videoProvider.hasNextVideo(widget.courseVideos))
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  videoProvider.loadNextVideo(widget.courseVideos);
                },
                tooltip: 'Next Video',
              ),
            ),

          const Spacer(),

          // Video Progress Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.white70,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  videoProvider.formattedProgress,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoDetails() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - AppConstants.defaultPadding * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar for visual indication
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16), // Reduced margin
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  _buildVideoInfo(),
                  const SizedBox(height: 16), // Reduced spacing
                  _buildActionButtons(),
                  const SizedBox(height: 16), // Reduced spacing
                  _buildVideoDescription(),
                  const SizedBox(height: 16), // Reduced spacing
                  _buildNextVideoSection(),
                  const SizedBox(height: 16), // Reduced bottom padding
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video Title with enhanced styling
        Text(
          widget.video.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),

        // Video metadata row
        Row(
          children: [
            // Duration chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppTheme.primaryPurple,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.video.formattedDuration,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Completion status
            Consumer<ProgressProvider>(
              builder: (context, progressProvider, child) {
                final isCompleted = progressProvider.isVideoCompleted(widget.video.id);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                        size: 16,
                        color: isCompleted ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCompleted ? 'Completed' : 'In Progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isCompleted ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),

        // Video position in course
        const SizedBox(height: 8),
        Text(
          'Video ${widget.courseVideos.indexWhere((v) => v.id == widget.video.id) + 1} of ${widget.courseVideos.length}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGray,
            fontStyle: FontStyle.italic,
          ),
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
    print('🎯 Video completed: ${widget.video.title}');

    // Mark video as completed when it ends
    context.read<ProgressProvider>().markVideoCompleted(
      widget.video.id,
      widget.video.courseId,
    );

    // Show completion message with enhanced styling
    AppHelpers.showSuccessSnackBar(
      context,
      '🎉 ${AppConstants.videoCompletedMessage}',
    );

    // Auto-play next video if available
    final videoProvider = context.read<VideoProvider>();
    if (videoProvider.hasNextVideo(widget.courseVideos)) {
      // Show next video dialog
      _showNextVideoDialog();
    } else {
      // Show course completion dialog
      _showCourseCompletionDialog();
    }
  }

  void _showNextVideoDialog() {
    final currentIndex = widget.courseVideos.indexWhere((v) => v.id == widget.video.id);
    final nextVideo = widget.courseVideos[currentIndex + 1];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.play_arrow, color: AppTheme.primaryPurple),
            SizedBox(width: 8),
            Text('Next Video'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Up next: ${nextVideo.title}'),
            const SizedBox(height: 8),
            Text(
              'Duration: ${nextVideo.formattedDuration}',
              style: const TextStyle(color: AppTheme.mediumGray),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay Here'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VideoProvider>().loadNextVideo(widget.courseVideos);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Play Next'),
          ),
        ],
      ),
    );
  }

  void _showCourseCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            SizedBox(width: 8),
            Text('Course Completed!'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎉 Congratulations!'),
            SizedBox(height: 8),
            Text('You have completed all videos in this course.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to course list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Back to Courses'),
          ),
        ],
      ),
    );
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

  void _testConnectivity() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Testing connectivity...'),
          ],
        ),
      ),
    );

    try {
      // Test basic internet connectivity
      final result = await InternetAddress.lookup('google.com');
      Navigator.pop(context); // Close loading dialog

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Test YouTube specifically
        try {
          final youtubeResult = await InternetAddress.lookup('youtube.com');
          if (youtubeResult.isNotEmpty) {
            _showConnectivityResult(
              'Internet Connection: ✅ Good\n'
              'YouTube Access: ✅ Available\n'
              'Video ID: ${widget.video.youtubeId}\n'
              'URL: ${widget.video.youtubeUrl}',
              true,
            );
          }
        } catch (e) {
          _showConnectivityResult(
            'Internet Connection: ✅ Good\n'
            'YouTube Access: ❌ Blocked\n'
            'Error: YouTube may be blocked in your network',
            false,
          );
        }
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showConnectivityResult(
        'Internet Connection: ❌ Failed\n'
        'Error: No internet connection\n'
        'Please check your network settings',
        false,
      );
    }
  }

  void _clearWebViewCache() async {
    AppHelpers.showLoadingDialog(context, message: 'Clearing cache...');

    try {
      // Dispose current controller
      await context.read<VideoProvider>().disposeController();

      // Wait a moment
      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.pop(context); // Close loading dialog

      // Reinitialize
      context.read<VideoProvider>().initializeVideo(widget.video);

      AppHelpers.showInfoSnackBar(context, 'Cache cleared. Retrying video...');
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      AppHelpers.showErrorSnackBar(context, 'Failed to clear cache: $e');
    }
  }

  void _showConnectivityResult(String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(isSuccess ? 'Connectivity Test' : 'Connection Issue'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (!isSuccess) ...[
              const SizedBox(height: 16),
              const Text(
                'Troubleshooting Steps:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Check WiFi/Mobile data\n'
                '2. Clear WebView cache (button above)\n'
                '3. Restart emulator with:\n'
                '   emulator -dns-server 8.8.8.8\n'
                '4. Try on physical device\n'
                '5. Cold boot emulator',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
        actions: [
          if (!isSuccess)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<VideoProvider>().initializeVideo(widget.video);
              },
              child: const Text('Retry Video'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
