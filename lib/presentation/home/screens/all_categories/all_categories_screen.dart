import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/resources/resources.dart';
import '../../../../di/di.dart';
import '../../cubit/beranda_category_cubit.dart';

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
              return GridView.builder(
                padding: EdgeInsets.all(AppPadding.p16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 0.8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.materialListRoute,
                        arguments: {
                          'categoryName': category.title,
                          'categoryFilterKey': category.filterKey,
                          'categoryColor': AppColors.tealGreen, // Default color
                        },
                      );
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
                          child: Image.asset(
                            category.iconAsset,
                            width: 40.w,
                            height: 40.w,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.category, size: 40.w, color: AppColors.tealGreen),
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
}
