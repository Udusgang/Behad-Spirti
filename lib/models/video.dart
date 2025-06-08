import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id;
  final String youtubeId;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String courseId;
  final int duration; // in seconds
  final int orderIndex;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Video({
    required this.id,
    required this.youtubeId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.courseId,
    required this.duration,
    required this.orderIndex,
    required this.tags,
    this.createdAt,
    this.updatedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      youtubeId: json['youtubeId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      courseId: json['courseId'] as String,
      duration: json['duration'] as int? ?? 0,
      orderIndex: json['orderIndex'] as int? ?? 0,
      tags: List<String>.from(json['tags'] as List? ?? []),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'youtubeId': youtubeId,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'courseId': courseId,
      'duration': duration,
      'orderIndex': orderIndex,
      'tags': tags,
    };
  }

  // Helper getters
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get youtubeUrl => '  ';
  
  String get youtubeThumbnailUrl => 'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Video && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Video(id: $id, title: $title, duration: $formattedDuration)';
  }
}
