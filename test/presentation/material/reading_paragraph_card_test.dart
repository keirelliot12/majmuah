import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic/presentation/material/widgets/reading_paragraph_card.dart';

void main() {
  const arabicText =
      '\u0627\u0644\u0644\u0647\u0645 \u0635\u0644 \u0639\u0644\u0649 \u0633\u064a\u062f\u0646\u0627 \u0645\u062d\u0645\u062f';
  const indonesianText = 'Bacaan doa setelah fajar.';

  Widget buildSubject({String text = arabicText, double fontScale = 1.0}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: ReadingParagraphCard(
            text: text,
            categoryColor: Colors.teal,
            fontScale: fontScale,
          ),
        ),
      ),
    );
  }

  testWidgets('renders Arabic text in an RTL paragraph', (tester) async {
    await tester.pumpWidget(buildSubject());

    final textFinder = find.text(arabicText);
    final text = tester.widget<Text>(textFinder);

    expect(Directionality.of(tester.element(textFinder)), TextDirection.rtl);
    expect(text.textDirection, isNull);
    expect(text.textAlign, TextAlign.justify);
    expect(text.style?.fontFamily, 'UthmanTN');
  });

  testWidgets('applies selected Arabic font scale', (tester) async {
    await tester.pumpWidget(buildSubject(fontScale: 1.25));

    final text = tester.widget<Text>(find.text(arabicText));

    expect(text.style?.fontSize, closeTo(21.sp * 1.25, 0.1));
  });

  testWidgets('renders non-Arabic paragraphs as justified LTR content', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(text: indonesianText, fontScale: 1.25),
    );

    final textFinder = find.text(indonesianText);
    final text = tester.widget<Text>(textFinder);

    expect(Directionality.of(tester.element(textFinder)), TextDirection.ltr);
    expect(text.textDirection, isNull);
    expect(text.textAlign, TextAlign.justify);
    expect(text.style?.fontFamily, isNot('UthmanTN'));
    expect(text.style?.fontSize, closeTo(16.sp, 0.1));
  });
}
