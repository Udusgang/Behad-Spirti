class Category {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final String color; // Hex color string
  final List<String> courseIds;
  final int order;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.color,
    required this.courseIds,
    this.order = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      color: json['color'] as String,
      courseIds: List<String>.from(json['courseIds'] as List? ?? []),
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'color': color,
      'courseIds': courseIds,
      'order': order,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description)';
  }
}
