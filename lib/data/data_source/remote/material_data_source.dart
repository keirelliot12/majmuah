import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../domain/models/material/material_model.dart';

/// Data source untuk memuat material content dari Annibros.json
class MaterialDataSource {
  /// Load semua material dari assets/json/Annibros.json
  Future<List<MaterialModel>> loadMaterials() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/json/Annibros.json');
      final jsonList = jsonDecode(jsonString) as List<dynamic>;

      return jsonList
          .map((material) =>
              MaterialModel.fromJson(material as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load materials: $e');
    }
  }

  /// Filter materials by category
  /// If category is empty, returns all materials
  Future<List<MaterialModel>> getMaterialsByCategory(
    String category,
  ) async {
    final allMaterials = await loadMaterials();

    // If category is empty, return all materials
    if (category.isEmpty) {
      return allMaterials;
    }

    return allMaterials
        .where((material) =>
            material.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Get material by id
  Future<MaterialModel?> getMaterialById(String id) async {
    final allMaterials = await loadMaterials();
    try {
      return allMaterials.firstWhere((material) => material.id == id);
    } catch (e) {
      return null;
    }
  }
}
