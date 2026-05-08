import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _arabicFontScale = _preferences.getArabicReadingFontScale();
    // Update last read when opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      instance<BerandaMaterialCubit>().setLastRead(widget.material.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text(
          widget.material.title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: widget.categoryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _copyContent(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and arabic title
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppPadding.p24.w),
              decoration: BoxDecoration(
                color: widget.categoryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.r),
                  bottomRight: Radius.circular(32.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      widget.material.arabicTitle,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'UthmanTN',
                        fontSize: 32.sp,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    widget.material.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withAlpha(230),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                AppPadding.p24.w,
                AppPadding.p20.h,
                AppPadding.p24.w,
                0,
              ),
              child: _FontScaleControl(
                value: _arabicFontScale,
                categoryColor: widget.categoryColor,
                onChanged: _setArabicFontScale,
              ),
            ),

            // Content paragraphs
            Padding(
              padding: EdgeInsets.all(AppPadding.p24.w),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.material.content.length,
                separatorBuilder: (context, index) => SizedBox(height: 24.h),
                itemBuilder: (context, index) {
                  return ReadingParagraphCard(
                    text: widget.material.content[index],
                    categoryColor: widget.categoryColor,
                    fontScale: _arabicFontScale,
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

  void _copyContent(BuildContext context) {
    final fullContent = widget.material.content.join('\n\n');
    Clipboard.setData(
      ClipboardData(text: '${widget.material.title}\n\n$fullContent'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Konten disalin ke clipboard')),
    );
  }

  Future<void> _setArabicFontScale(double value) async {
    setState(() {
      _arabicFontScale = value;
    });

    await _preferences.setArabicReadingFontScale(value);
  }
}

class _FontScaleControl extends StatelessWidget {
  final double value;
  final Color categoryColor;
  final ValueChanged<double> onChanged;

  const _FontScaleControl({
    required this.value,
    required this.categoryColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16.w,
        vertical: AppPadding.p12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: categoryColor.withAlpha(31)),
      ),
      child: Row(
        children: [
          Icon(Icons.format_size, color: categoryColor, size: 22.r),
          SizedBox(width: 12.w),
          Text(
            'Ukuran Arab',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkerTeal,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Slider(
              value: value,
              min: minArabicReadingFontScale,
              max: maxArabicReadingFontScale,
              divisions: 6,
              activeColor: categoryColor,
              label: '${(value * 100).round()}%',
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
