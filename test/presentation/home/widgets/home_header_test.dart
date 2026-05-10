import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic/app/utils/constants.dart';
import 'package:islamic/domain/models/prayer_timings/prayer_timings_model.dart';
import 'package:islamic/presentation/components/app_brand_logo.dart';
import 'package:islamic/presentation/home/cubit/home_cubit.dart';
import 'package:islamic/presentation/home/screens/prayer_times/cubit/prayer_timings_cubit.dart';
import 'package:islamic/presentation/home/widgets/home_header.dart';
import 'package:material_symbols_icons/symbols.dart';

Widget _wrapWithScreenUtil({
  required Widget child,
  required HomeCubit homeCubit,
  required PrayerTimingsCubit prayerCubit,
}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>.value(value: homeCubit),
            BlocProvider<PrayerTimingsCubit>.value(value: prayerCubit),
          ],
          child: child,
        ),
      ),
    ),
  );
}

Future<void> _pumpSubject(
  WidgetTester tester, {
  required HomeCubit homeCubit,
  required PrayerTimingsCubit prayerCubit,
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    _wrapWithScreenUtil(
      child: const HomeHeader(),
      homeCubit: homeCubit,
      prayerCubit: prayerCubit,
    ),
  );
}

void main() {
  group('HomeHeader Widget', () {
    late _FakeHomeCubit homeCubit;
    late _FakePrayerTimingsCubit prayerCubit;

    setUp(() {
      recordLocation = ("Gresik", "Indonesia");
      homeCubit = _FakeHomeCubit();
      prayerCubit = _FakePrayerTimingsCubit();
    });

    tearDown(() async {
      await homeCubit.close();
      await prayerCubit.close();
    });

    testWidgets('displays location with icon', (WidgetTester tester) async {
      await _pumpSubject(
        tester,
        homeCubit: homeCubit,
        prayerCubit: prayerCubit,
      );

      expect(find.byIcon(Symbols.location_on), findsOneWidget);
      expect(find.text('GRESIK, INDONESIA'), findsOneWidget);
    });

    testWidgets('displays hijri loading text and gregorian date', (
      WidgetTester tester,
    ) async {
      await _pumpSubject(
        tester,
        homeCubit: homeCubit,
        prayerCubit: prayerCubit,
      );

      expect(find.text('Kalender Hijriyah memuat...'), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays brand logo', (WidgetTester tester) async {
      await _pumpSubject(
        tester,
        homeCubit: homeCubit,
        prayerCubit: prayerCubit,
      );

      expect(find.byType(AppBrandLogo), findsOneWidget);
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      await _pumpSubject(
        tester,
        homeCubit: homeCubit,
        prayerCubit: prayerCubit,
      );

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });
  });
}

class _FakeHomeCubit extends Cubit<HomeState> implements HomeCubit {
  _FakeHomeCubit() : super(HomeInitial());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePrayerTimingsCubit extends Cubit<PrayerTimingsState>
    implements PrayerTimingsCubit {
  _FakePrayerTimingsCubit() : super(PrayerTimesInitialState());

  @override
  PrayerTimingsModel prayerTimingsModel = const PrayerTimingsModel(
    code: 0,
    status: '',
    data: null,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
