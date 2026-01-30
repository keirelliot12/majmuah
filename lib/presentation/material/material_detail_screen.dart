import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../../domain/models/material/material_model.dart';

class MaterialDetailScreen extends StatelessWidget {
  final MaterialModel material;
  final Color categoryColor;

  const MaterialDetailScreen({
    Key? key,
    required this.material,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text(
          material.title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: categoryColor,
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
                color: categoryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.r),
                  bottomRight: Radius.circular(32.r),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    material.arabicTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'UthmanTN',
                      fontSize: 32.sp,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    material.title,
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

            // Content paragraphs
            Padding(
              padding: EdgeInsets.all(AppPadding.p24.w),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: material.content.length,
                separatorBuilder: (context, index) => SizedBox(height: 24.h),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 10.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      material.content[index],
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
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
    final fullContent = material.content.join('\n\n');
    Clipboard.setData(ClipboardData(text: '${material.title}\n\n$fullContent'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Konten disalin ke clipboard')),
    );
  }
}
