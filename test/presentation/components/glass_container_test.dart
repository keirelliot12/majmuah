import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic/presentation/components/glass_container.dart';
import 'dart:ui';

void main() {
  testWidgets('GlassContainer should render with BackdropFilter and child', (WidgetTester tester) async {
    const childText = 'Hello Glass';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlassContainer(
            child: Text(childText),
          ),
        ),
      ),
    );

    // Verify child is present
    expect(find.text(childText), findsOneWidget);

    // Find BackdropFilter
    final backdropFilterFinder = find.byType(BackdropFilter);
    expect(backdropFilterFinder, findsOneWidget);

    // Find Container with decoration
    final containerFinder = find.byType(Container);
    expect(containerFinder, findsWidgets);
  });
}
