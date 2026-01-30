import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/material/material_category.dart';
import '../../domain/models/material/material_item.dart';

class MaterialRepository {
  static final MaterialRepository _instance = MaterialRepository._internal();
  factory MaterialRepository() => _instance;
  MaterialRepository._internal();

  List<MaterialCategory>? _categories;
  List<MaterialItem>? _materials;

  Future<List<MaterialCategory>> getCategories() async {
    if (_categories != null) {
      return _categories!;
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/json/category.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> categoriesJson = jsonData['categories'] as List<dynamic>;
      _categories = categoriesJson.map((json) => MaterialCategory.fromJson(json)).toList();
      return _categories!;
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }

  Future<List<MaterialItem>> getMaterials() async {
    if (_materials != null) {
      return _materials!;
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/json/Annibros.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      _materials = jsonData.map((json) => MaterialItem.fromJson(json)).toList();
      return _materials!;
    } catch (e) {
      print('Error loading materials: $e');
      return [];
    }
  }

  Future<List<MaterialItem>> getMaterialsByCategory(String categoryName) async {
    final materials = await getMaterials();
    return materials.where((material) => material.category.toLowerCase() == categoryName.toLowerCase()).toList();
  }

  Future<List<MaterialItem>> getMaterialsByCategoryFilterKey(String filterKey) async {
    final materials = await getMaterials();
    return materials.where((material) => material.category.toLowerCase() == filterKey.toLowerCase()).toList();
  }

  Future<MaterialItem?> getMaterialById(String id) async {
    final materials = await getMaterials();
    try {
      return materials.firstWhere((material) => material.id == id);
    } catch (e) {
      return null;
    }
  }

  MaterialCategory? getCategoryByFilterKey(String filterKey) {
    if (_categories == null) return null;
    try {
      return _categories!.firstWhere((category) => category.filterKey.toLowerCase() == filterKey.toLowerCase());
    } catch (e) {
      return null;
    }
  }
}
