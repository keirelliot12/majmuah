class MaterialItem {
  final String id;
  final String title;
  final String? arabicTitle;
  final List<String> content;
  final String category;
  final List<String> tags;

  MaterialItem({
    required this.id,
    required this.title,
    this.arabicTitle,
    required this.content,
    required this.category,
    required this.tags,
  });

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      id: json['id'] as String,
      title: json['title'] as String,
      arabicTitle: json['arabic_title'] as String?,
      content: (json['content'] as List<dynamic>).map((e) => e.toString()).toList(),
      category: json['category'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabic_title': arabicTitle,
      'content': content,
      'category': category,
      'tags': tags,
    };
  }

  String get contentText => content.join('\n\n');
}
