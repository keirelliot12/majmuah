import 'package:flutter_test/flutter_test.dart';
import 'package:islamic/data/data_source/remote/category_data_source.dart';
import 'package:islamic/data/repository/category_repository.dart';
import 'package:islamic/domain/models/category/category_model.dart';

void main() {
  group('CategoryRepository Tests', () {
    late CategoryRepository repository;
    late CategoryDataSource dataSource;

    setUp(() {
      dataSource = CategoryDataSource();
      repository = CategoryRepository(dataSource);
    });

    test('should load all categories from JSON', () async {
      // Act
      final categories = await repository.getAllCategories();

      // Assert
      expect(categories, isNotEmpty);
      expect(categories.length, greaterThan(0));
      expect(categories.first, isA<CategoryModel>());
    });

    test('should get category by id', () async {
      // Arrange
      final allCategories = await repository.getAllCategories();
      final firstId = allCategories.first.id;

      // Act
      final category = await repository.getCategoryById(firstId);

      // Assert
      expect(category, isNotNull);
      expect(category!.id, equals(firstId));
    });

    test('should return null for non-existent category id', () async {
      // Act
      final category = await repository.getCategoryById(99999);

      // Assert
      expect(category, isNull);
    });

    test('should get category by filter key', () async {
      // Arrange
      final allCategories = await repository.getAllCategories();
      final firstFilterKey = allCategories.first.filterKey;

      // Act
      final category = await repository.getCategoryByFilterKey(firstFilterKey);

      // Assert
      expect(category, isNotNull);
      expect(category!.filterKey, equals(firstFilterKey));
    });

    test('should search categories case-insensitive', () async {
      // Act
      final results = await repository.searchCategories('aurad');

      // Assert
      expect(results, isNotEmpty);
      expect(
        results.any((cat) => cat.title.toLowerCase().contains('aurad')),
        isTrue,
      );
    });

    test('should cache categories after first load', () async {
      // Act
      final firstLoad = await repository.getAllCategories();
      final secondLoad = await repository.getAllCategories();

      // Assert - both should return same instance (cached)
      expect(identical(firstLoad, secondLoad), isTrue);
    });

    test('should clear cache when requested', () async {
      // Arrange
      await repository.getAllCategories();

      // Act
      repository.clearCache();

      // Assert - next call should load fresh data
      final categories = await repository.getAllCategories();
      expect(categories, isNotEmpty);
    });
  });
}
