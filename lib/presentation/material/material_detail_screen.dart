import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../../app/utils/app_prefs.dart';
import '../../di/di.dart';
import '../../domain/models/material/material_model.dart';
import '../home/cubit/beranda_material_cubit.dart';
import 'widgets/reading_paragraph_card.dart';

class MaterialDetailScreen extends StatefulWidget {
  final MaterialModel material;
  final Color categoryColor;

  const MaterialDetailScreen({
    Key? key,
    required this.material,
    required this.categoryColor,
  }) : super(key: key);

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  final AppPreferences _preferences = instance<AppPreferences>();
  double _arabicFontScale = defaultArabicReadingFontScale;
  String _arabicFontFamily = defaultArabicReadingFontFamily;
  bool _readingNightMode = false;
  bool _showMaulidTranslation = true;

  static final RegExp _arabicTextPattern = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  );
  static final RegExp _badPlaceholderPattern = RegExp(r'^[\?\s]+$');

  @override
  void initState() {
    super.initState();
    _arabicFontScale = _preferences.getArabicReadingFontScale();
    _arabicFontFamily = _preferences.getArabicReadingFontFamily();
    _readingNightMode = _preferences.getReadingNightMode();
    _showMaulidTranslation = _preferences.getMaulidTranslationVisible();
    // Update last read when opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      instance<BerandaMaterialCubit>().setLastRead(widget.material.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _cleanUiText(widget.material.title, 'Materi');
    final arabicTitle = _cleanUiText(widget.material.arabicTitle, '');
    final hasArabicContent =
        arabicTitle.isNotEmpty ||
        widget.material.content.any((paragraph) => _hasArabicText(paragraph));
    final isMaulid = widget.material.category.toLowerCase() == 'maulid';
    final visibleContent = _visibleContent(
      widget.material.content,
      isMaulid: isMaulid,
    );

    return Scaffold(
      backgroundColor: _readingNightMode
          ? AppColors.deepEmerald
          : AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        backgroundColor: _readingNightMode
            ? AppColors.deepEmerald
            : AppColors.background,
        foregroundColor: _readingNightMode
            ? AppColors.surface
            : AppColors.deepEmerald,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Pengaturan baca',
            onPressed: () => _showReadingSettingsSheet(hasArabicContent),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: _readingNightMode
                    ? AppColors.surface.withAlpha(20)
                    : widget.categoryColor.withAlpha(24),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: _readingNightMode
                      ? AppColors.surface.withAlpha(42)
                      : widget.categoryColor.withAlpha(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (arabicTitle.isNotEmpty) ...[
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        arabicTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: _arabicFontFamily,
                          fontSize: 32.sp * _arabicFontScale,
                          color: _readingNightMode
                              ? AppColors.limeGold
                              : widget.categoryColor,
                          height: 1.55,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  Text(
                    title,
                    textAlign: arabicTitle.isNotEmpty
                        ? TextAlign.center
                        : TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.sp,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                      color: _readingNightMode
                          ? AppColors.surface
                          : AppColors.deepEmerald,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleContent.length,
                separatorBuilder: (context, index) => SizedBox(height: 18.h),
                itemBuilder: (context, index) {
                  final text = _cleanUiText(
                    visibleContent[index],
                    'Materi sedang disiapkan.',
                  );

                  final headingLevel = _contentHeadingLevel(text);
                  if (headingLevel != null) {
                    return _ReadingHeading(
                      text: _stripHeadingMarker(text),
                      level: headingLevel,
                      categoryColor: widget.categoryColor,
                      nightMode: _readingNightMode,
                    );
                  }

                  return ReadingParagraphCard(
                    text: text,
                    categoryColor: widget.categoryColor,
                    fontScale: _arabicFontScale,
                    arabicFontFamily: _arabicFontFamily,
                    nightMode: _readingNightMode,
                  );
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Future<void> _setArabicFontScale(double value) async {
    setState(() {
      _arabicFontScale = value;
    });

    await _preferences.setArabicReadingFontScale(value);
  }

  Future<void> _setArabicFontFamily(String value) async {
    setState(() {
      _arabicFontFamily = value;
    });
    await _preferences.setArabicReadingFontFamily(value);
  }

  Future<void> _setReadingNightMode(bool value) async {
    setState(() {
      _readingNightMode = value;
    });
    await _preferences.setReadingNightMode(value);
  }

  Future<void> _setMaulidTranslationVisible(bool value) async {
    setState(() {
      _showMaulidTranslation = value;
    });
    await _preferences.setMaulidTranslationVisible(value);
  }

  void _showReadingSettingsSheet(bool hasArabicContent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void updateFontScale(double value) {
              setSheetState(() => _arabicFontScale = value);
              _setArabicFontScale(value);
            }

            void updateFontFamily(String value) {
              setSheetState(() => _arabicFontFamily = value);
              _setArabicFontFamily(value);
            }

            void updateNightMode(bool value) {
              setSheetState(() => _readingNightMode = value);
              _setReadingNightMode(value);
            }

            void updateMaulidTranslation(bool value) {
              setSheetState(() => _showMaulidTranslation = value);
              _setMaulidTranslationVisible(value);
            }

            return _ReadingSettingsSheet(
              hasArabicContent: hasArabicContent,
              isMaulid: widget.material.category.toLowerCase() == 'maulid',
              fontScale: _arabicFontScale,
              selectedFontFamily: _arabicFontFamily,
              nightMode: _readingNightMode,
              showMaulidTranslation: _showMaulidTranslation,
              categoryColor: widget.categoryColor,
              onFontScaleChanged: updateFontScale,
              onFontFamilyChanged: updateFontFamily,
              onNightModeChanged: updateNightMode,
              onMaulidTranslationChanged: updateMaulidTranslation,
            );
          },
        );
      },
    );
  }

  static bool _hasArabicText(String text) => _arabicTextPattern.hasMatch(text);

  List<String> _visibleContent(List<String> content, {required bool isMaulid}) {
    if (!isMaulid || _showMaulidTranslation) return content;

    final filtered = <String>[];
    for (var index = 0; index < content.length; index++) {
      final text = content[index].trim();
      if (text.isEmpty) continue;

      final hasArabic = _hasArabicText(text);
      final previousHasArabic = index > 0 && _hasArabicText(content[index - 1]);

      if (!hasArabic && previousHasArabic) {
        continue;
      }

      filtered.add(text);
    }
    return filtered;
  }

  static String _cleanUiText(String value, String fallback) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || _badPlaceholderPattern.hasMatch(trimmed)) {
      return fallback;
    }
    return trimmed;
  }

  static int? _contentHeadingLevel(String value) {
    if (value.startsWith('### ')) return 3;
    if (value.startsWith('## ')) return 2;
    if (value.startsWith('# ')) return 1;
    return null;
  }

  static String _stripHeadingMarker(String value) {
    return value.replaceFirst(RegExp(r'^#{1,3}\s+'), '').trim();
  }
}

class _ReadingHeading extends StatelessWidget {
  final String text;
  final int level;
  final Color categoryColor;
  final bool nightMode;

  const _ReadingHeading({
    required this.text,
    required this.level,
    required this.categoryColor,
    required this.nightMode,
  });

  @override
  Widget build(BuildContext context) {
    final isMain = level == 1;
    final isSection = level == 2;
    final backgroundColor = nightMode
        ? AppColors.surface.withAlpha(isMain ? 28 : 16)
        : categoryColor.withAlpha(isMain ? 28 : 16);
    final borderColor = nightMode
        ? AppColors.limeGold.withAlpha(isMain ? 170 : 96)
        : categoryColor.withAlpha(isMain ? 180 : 92);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMain ? 18.w : 14.w,
        vertical: isMain ? 16.h : 12.h,
      ),
      decoration: BoxDecoration(
        color: isSection || isMain ? backgroundColor : Colors.transparent,
        borderRadius: BorderRadius.circular(isMain ? 18.r : 14.r),
        border: BorderDirectional(
          start: BorderSide(color: borderColor, width: isMain ? 4.w : 3.w),
        ),
      ),
      child: Text(
        text,
        textAlign: isMain ? TextAlign.center : TextAlign.start,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize:
              (isMain
                      ? 19
                      : isSection
                      ? 17
                      : 15)
                  .sp,
          height: 1.35,
          fontWeight: isMain ? FontWeight.w900 : FontWeight.w800,
          color: nightMode ? AppColors.surface : AppColors.deepEmerald,
        ),
      ),
    );
  }
}

class _ReadingSettingsSheet extends StatelessWidget {
  final bool hasArabicContent;
  final bool isMaulid;
  final double fontScale;
  final String selectedFontFamily;
  final bool nightMode;
  final bool showMaulidTranslation;
  final Color categoryColor;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<String> onFontFamilyChanged;
  final ValueChanged<bool> onNightModeChanged;
  final ValueChanged<bool> onMaulidTranslationChanged;

  const _ReadingSettingsSheet({
    required this.hasArabicContent,
    required this.isMaulid,
    required this.fontScale,
    required this.selectedFontFamily,
    required this.nightMode,
    required this.showMaulidTranslation,
    required this.categoryColor,
    required this.onFontScaleChanged,
    required this.onFontFamilyChanged,
    required this.onNightModeChanged,
    required this.onMaulidTranslationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 54.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.softBorder,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ),
          SizedBox(height: 26.h),
          Text('UKURAN HURUF', style: _sheetLabelStyle(context)),
          SizedBox(height: 14.h),
          Row(
            children: [
              Text('A', style: TextStyle(fontSize: 18.sp)),
              Expanded(
                child: Slider(
                  value: fontScale,
                  min: minArabicReadingFontScale,
                  max: maxArabicReadingFontScale,
                  divisions: 6,
                  activeColor: categoryColor,
                  label: '${(fontScale * 100).round()}%',
                  onChanged: hasArabicContent ? onFontScaleChanged : null,
                ),
              ),
              Text(
                'A',
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Text('JENIS FONT', style: _sheetLabelStyle(context)),
          SizedBox(height: 14.h),
          _FontChoiceRow(
            selectedFontFamily: selectedFontFamily,
            onChanged: hasArabicContent ? onFontFamilyChanged : (_) {},
          ),
          SizedBox(height: 24.h),
          _SwitchRow(
            title: 'Mode Malam',
            subtitle: 'Gunakan tema gelap untuk membaca',
            value: nightMode,
            onChanged: onNightModeChanged,
            activeColor: categoryColor,
          ),
          if (isMaulid) ...[
            SizedBox(height: 20.h),
            _SwitchRow(
              title: 'Terjemahan',
              subtitle: 'Tampilkan arti Bahasa Indonesia',
              value: showMaulidTranslation,
              onChanged: onMaulidTranslationChanged,
              activeColor: categoryColor,
            ),
          ],
        ],
      ),
    );
  }

  TextStyle? _sheetLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppColors.mutedEmerald,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.4,
    );
  }
}

class _FontChoiceRow extends StatelessWidget {
  final String selectedFontFamily;
  final ValueChanged<String> onChanged;

  const _FontChoiceRow({
    required this.selectedFontFamily,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const choices = [
      ('Utsmani', FontConstants.uthmanTNFontFamily),
      ('Hafs', FontConstants.hafsFontFamily),
      ('Quran', FontConstants.meQuranFontFamily),
    ];

    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: choices.map((choice) {
          final isSelected = selectedFontFamily == choice.$2;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(choice.$2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: isSelected ? AppColors.softShadow : null,
                ),
                child: Text(
                  choice.$1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected
                        ? AppColors.emerald
                        : AppColors.mutedEmerald,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.deepEmerald,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.mutedEmerald),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.surface,
          activeTrackColor: activeColor,
        ),
      ],
    );
  }
}
