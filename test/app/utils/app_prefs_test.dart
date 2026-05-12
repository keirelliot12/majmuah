import 'package:flutter_test/flutter_test.dart';
import 'package:annibros/app/utils/app_prefs.dart';
import 'package:annibros/di/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await instance.reset();
    instance.registerLazySingleton<SharedPreferences>(() => preferences);
  });

  tearDown(() async {
    await instance.reset();
  });

  test('persists Arabic font scale', () async {
    final appPreferences = AppPreferences();

    expect(appPreferences.getArabicReadingFontScale(), 1.0);

    await appPreferences.setArabicReadingFontScale(1.25);

    expect(appPreferences.getArabicReadingFontScale(), 1.25);
  });

  test('clamps Arabic font scale to supported range', () async {
    final appPreferences = AppPreferences();

    await appPreferences.setArabicReadingFontScale(3);
    expect(appPreferences.getArabicReadingFontScale(), 1.4);

    await appPreferences.setArabicReadingFontScale(0.1);
    expect(appPreferences.getArabicReadingFontScale(), 0.8);
  });
}
