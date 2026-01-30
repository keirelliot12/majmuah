import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../domain/models/category/category_model.dart';

/// Data source untuk memuat kategori dari category.json
class CategoryDataSource {
  /// Load semua kategori dari assets/json/category.json
  Future<List<CategoryModel>> loadCategories() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/json/category.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final categoriesList = json['categories'] as List<dynamic>;

      return categoriesList
          .map((category) =>
              CategoryModel.fromJson(category as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
