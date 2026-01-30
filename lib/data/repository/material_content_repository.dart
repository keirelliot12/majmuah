import '../../domain/models/material/material_model.dart';
import '../data_source/local/notes_local_data_source.dart';
import '../data_source/remote/material_data_source.dart';

/// Repository untuk mengelola material content data
class MaterialContentRepository {
  final MaterialDataSource _dataSource;
  final NotesLocalDataSource _localDataSource;

  /// In-memory cache untuk semua materials
  List<MaterialModel>? _cachedMaterials;

  MaterialContentRepository(this._dataSource, this._localDataSource);

  /// Get materials by category
  Future<List<MaterialModel>> getMaterialsByCategory(String category) async {
    try {
      final allMaterials = await _dataSource.getMaterialsByCategory(category);
      return allMaterials;
    } catch (e) {
      throw Exception('Failed to get materials by category: $e');
    }
  }

  /// Get material by id
  Future<MaterialModel?> getMaterialById(String id) async {
    try {
      // Check cache first
      if (_cachedMaterials != null) {
        try {
          return _cachedMaterials!.firstWhere((m) => m.id == id);
        } catch (e) {
          return null;
        }
      }

      return await _dataSource.getMaterialById(id);
    } catch (e) {
      throw Exception('Failed to get material: $e');
    }
  }

  /// Search materials
  Future<List<MaterialModel>> searchMaterials(String query) async {
    try {
      final allMaterials = _cachedMaterials ?? await _loadAllMaterials();
      final lowerQuery = query.toLowerCase();

      return allMaterials
          .where((material) =>
              material.title.toLowerCase().contains(lowerQuery) ||
              material.arabicTitle.contains(query) ||
              material.tags.any((tag) =>
                  tag.toLowerCase().contains(lowerQuery)) ||
              material.content.any((content) =>
                  content.toLowerCase().contains(lowerQuery)))
          .toList();
    } catch (e) {
      throw Exception('Failed to search materials: $e');
    }
  }

  /// Update last read material
  Future<void> updateLastRead(String materialId) async {
    try {
      await _localDataSource.saveLastReadMaterial(materialId);
    } catch (e) {
      throw Exception('Failed to update last read: $e');
    }
  }

  /// Toggle bookmark
  Future<void> toggleBookmark(String materialId) async {
    try {
      await _localDataSource.toggleBookmark(materialId);
    } catch (e) {
      throw Exception('Failed to toggle bookmark: $e');
    }
  }

  /// Get bookmarked materials
  Future<List<MaterialModel>> getBookmarkedMaterials() async {
    try {
      final bookmarkedIds = await _localDataSource.getBookmarkedMaterials();
      final allMaterials = _cachedMaterials ?? await _loadAllMaterials();

      return allMaterials
          .where((material) => bookmarkedIds.contains(material.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get bookmarked materials: $e');
    }
  }

  /// Get last read material
  Future<MaterialModel?> getLastReadMaterial() async {
    try {
      final materialId = await _localDataSource.getLastReadMaterial();
      if (materialId == null) return null;

      return await getMaterialById(materialId);
    } catch (e) {
      throw Exception('Failed to get last read material: $e');
    }
  }

  /// Check if material is bookmarked
  Future<bool> isBookmarked(String materialId) async {
    try {
      final bookmarked = await _localDataSource.getBookmarkedMaterials();
      return bookmarked.contains(materialId);
    } catch (e) {
      throw Exception('Failed to check bookmark: $e');
    }
  }

  /// Clear cache
  void clearCache() {
    _cachedMaterials = null;
  }

  /// Load all materials (private helper)
  Future<List<MaterialModel>> _loadAllMaterials() async {
    // Note: Since Annibros.json is large, we might want to implement pagination
    // For now, we load and cache all
    _cachedMaterials = await _dataSource.loadMaterials();
    return _cachedMaterials!;
  }
}

