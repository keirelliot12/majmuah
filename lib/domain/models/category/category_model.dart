import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final int id;
  final String title;
  @JsonKey(name: 'icon_asset')
  final String iconAsset;
  final String route;
  @JsonKey(name: 'filter_key')
  final String filterKey;
  
  /// Optional accent color for the icon
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Color? iconColor;
  
  /// Total items in this category
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

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
