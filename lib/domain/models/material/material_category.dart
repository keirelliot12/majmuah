class MaterialCategory {
  final int id;
  final String title;
  final String iconAsset;
  final String route;
  final String filterKey;

  MaterialCategory({
    required this.id,
    required this.title,
    required this.iconAsset,
    required this.route,
    required this.filterKey,
  });

  factory MaterialCategory.fromJson(Map<String, dynamic> json) {
    return MaterialCategory(
      id: json['id'] as int,
      title: json['title'] as String,
      iconAsset: json['icon_asset'] as String? ?? '',
      route: json['route'] as String? ?? '',
      filterKey: json['filter_key'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon_asset': iconAsset,
      'route': route,
      'filter_key': filterKey,
    };
  }
}
