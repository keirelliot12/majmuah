class MaterialModel {
  final String id;
  final String title;
  final String arabicTitle;
  final String category;
  final List<String> tags;
  final List<String> content;

  /// Optional translation of the material
  final String? translation;

  /// Timestamp when this material was last opened
  final DateTime? lastRead;

  /// Whether this material is bookmarked
  final bool isBookmarked;

  MaterialModel({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.category,
    required this.tags,
    required this.content,
    this.translation,
    this.lastRead,
    this.isBookmarked = false,
  });

  /// Create a copy with modifications
  MaterialModel copyWith({
    String? id,
    String? title,
    String? arabicTitle,
    String? category,
    List<String>? tags,
    List<String>? content,
    String? translation,
    DateTime? lastRead,
    bool? isBookmarked,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      title: title ?? this.title,
      arabicTitle: arabicTitle ?? this.arabicTitle,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      translation: translation ?? this.translation,
      lastRead: lastRead ?? this.lastRead,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  /// Get preview of content (first 100 characters)
  String getContentPreview() {
    if (content.isEmpty) return '';
    final combined = content.join(' ');
    return combined.length > 100
        ? '${combined.substring(0, 100)}...'
        : combined;
  }

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      arabicTitle: json['arabic_title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      content: (json['content'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'arabic_title': arabicTitle,
        'category': category,
        'tags': tags,
        'content': content,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          arabicTitle == other.arabicTitle &&
          category == other.category &&
          content == other.content;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      arabicTitle.hashCode ^
      category.hashCode ^
      content.hashCode;
}
