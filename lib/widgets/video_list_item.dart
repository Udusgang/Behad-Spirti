import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'progress_indicator_widget.dart';

class VideoListItem extends StatelessWidget {
  final Video video;
  final int index;
  final VoidCallback onTap;

  const VideoListItem({
    super.key,
    required this.video,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        final videoProgress = progressProvider.getVideoProgress(video.id);
        final isCompleted = progressProvider.isVideoCompleted(video.id);
        final progressPercentage = progressProvider.getVideoProgressPercentage(
          video.id,
          video.duration,
        );

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              border: Border.all(
                color: isCompleted ? Colors.green.withOpacity(0.3) : AppTheme.lightGray,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildVideoNumber(isCompleted),
                const SizedBox(width: 12),
                _buildThumbnail(),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVideoInfo(context, progressPercentage, videoProgress),
                ),
                _buildPlayButton(isCompleted),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoNumber(bool isCompleted) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green : AppTheme.primaryPurple,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              )
            : Text(
                index.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 60,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.lightGray,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              video.youtubeThumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppTheme.lightGray,
                child: const Icon(
                  Icons.play_arrow,
                  color: AppTheme.mediumGray,
                  size: 24,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo(BuildContext context, double progressPercentage, VideoProgress? videoProgress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          video.title,
          style: AppTheme.videoTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              video.formattedDuration,
              style: AppTheme.videoDuration,
            ),
            if (videoProgress != null) ...[
              const SizedBox(width: 8),
              Text(
                '• Last watched ${AppHelpers.formatTimeAgo(videoProgress.lastWatchedAt)}',
                style: AppTheme.videoDuration,
              ),
            ],
          ],
        ),
        if (progressPercentage > 0) ...[
          const SizedBox(height: 8),
          ProgressIndicatorWidget(
            progress: progressPercentage,
            height: 3,
          ),
        ],
      ],
    );
  }

  Widget _buildPlayButton(bool isCompleted) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.withOpacity(0.1) : AppTheme.primaryPurple.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isCompleted ? Icons.replay : Icons.play_arrow,
        color: isCompleted ? Colors.green : AppTheme.primaryPurple,
        size: 20,
      ),
    );
  }
}
