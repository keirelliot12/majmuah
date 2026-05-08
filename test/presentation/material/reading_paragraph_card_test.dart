import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic/presentation/material/widgets/reading_paragraph_card.dart';

void main() {
  const arabicText = 'اللهم صل على سيدنا محمد';
  const indonesianText = 'Bacaan doa setelah fajar.';

  Widget buildSubject({
    String text = arabicText,
    double fontScale = 1.0,
  }) {
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

  testWidgets('renders Arabic text right-to-left', (tester) async {
    await tester.pumpWidget(buildSubject());

    final text = tester.widget<Text>(find.text(arabicText));

    expect(text.textDirection, TextDirection.rtl);
    expect(text.textAlign, TextAlign.right);
  });

  testWidgets('applies selected Arabic font scale', (tester) async {
    await tester.pumpWidget(buildSubject(fontScale: 1.25));

    final text = tester.widget<Text>(find.text(arabicText));

    expect(text.style?.fontSize, closeTo(25, 0.1));
  });

  testWidgets('does not force non-Arabic paragraphs to RTL styling',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(
        text: indonesianText,
        fontScale: 1.25,
      ),
    );

    final text = tester.widget<Text>(find.text(indonesianText));

    expect(text.textDirection, isNull);
    expect(text.textAlign, TextAlign.start);
    expect(text.style?.fontFamily, isNot('UthmanTN'));
    expect(text.style?.fontSize, closeTo(16, 0.1));
  });
}
