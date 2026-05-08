import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../app/resources/resources.dart';
import '../../../../di/di.dart';
import '../../cubit/beranda_category_cubit.dart';
import '../../helpers/category_visuals.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BerandaCategoryCubit>()..loadCategories(),
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: const Text('Semua Kategori'),
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          foregroundColor: AppColors.darkTeal,
        ),
        body: BlocBuilder<BerandaCategoryCubit, BerandaCategoryState>(
          builder: (context, state) {
            if (state is BerandaCategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BerandaCategoryLoaded) {
              final categories = state.categories;
              // Total items = "Semua Materi" card + all categories
              final totalItems = categories.length + 1;

              return GridView.builder(
                padding: EdgeInsets.all(AppPadding.p16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 0.8,
                ),
                itemCount: totalItems,
                itemBuilder: (context, index) {
                  // First item is "Semua Materi"
                  if (index == 0) {
                    return _buildAllMaterialsCard(context);
                  }

                  // Adjust index for categories (subtract 1 because of "Semua Materi")
                  final category = categories[index - 1];
                  final categoryVisual = CategoryVisuals.forCategory(
                    category.filterKey.isNotEmpty ? category.filterKey : category.title,
                    fallbackColor: category.iconColor,
                  );

                  return GestureDetector(
                    onTap: () {
                      if (category.filterKey == 'Notes') {
                        Navigator.pushNamed(context, Routes.notesListRoute);
                      } else {
                        Navigator.pushNamed(
                          context,
                          Routes.materialListRoute,
                          arguments: {
                            'categoryName': category.title,
                            'categoryFilterKey': category.filterKey,
                            'categoryColor': categoryVisual.color,
                          },
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(13),
                                blurRadius: 10.r,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            categoryVisual.icon,
                            size: 40.w,
                            color: categoryVisual.color,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          category.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkTeal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is BerandaCategoryError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Tidak ada kategori'));
          },
        ),
      ),
    );
  }

  /// Build "Semua Materi" card that shows all materials without category filter
  Widget _buildAllMaterialsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.materialListRoute,
          arguments: {
            'categoryName': 'Semua Materi',
            'categoryFilterKey': '', // Empty string means no filter
            'categoryColor': AppColors.tealGreen,
          },
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.tealGreen,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Symbols.library_books,
              size: 40.w,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Semua Materi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkTeal,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
