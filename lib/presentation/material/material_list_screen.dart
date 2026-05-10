import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../../di/di.dart';
import '../../domain/models/material/material_model.dart';
import '../home/helpers/category_visuals.dart';
import '../home/cubit/beranda_material_cubit.dart';
import '../home/cubit/beranda_material_state.dart';

class MaterialListScreen extends StatelessWidget {
  final String categoryName;
  final String categoryFilterKey;
  final Color categoryColor;

  static final RegExp _badPlaceholderPattern = RegExp(r'^[\?\s]+$');

  const MaterialListScreen({
    Key? key,
    required this.categoryName,
    required this.categoryFilterKey,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          instance<BerandaMaterialCubit>()
            ..loadMaterialsByCategory(categoryFilterKey),
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: Text(_cleanUiText(categoryName, 'Materi')),
          backgroundColor: AppColors.offWhite,
          foregroundColor: AppColors.darkerTeal,
          elevation: 0,
        ),
        body: BlocBuilder<BerandaMaterialCubit, BerandaMaterialState>(
          builder: (context, state) {
            if (state is BerandaMaterialLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BerandaMaterialLoaded) {
              final materials = state.materials;
              if (materials.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildMaterialsList(context, materials);
            } else if (state is BerandaMaterialError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Tidak ada materi'));
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 70.r,
            color: categoryColor.withAlpha(76),
          ),
          SizedBox(height: AppSize.s16.h),
          Text(
            'Belum ada materi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.darkerTeal,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSize.s8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'Materi untuk kategori ini akan segera tersedia',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.gray,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList(
    BuildContext context,
    List<MaterialModel> materials,
  ) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      itemCount: materials.length + 1,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _ListIntro(
            title: _cleanUiText(categoryName, 'Materi'),
            count: materials.length,
            color: categoryColor,
          );
        }

        final material = materials[index - 1];
        return _MaterialRow(
          material: material,
          categoryColor: categoryColor,
          cleanUiText: _cleanUiText,
          onTap: () {
            if (material.tags.contains('placeholder')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Materi ini sedang disiapkan untuk pembaruan berikutnya.',
                  ),
                ),
              );
              return;
            }

            Navigator.pushNamed(
              context,
              Routes.materialDetailRoute,
              arguments: {'material': material, 'categoryColor': categoryColor},
            );
          },
        );
      },
    );
  }

  static String _cleanUiText(String value, String fallback) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || _badPlaceholderPattern.hasMatch(trimmed)) {
      return fallback;
    }
    return trimmed;
  }
}

class _ListIntro extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _ListIntro({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withAlpha(28)),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: color.withAlpha(32),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.menu_book_rounded, color: color, size: 22.r),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkerTeal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    '$count materi tersedia',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialRow extends StatelessWidget {
  final MaterialModel material;
  final Color categoryColor;
  final String Function(String value, String fallback) cleanUiText;
  final VoidCallback onTap;

  const _MaterialRow({
    required this.material,
    required this.categoryColor,
    required this.cleanUiText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemVisual = material.category == 'KBIHU Nur Multazam'
        ? CategoryVisuals.forCategory(
            material.title,
            fallbackColor: categoryColor,
          )
        : null;
    final itemColor = itemVisual?.color ?? categoryColor;
    final title = cleanUiText(material.title, 'Materi');
    final arabicTitle = cleanUiText(material.arabicTitle, '');
    final isPlaceholder = material.tags.contains('placeholder');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 13.h),
          child: Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: itemColor.withAlpha(24),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  itemVisual?.icon ?? Icons.article_outlined,
                  color: itemColor,
                  size: 23.r,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkerTeal,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isPlaceholder) ...[
                      SizedBox(height: 4.h),
                      Text(
                        'Sedang disiapkan',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.gray500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (arabicTitle.isNotEmpty) ...[
                      SizedBox(height: 5.h),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          arabicTitle,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'UthmanTN',
                            fontSize: 18.sp,
                            height: 1.5,
                            color: itemColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Icon(
                isPlaceholder
                    ? Icons.hourglass_empty_rounded
                    : Icons.chevron_right_rounded,
                color: itemColor,
                size: 22.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
