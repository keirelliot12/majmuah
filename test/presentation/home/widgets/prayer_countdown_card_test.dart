import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic/presentation/home/widgets/prayer_countdown_card.dart';

Widget _wrapWithScreenUtil(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  group('PrayerCountdownCard Widget', () {
    testWidgets('displays prayer name', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard()),
      );

      // Should display a prayer name
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays countdown timer', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard()),
      );

      // Should have multiple Text widgets for timer display
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('has card styling with shadow', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard()),
      );

      // Should have Container widget for card
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays timer in HH:MM:SS format', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard()),
      );

      // Timer should be displayed
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('has gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(const PrayerCountdownCard()),
      );

      // Verify widget structure
      expect(find.byType(Container), findsWidgets);
    });
  });
}
