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

  const MaterialListScreen({
    Key? key,
    required this.categoryName,
    required this.categoryFilterKey,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BerandaMaterialCubit>()..loadMaterialsByCategory(categoryFilterKey),
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: Text(categoryName),
          backgroundColor: categoryColor,
          foregroundColor: Colors.white,
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
          Icon(Icons.library_books_outlined, size: 80.r, color: Colors.grey[300]),
          SizedBox(height: AppSize.s16.h),
          Text(
            'Belum ada materi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: AppSize.s8.h),
          Text(
            'Materi untuk kategori ini akan segera tersedia',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList(BuildContext context, List<MaterialModel> materials) {
    return ListView.builder(
      padding: EdgeInsets.all(AppPadding.p16.w),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        return _MaterialCard(
          material: material,
          categoryColor: categoryColor,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.materialDetailRoute,
              arguments: {
                'material': material,
                'categoryColor': categoryColor,
              },
            );
          },
        );
      },
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final MaterialModel material;
  final Color categoryColor;
  final VoidCallback onTap;

  const _MaterialCard({
    required this.material,
    required this.categoryColor,
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

    return Card(
      margin: EdgeInsets.only(bottom: AppPadding.p12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSize.s12.r),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p16.w),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: itemColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(AppSize.s8.r),
                ),
                child: Icon(
                  itemVisual?.icon ?? Icons.article_outlined,
                  color: itemColor,
                  size: AppSize.s24.r,
                ),
              ),
              SizedBox(width: AppPadding.p16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (material.arabicTitle.isNotEmpty) ...[
                      SizedBox(height: AppSize.s4.h),
                      Text(
                        material.arabicTitle,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'UthmanTN',
                          fontSize: 18,
                          color: AppColors.tealGreen,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
