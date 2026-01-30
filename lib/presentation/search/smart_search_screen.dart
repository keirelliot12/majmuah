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
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        context.read<BerandaMaterialCubit>().searchMaterials(query);
      }
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
        arguments: {
          'material': material,
          'categoryColor': AppColors.tealGreen,
        },
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
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _searchController.text.isEmpty
              ? _buildHistoryPlaceholder()
              : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight + 10.h, left: 24.w, right: 24.w, bottom: 24.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.lemonYellow,
            Color(0xFFA8D5A2), // matching the HTML 'search-container' bottom
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Pencarian Cerdas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(width: 40.w), // Balance for back button
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              autofocus: true,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Cari Surah, Wirid, atau Doa...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                prefixIcon: Icon(Symbols.search, color: Colors.grey.shade500),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Symbols.cancel, color: Colors.grey.shade400, size: 20),
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
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.5,
                  ),
                ),
                TextButton(
                  onPressed: _clearHistory,
                  child: const Text(
                    'Bersihkan',
                    style: TextStyle(color: AppColors.islamicTeal, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _searchHistory.map((query) => GestureDetector(
                onTap: () => _handleHistoryTap(query),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    query,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54),
                  ),
                ),
              )).toList(),
            ),
          ] else
            Center(
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  Icon(Symbols.search, size: 80.r, color: Colors.grey.shade200),
                  SizedBox(height: 16.h),
                  Text(
                    'Mulai cari bimbingan spiritualmu',
                    style: TextStyle(color: Colors.grey.shade400),
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
                    'INSTANT SUGGESTIONS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.5,
                    ),
                  ),
                );
              }
              final material = materials[index - 1];
              return _buildResultCard(material);
            },
          );
        } else if (state is BerandaMaterialError) {
          return Center(child: Text('Error: ${state.message}'));
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
      typeLabel = 'SUrat';
      icon = Symbols.menu_book;
      iconColor = AppColors.islamicTeal;
      bgColor = Colors.teal.shade50;
    } else if (material.category.toLowerCase().contains('doa') || material.category.toLowerCase().contains('dzikir')) {
      typeLabel = 'AYAT'; // or 'DOA'
      icon = Symbols.star;
      iconColor = Colors.amber.shade500;
      bgColor = Colors.amber.shade50;
    } else {
      typeLabel = 'KONTEN';
      icon = Symbols.auto_stories;
      iconColor = Colors.indigo.shade500;
      bgColor = Colors.indigo.shade50;
    }

    return GestureDetector(
      onTap: () => _handleResultTap(material),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  Text(
                    material.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Symbols.search_off, size: 80.r, color: Colors.grey.shade200),
          SizedBox(height: 16.h),
          const Text('Hasil tidak ditemukan', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
