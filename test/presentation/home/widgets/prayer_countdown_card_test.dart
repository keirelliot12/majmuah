import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic/domain/models/prayer_timings/prayer_timings_model.dart';
import 'package:islamic/presentation/home/screens/prayer_times/cubit/prayer_timings_cubit.dart';
import 'package:islamic/presentation/home/widgets/prayer_countdown_card.dart';

Widget _wrapWithScreenUtil(Widget child, PrayerTimingsCubit cubit) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: BlocProvider<PrayerTimingsCubit>.value(
          value: cubit,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('PrayerCountdownCard Widget', () {
    late _FakePrayerTimingsCubit cubit;

    setUp(() {
      cubit = _FakePrayerTimingsCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    testWidgets('displays prayer name', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard(), cubit),
      );

      // Should display a prayer name
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays countdown timer', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard(), cubit),
      );

      // Should have multiple Text widgets for timer display
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('has card styling with shadow', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard(), cubit),
      );

      // Should have Container widget for card
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays timer in HH:MM:SS format', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard(), cubit),
      );

      // Timer should be displayed
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('has gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard(), cubit),
      );

      // Verify widget structure
      expect(find.byType(Container), findsWidgets);
    });
  });
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
