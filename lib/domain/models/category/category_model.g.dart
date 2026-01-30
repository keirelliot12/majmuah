// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      iconAsset: json['icon_asset'] as String,
      route: json['route'] as String,
      filterKey: json['filter_key'] as String,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon_asset': instance.iconAsset,
      'route': instance.route,
      'filter_key': instance.filterKey,
    };
