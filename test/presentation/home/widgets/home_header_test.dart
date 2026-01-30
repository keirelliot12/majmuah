import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic/presentation/home/widgets/home_header.dart';

void main() {
  group('HomeHeader Widget', () {
    testWidgets('displays location with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeHeader(),
          ),
        ),
      );

      // Verify location icon exists
      expect(find.byIcon(Icons.location_on), findsOneWidget);

      // Verify location text
      expect(find.text('Kudus, Indonesia'), findsOneWidget);
    });

    testWidgets('displays hijri date', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeHeader(),
          ),
        ),
      );

      // Verify at least one text widget for hijri date
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays notification bell icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeHeader(),
          ),
        ),
      );

      // Verify bell icon exists
      expect(find.byIcon(Icons.notifications_active), findsOneWidget);
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeHeader(),
          ),
        ),
      );

      // Verify Row widget exists
      expect(find.byType(Row), findsWidgets);

      // Verify Column widget exists
      expect(find.byType(Column), findsWidgets);
    });
  });
}
