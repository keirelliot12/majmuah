import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/resources/resources.dart';
import '../../../../di/di.dart';
import '../../../components/app_category_icon.dart';
import '../../cubit/beranda_category_cubit.dart';
import '../../helpers/category_visuals.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  static final RegExp _badPlaceholderPattern = RegExp(r'^\?{3,}$');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BerandaCategoryCubit>()..loadCategories(),
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: const Text('Semua Kategori'),
          centerTitle: true,
          backgroundColor: AppColors.offWhite,
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

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Pilih tema bacaan',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.darkerTeal,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 14.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 0.82,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        // First item is "Semua Materi"
                        if (index == 0) {
                          return _buildAllMaterialsCard(context);
                        }

                        // Adjust index for categories (subtract 1 because of "Semua Materi")
                        final category = categories[index - 1];
                        final categoryVisual = CategoryVisuals.forCategory(
                          category.filterKey.isNotEmpty
                              ? category.filterKey
                              : category.title,
                          fallbackColor: category.iconColor,
                          assetPath: category.iconAsset,
                        );

                        return _CategoryTile(
                          title: _cleanUiText(category.title, 'Kategori'),
                          icon: categoryVisual.icon,
                          iconAsset: categoryVisual.assetPath,
                          color: categoryVisual.color,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.materialListRoute,
                              arguments: {
                                'categoryName': _cleanUiText(
                                  category.title,
                                  'Kategori',
                                ),
                                'categoryFilterKey': category.filterKey,
                                'categoryColor': categoryVisual.color,
                                'categoryIconAsset': categoryVisual.assetPath,
                              },
                            );
                          },
                        );
                      }, childCount: totalItems),
                    ),
                  ),
                ],
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
    return _CategoryTile(
      title: 'Semua Materi',
      icon: CategoryVisuals.forCategory('Al-Quran').icon,
      iconAsset: 'assets/icons/all_materials.png',
      color: AppColors.tealGreen,
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.materialListRoute,
          arguments: {
            'categoryName': 'Semua Materi',
            'categoryFilterKey': '', // Empty string means no filter
            'categoryColor': AppColors.tealGreen,
            'categoryIconAsset': 'assets/icons/all_materials.png',
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

class _CategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? iconAsset;
  final Color color;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.title,
    required this.icon,
    this.iconAsset,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          child: Column(
            children: [
              Container(
                width: 62.w,
                height: 62.w,
                decoration: BoxDecoration(
                  color: color.withAlpha(24),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: color.withAlpha(35)),
                ),
                child: Center(
                  child: AppCategoryIcon(
                    assetPath: iconAsset,
                    fallbackIcon: icon,
                    color: color,
                    size: 42,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkerTeal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
