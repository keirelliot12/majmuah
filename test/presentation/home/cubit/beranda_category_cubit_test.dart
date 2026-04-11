import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic/presentation/home/cubit/beranda_category_cubit.dart';
import 'package:islamic/data/repository/category_repository.dart';
import 'package:islamic/domain/models/category/category_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'beranda_category_cubit_test.mocks.dart';

@GenerateMocks([CategoryRepository])
void main() {
  late MockCategoryRepository mockRepository;
  late BerandaCategoryCubit cubit;

  setUp(() {
    mockRepository = MockCategoryRepository();
    cubit = BerandaCategoryCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  final tCategories = [
    CategoryModel(
      id: 1,
      title: 'Test',
      iconAsset: 'test.png',
      route: '/test',
      filterKey: 'test',
    )
  ];

  group('BerandaCategoryCubit', () {
    test('initial state should be BerandaCategoryInitial', () {
      expect(cubit.state, const BerandaCategoryInitial());
    });

    blocTest<BerandaCategoryCubit, BerandaCategoryState>(
      'emits [Loading, Loaded] when loadCategories is successful',
      build: () {
        when(mockRepository.getAllCategories())
            .thenAnswer((_) async => tCategories);
        return cubit;
      },
      act: (cubit) => cubit.loadCategories(),
      expect: () => [
        const BerandaCategoryLoading(),
        BerandaCategoryLoaded(tCategories),
      ],
    );

    blocTest<BerandaCategoryCubit, BerandaCategoryState>(
      'emits [Loading, Error] when loadCategories fails',
      build: () {
        when(mockRepository.getAllCategories())
            .thenThrow(Exception('Failed to load'));
        return cubit;
      },
      act: (cubit) => cubit.loadCategories(),
      expect: () => [
        const BerandaCategoryLoading(),
        const BerandaCategoryError('Exception: Failed to load'),
      ],
    );

    blocTest<BerandaCategoryCubit, BerandaCategoryState>(
      'emits [Loading, Loaded] when searchCategories is successful',
      build: () {
        when(mockRepository.searchCategories('test'))
            .thenAnswer((_) async => tCategories);
        return cubit;
      },
      act: (cubit) => cubit.searchCategories('test'),
      expect: () => [
        const BerandaCategoryLoading(),
        BerandaCategoryLoaded(tCategories),
      ],
    );
  });
}
