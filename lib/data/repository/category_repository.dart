import '../../domain/models/category/category_model.dart';
import '../data_source/remote/category_data_source.dart';

/// Repository untuk mengelola category data
class CategoryRepository {
  final CategoryDataSource _dataSource;

  /// In-memory cache untuk kategori
  List<CategoryModel>? _cachedCategories;

  CategoryRepository(this._dataSource);

  /// Get semua kategori
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      // Return dari cache jika ada
      if (_cachedCategories != null) {
        return _cachedCategories!;
      }

      // Load dari data source dan cache
      final categories = await _dataSource.loadCategories();
      _cachedCategories = categories;
      return categories;
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  /// Get kategori by id
  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      final categories = await getAllCategories();
      try {
        return categories.firstWhere((cat) => cat.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get category: $e');
    }
  }

  /// Get kategori by filter key
  Future<CategoryModel?> getCategoryByFilterKey(String filterKey) async {
    try {
      final categories = await getAllCategories();
      try {
        return categories.firstWhere((cat) =>
            cat.filterKey.toLowerCase() == filterKey.toLowerCase());
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get category by filter key: $e');
    }
  }

  /// Search kategori
  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      final categories = await getAllCategories();
      final lowerQuery = query.toLowerCase();
      return categories
          .where((cat) => cat.title.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      throw Exception('Failed to search categories: $e');
    }
  }

  /// Clear cache
  void clearCache() {
    _cachedCategories = null;
  }
}

