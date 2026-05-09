import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../../di/di.dart';
import '../home/cubit/beranda_material_cubit.dart';
import '../home/cubit/beranda_material_state.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;

  const SearchResultScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BerandaMaterialCubit>()..searchMaterials(query),
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: Text('Hasil pencarian'),
          centerTitle: true,
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.darkTeal,
          elevation: 0,
        ),
        body: BlocBuilder<BerandaMaterialCubit, BerandaMaterialState>(
          builder: (context, state) {
            if (state is BerandaMaterialLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BerandaMaterialLoaded) {
              final materials = state.materials;
              if (materials.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.builder(
                padding: EdgeInsets.all(AppPadding.p16.w),
                itemCount: materials.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: Text(
                        'Menampilkan hasil untuk "$query"',
                        style: TextStyle(
                          color: AppColors.darkerTeal.withAlpha(150),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  final material = materials[index - 1];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.darkTeal.withAlpha(14)),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      leading: Container(
                        width: 42.r,
                        height: 42.r,
                        decoration: BoxDecoration(
                          color: AppColors.tealGreen.withAlpha(18),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: const Icon(Icons.auto_stories_outlined, color: AppColors.tealGreen),
                      ),
                      title: Text(
                        material.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkerTeal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        material.category,
                        style: TextStyle(
                          color: AppColors.darkTeal.withAlpha(150),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, color: AppColors.darkerTeal.withAlpha(120)),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.materialDetailRoute,
                          arguments: {
                            'material': material,
                            'categoryColor': AppColors.tealGreen,
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Gagal melakukan pencarian'));
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88.r,
              height: 88.r,
              decoration: BoxDecoration(
                color: AppColors.lemonYellow.withAlpha(55),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off, size: 42.r, color: AppColors.tealGreen),
            ),
            SizedBox(height: 16.h),
            const Text(
              'Belum ada hasil',
              style: TextStyle(
                color: AppColors.darkerTeal,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Coba kata kunci lain atau periksa kembali ejaan pencarian.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.darkerTeal.withAlpha(140), fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}
