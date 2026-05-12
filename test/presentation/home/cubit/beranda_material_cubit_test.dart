import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:annibros/presentation/home/cubit/beranda_material_cubit.dart';
import 'package:annibros/presentation/home/cubit/beranda_material_state.dart';
import 'package:annibros/data/repository/material_content_repository.dart';
import 'package:annibros/domain/models/material/material_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'beranda_material_cubit_test.mocks.dart';

@GenerateMocks([MaterialContentRepository])
void main() {
  late MockMaterialContentRepository mockRepository;
  late BerandaMaterialCubit cubit;

  setUp(() {
    mockRepository = MockMaterialContentRepository();
    cubit = BerandaMaterialCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  final tMaterial = MaterialModel(
    id: '1',
    title: 'Test Material',
    arabicTitle: 'العربية',
    category: 'Test',
    tags: ['tag'],
    content: ['content'],
  );

  group('BerandaMaterialCubit', () {
    test('initial state should be BerandaMaterialInitial', () {
      expect(cubit.state, const BerandaMaterialInitial());
    });

    blocTest<BerandaMaterialCubit, BerandaMaterialState>(
      'emits [Loading, Loaded] when loadMaterialsByCategory is successful',
      build: () {
        when(mockRepository.getMaterialsByCategory('Test'))
            .thenAnswer((_) async => [tMaterial]);
        return cubit;
      },
      act: (cubit) => cubit.loadMaterialsByCategory('Test'),
      expect: () => [
        const BerandaMaterialLoading(),
        BerandaMaterialLoaded([tMaterial]),
      ],
    );

    blocTest<BerandaMaterialCubit, BerandaMaterialState>(
      'emits [LastReadLoaded] when getLastRead is successful',
      build: () {
        when(mockRepository.getLastReadMaterial())
            .thenAnswer((_) async => tMaterial);
        return cubit;
      },
      act: (cubit) => cubit.getLastRead(),
      expect: () => [
        BerandaLastReadLoaded(tMaterial),
      ],
    );

    blocTest<BerandaMaterialCubit, BerandaMaterialState>(
      'emits [Loading, Error] when loadMaterialsByCategory fails',
      build: () {
        when(mockRepository.getMaterialsByCategory('Test'))
            .thenThrow(Exception('Failed'));
        return cubit;
      },
      act: (cubit) => cubit.loadMaterialsByCategory('Test'),
      expect: () => [
        const BerandaMaterialLoading(),
        const BerandaMaterialError('Exception: Failed'),
      ],
    );
  });
}
