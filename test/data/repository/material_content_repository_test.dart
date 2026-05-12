import 'package:flutter_test/flutter_test.dart';
import 'package:annibros/data/data_source/local/notes_local_data_source.dart';
import 'package:annibros/data/data_source/remote/material_data_source.dart';
import 'package:annibros/data/repository/material_content_repository.dart';
import 'package:annibros/domain/models/material/material_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('MaterialContentRepository Tests', () {
    late MaterialContentRepository repository;
    late MaterialDataSource dataSource;
    late NotesLocalDataSource localDataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      dataSource = MaterialDataSource();
      localDataSource = NotesLocalDataSource(prefs);
      repository = MaterialContentRepository(dataSource, localDataSource);
    });

    test('should load materials by category', () async {
      // Act
      final materials = await repository.getMaterialsByCategory("Aurad & Doa'");

      // Assert
      expect(materials, isNotEmpty);
      expect(materials.first, isA<MaterialModel>());
      expect(materials.first.category, equals("Aurad & Doa'"));
    });

    test('should get material by id', () async {
      // Arrange
      final materials = await repository.getMaterialsByCategory("Aurad & Doa'");
      final firstId = materials.first.id;

      // Act
      final material = await repository.getMaterialById(firstId);

      // Assert
      expect(material, isNotNull);
      expect(material!.id, equals(firstId));
    });

    test('should return null for non-existent material id', () async {
      // Act
      final material = await repository.getMaterialById('non_existent_id');

      // Assert
      expect(material, isNull);
    });

    test('should search materials across multiple fields', () async {
      // Act
      final results = await repository.searchMaterials('doa');

      // Assert
      expect(results, isNotEmpty);
    });

    test('should search materials by category and Arabic text', () async {
      // Arrange
      final searchRepository = MaterialContentRepository(
        _FakeMaterialDataSource([
          MaterialModel(
            id: 'panduan_wudhu',
            title: 'Wudhu',
            arabicTitle: '\u0627\u0644\u0648\u0636\u0648\u0621',
            category: 'Kaifiyah',
            tags: const ['bersuci'],
            content: const ['Tata cara bersuci'],
          ),
          MaterialModel(
            id: 'doa_fajar',
            title: 'Doa Fajar',
            arabicTitle:
                '\u062f\u0639\u0627\u0621 \u0627\u0644\u0641\u062c\u0631',
            category: "Aurad & Doa'",
            tags: const ['doa'],
            content: const ['Bacaan setelah fajar'],
          ),
        ]),
        localDataSource,
      );

      // Act
      final categoryResults = await searchRepository.searchMaterials('panduan');
      final arabicResults = await searchRepository.searchMaterials(
        '\u0627\u0644\u0641\u062c\u0631',
      );

      // Assert
      expect(
        categoryResults.map((material) => material.id),
        contains('panduan_wudhu'),
      );
      expect(
        arabicResults.map((material) => material.id),
        contains('doa_fajar'),
      );
    });

    test('should track last read material', () async {
      // Arrange
      const materialId = 'test_material_id';

      // Act
      await repository.updateLastRead(materialId);
      final lastRead = await localDataSource.getLastReadMaterial();

      // Assert
      expect(lastRead, equals(materialId));
    });

    test('should toggle bookmark on and off', () async {
      // Arrange
      const materialId = 'test_bookmark_id';

      // Act
      await repository.toggleBookmark(materialId);
      var isBookmarked = await repository.isBookmarked(materialId);
      expect(isBookmarked, isTrue);

      await repository.toggleBookmark(materialId);
      isBookmarked = await repository.isBookmarked(materialId);

      // Assert
      expect(isBookmarked, isFalse);
    });

    test('should get bookmarked materials', () async {
      // Arrange
      final materials = await repository.getMaterialsByCategory("Aurad & Doa'");
      if (materials.isNotEmpty) {
        await repository.toggleBookmark(materials.first.id);
      }

      // Act
      final bookmarked = await repository.getBookmarkedMaterials();

      // Assert
      expect(bookmarked, isNotEmpty);
    });
  });
}

class _FakeMaterialDataSource extends MaterialDataSource {
  _FakeMaterialDataSource(this.materials);

  final List<MaterialModel> materials;

  @override
  Future<List<MaterialModel>> loadMaterials() async => materials;
}
