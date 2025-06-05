import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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
  late WebViewController _webViewController;
  bool _isWebViewReady = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoProvider>().initializeVideo(widget.video);
    });
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('🌐 WebView started loading: $url');
          },
          onPageFinished: (String url) {
            print('✅ WebView finished loading: $url');
            setState(() {
              _isWebViewReady = true;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('❌ WebView error: ${error.description}');
          },
        ),
      );
  }

  @override
  void dispose() {
    context.read<VideoProvider>().resetVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (videoProvider.error != null) {
            return _buildErrorState(videoProvider);
          }

          if (videoProvider.isLoading) {
            return _buildLoadingState();
          }

          return videoProvider.isFullScreen
              ? _buildFullScreenPlayer(videoProvider)
              : _buildNormalPlayer(videoProvider);
        },
      ),
    );
  }

  Widget _buildErrorState(VideoProvider videoProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
            const SizedBox(height: 24),
            _buildErrorActions(videoProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorActions(VideoProvider videoProvider) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => videoProvider.initializeVideo(widget.video),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => videoProvider.openInYouTubeApp(),
                icon: const Icon(Icons.open_in_new),
                label: const Text('YouTube App'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => videoProvider.openInBrowser(),
                icon: const Icon(Icons.web),
                label: const Text('Browser'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
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
              'Loading video...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              widget.video.title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenPlayer(VideoProvider videoProvider) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          _buildVideoPlayer(videoProvider),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
              onPressed: () {
                videoProvider.exitFullScreen();
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
              },
            ),
          ),
        ],
      ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAppBar(),
          AspectRatio(
            aspectRatio: AppConstants.videoPlayerAspectRatio,
            child: _buildVideoPlayer(videoProvider),
          ),
          _buildPlayerControls(videoProvider),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(VideoProvider videoProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // YouTube thumbnail as background
            if (widget.video.youtubeThumbnailUrl.isNotEmpty)
              Image.network(
                widget.video.youtubeThumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade800,
                  child: const Icon(
                    Icons.video_library,
                    color: Colors.white54,
                    size: 64,
                  ),
                ),
              ),
            // Play overlay
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 48,
                  ),
                  onPressed: () => _showVideoOptions(videoProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoOptions(VideoProvider videoProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Watch Video',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.video.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            _buildVideoOptionButton(
              icon: Icons.play_circle_filled,
              title: 'Open in YouTube App',
              subtitle: 'Best experience with full controls',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                videoProvider.openInYouTubeApp();
              },
            ),
            const SizedBox(height: 12),
            _buildVideoOptionButton(
              icon: Icons.web,
              title: 'Open in Browser',
              subtitle: 'Watch in your default browser',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                videoProvider.openInBrowser();
              },
            ),
            const SizedBox(height: 12),
            _buildVideoOptionButton(
              icon: Icons.link,
              title: 'Copy Link',
              subtitle: 'Share or save the video URL',
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                _copyVideoLink();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoOptionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _copyVideoLink() {
    Clipboard.setData(ClipboardData(text: widget.video.youtubeUrl));
    AppHelpers.showSuccessSnackBar(context, 'Video link copied to clipboard!');
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

          // Play Button (opens options)
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
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => _showVideoOptions(videoProvider),
              tooltip: 'Play Video',
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

          // Video Duration Info
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
                  widget.video.formattedDuration,
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            _buildVideoInfo(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 16),
            _buildVideoDescription(),
            const SizedBox(height: 16),
            _buildNextVideoSection(),
            const SizedBox(height: 16),
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
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
                        isCompleted ? 'Completed' : 'Ready to Watch',
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
                        AppHelpers.showSuccessSnackBar(context, 'Video marked as completed! 🎉');
                      }
                    },
                    icon: Icon(isCompleted ? Icons.replay : Icons.check),
                    label: Text(isCompleted ? 'Mark as Not Completed' : 'Mark as Completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<VideoProvider>().openInYouTubeApp(),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('YouTube App'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyVideoLink(),
                    icon: const Icon(Icons.share),
                    label: const Text('Copy Link'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryPurple,
                      side: BorderSide(color: AppTheme.primaryPurple),
                    ),
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
}
