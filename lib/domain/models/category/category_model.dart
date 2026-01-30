import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String title;
  final String iconAsset;
  final String route;
  final String filterKey;
  
  /// Optional accent color for the icon
  final Color? iconColor;
  
  /// Total items in this category
  final int itemCount;

  CategoryModel({
    required this.id,
    required this.title,
    required this.iconAsset,
    required this.route,
    required this.filterKey,
    this.iconColor,
    this.itemCount = 0,
  });

  /// Create a copy with modifications
  CategoryModel copyWith({
    int? id,
    String? title,
    String? iconAsset,
    String? route,
    String? filterKey,
    Color? iconColor,
    int? itemCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      iconAsset: iconAsset ?? this.iconAsset,
      route: route ?? this.route,
      filterKey: filterKey ?? this.filterKey,
      iconColor: iconColor ?? this.iconColor,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      iconAsset: json['icon_asset'] as String? ?? '',
      route: json['route'] as String? ?? '',
      filterKey: json['filter_key'] as String? ?? '',
      iconColor: json['color_hex'] != null
          ? Color(int.parse('FF${json['color_hex']}', radix: 16))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'icon_asset': iconAsset,
        'route': route,
        'filter_key': filterKey,
        'color_hex': iconColor != null
            ? iconColor!.value.toRadixString(16).substring(2).toUpperCase()
            : null,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          iconAsset == other.iconAsset &&
          route == other.route &&
          filterKey == other.filterKey;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      iconAsset.hashCode ^
      route.hashCode ^
      filterKey.hashCode;
}
