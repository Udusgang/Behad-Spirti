class Course {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String categoryId;
  final List<String> videoIds;
  final int estimatedDuration; // in minutes
  final String difficulty; // beginner, intermediate, advanced
  final List<String> tags;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.categoryId,
    required this.videoIds,
    required this.estimatedDuration,
    required this.difficulty,
    required this.tags,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      categoryId: json['categoryId'] as String,
      videoIds: List<String>.from(json['videoIds'] as List),
      estimatedDuration: json['estimatedDuration'] as int,
      difficulty: json['difficulty'] as String,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'categoryId': categoryId,
      'videoIds': videoIds,
      'estimatedDuration': estimatedDuration,
      'difficulty': difficulty,
      'tags': tags,
    };
  }

  // Helper getters
  int get videoCount => videoIds.length;
  
  String get formattedDuration {
    if (estimatedDuration < 60) {
      return '${estimatedDuration}m';
    } else {
      final hours = estimatedDuration ~/ 60;
      final minutes = estimatedDuration % 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Course(id: $id, title: $title, videoCount: $videoCount)';
  }
}
