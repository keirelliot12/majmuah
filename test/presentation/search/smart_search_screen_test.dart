import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic/app/utils/app_prefs.dart';
import 'package:islamic/data/data_source/local/notes_local_data_source.dart';
import 'package:islamic/data/data_source/remote/material_data_source.dart';
import 'package:islamic/data/repository/material_content_repository.dart';
import 'package:islamic/di/di.dart';
import 'package:islamic/domain/models/material/material_model.dart';
import 'package:islamic/presentation/home/cubit/beranda_material_cubit.dart';
import 'package:islamic/presentation/search/smart_search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;
  late _SearchMaterialRepository repository;
  late BerandaMaterialCubit cubit;

  final material = MaterialModel(
    id: 'doa_fajar',
    title: 'Doa Fajar',
    arabicTitle: 'دعاء الفجر',
    category: "Aurad & Doa'",
    tags: const ['doa'],
    content: const ['Bacaan doa setelah fajar'],
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();

    await instance.reset();
    instance.registerLazySingleton<SharedPreferences>(() => preferences);
    instance.registerLazySingleton<AppPreferences>(() => AppPreferences());

    repository = _SearchMaterialRepository(preferences, [material]);
    cubit = BerandaMaterialCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await instance.reset();
  });

  Widget buildSubject() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) => MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const SmartSearchScreen(),
        ),
      ),
    );
  }

  testWidgets('shows material results after typing a search query', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    await tester.enterText(find.byType(TextField), 'fajar');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    expect(repository.queries, contains('fajar'));
    expect(find.text('Doa Fajar'), findsOneWidget);
  });

  testWidgets('returns to the empty search state for whitespace-only query', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    await tester.enterText(find.byType(TextField), 'fajar');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
    expect(find.text('Doa Fajar'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    expect(repository.queries, isNot(contains('   ')));
    expect(find.text('Doa Fajar'), findsNothing);
    expect(find.text('Mulai cari bimbingan spiritualmu'), findsOneWidget);
  });
}

class _SearchMaterialRepository extends MaterialContentRepository {
  _SearchMaterialRepository(SharedPreferences preferences, this.materials)
    : super(MaterialDataSource(), NotesLocalDataSource(preferences));

  final List<MaterialModel> materials;
  final List<String> queries = [];

  @override
  Future<List<MaterialModel>> searchMaterials(String query) async {
    queries.add(query);
    final normalizedQuery = query.toLowerCase();

    return materials
        .where(
          (material) =>
              material.title.toLowerCase().contains(normalizedQuery) ||
              material.category.toLowerCase().contains(normalizedQuery) ||
              material.arabicTitle.contains(query) ||
              material.content.any(
                (content) => content.toLowerCase().contains(normalizedQuery),
              ),
        )
        .toList();
  }
}
