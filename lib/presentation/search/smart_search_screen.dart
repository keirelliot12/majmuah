import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../app/resources/resources.dart';
import '../../app/utils/app_prefs.dart';
import '../../di/di.dart';
import '../../domain/models/material/material_model.dart';
import '../home/cubit/beranda_material_cubit.dart';
import '../home/cubit/beranda_material_state.dart';

class SmartSearchScreen extends StatefulWidget {
  const SmartSearchScreen({Key? key}) : super(key: key);

  @override
  State<SmartSearchScreen> createState() => _SmartSearchScreenState();
}

class _SmartSearchScreenState extends State<SmartSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  List<String> _searchHistory = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() {
    setState(() {
      _searchHistory = _appPreferences.getSearchHistory();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {});
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<BerandaMaterialCubit>().searchMaterials(trimmedQuery);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  void _clearHistory() async {
    await _appPreferences.clearSearchHistory();
    _loadSearchHistory();
  }

  void _handleHistoryTap(String query) {
    _searchController.text = query;
    context.read<BerandaMaterialCubit>().searchMaterials(query);
    setState(() {});
  }

  void _handleResultTap(MaterialModel material) async {
    await _appPreferences.addSearchQuery(material.title);
    if (mounted) {
      Navigator.pushNamed(
        context,
        Routes.materialDetailRoute,
        arguments: {'material': material, 'categoryColor': AppColors.tealGreen},
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _searchController.text.trim().isEmpty
                ? _buildHistoryPlaceholder()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().statusBarHeight + 10.h,
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.darkTeal.withAlpha(18)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                color: AppColors.darkerTeal,
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Pencarian Cerdas',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.darkerTeal,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40.w), // Balance for back button
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 52.h,
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: AppColors.tealGreen.withAlpha(35)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              autofocus: true,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.darkerTeal,
              ),
              decoration: InputDecoration(
                hintText: 'Cari surah, wirid, atau doa...',
                hintStyle: TextStyle(
                  color: AppColors.darkerTeal.withAlpha(105),
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Symbols.search,
                  color: AppColors.tealGreen,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Symbols.cancel,
                          color: AppColors.darkerTeal.withAlpha(120),
                          size: 20,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryPlaceholder() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PENCARIAN TERAKHIR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkerTeal,
                    letterSpacing: 1.2,
                  ),
                ),
                TextButton(
                  onPressed: _clearHistory,
                  child: const Text(
                    'Bersihkan',
                    style: TextStyle(
                      color: AppColors.tealGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _searchHistory
                  .map(
                    (query) => GestureDetector(
                      onTap: () => _handleHistoryTap(query),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColors.tealGreen.withAlpha(28),
                          ),
                        ),
                        child: Text(
                          query,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkerTeal,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ] else
            Center(
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  Container(
                    width: 88.r,
                    height: 88.r,
                    decoration: BoxDecoration(
                      color: AppColors.lemonYellow.withAlpha(55),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Symbols.travel_explore,
                      size: 42.r,
                      color: AppColors.tealGreen,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  const Text(
                    'Temukan panduan ibadah',
                    style: TextStyle(
                      color: AppColors.darkerTeal,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Ketik kata kunci untuk mencari surah, wirid, atau doa.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.darkerTeal.withAlpha(140),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<BerandaMaterialCubit, BerandaMaterialState>(
      builder: (context, state) {
        if (state is BerandaMaterialLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BerandaMaterialLoaded) {
          final materials = state.materials;
          if (materials.isEmpty) {
            return _buildNoResults();
          }
          return ListView.builder(
            padding: EdgeInsets.all(24.w),
            itemCount: materials.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: const Text(
                    'SARAN CEPAT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkerTeal,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              }
              final material = materials[index - 1];
              return _buildResultCard(material);
            },
          );
        } else if (state is BerandaMaterialError) {
          return Center(
            child: Text('Gagal melakukan pencarian: ${state.message}'),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildResultCard(MaterialModel material) {
    IconData icon;
    Color iconColor;
    Color bgColor;
    String typeLabel;

    // Mapping categories to types in design
    if (material.category.toLowerCase().contains('quran')) {
      typeLabel = 'Surat';
      icon = Symbols.menu_book;
      iconColor = AppColors.islamicTeal;
      bgColor = AppColors.islamicTeal.withAlpha(22);
    } else if (material.category.toLowerCase().contains('doa') ||
        material.category.toLowerCase().contains('dzikir')) {
      typeLabel = 'Doa';
      icon = Symbols.star;
      iconColor = Colors.amber.shade500;
      bgColor = AppColors.lemonYellow.withAlpha(55);
    } else {
      typeLabel = 'Konten';
      icon = Symbols.auto_stories;
      iconColor = AppColors.darkTeal;
      bgColor = AppColors.tealGreen.withAlpha(18);
    }

    return GestureDetector(
      onTap: () => _handleResultTap(material),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.darkTeal.withAlpha(14)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 20, fill: 1.0),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeLabel.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: iconColor,
                    ),
                  ),
                  Text(
                    material.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkerTeal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.darkerTeal.withAlpha(120),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
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
                color: AppColors.tealGreen.withAlpha(18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.search_off,
                size: 42.r,
                color: AppColors.tealGreen,
              ),
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
              'Coba gunakan kata kunci lain yang lebih singkat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkerTeal.withAlpha(140),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
