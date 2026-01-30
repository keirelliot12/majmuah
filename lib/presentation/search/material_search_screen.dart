import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../../data/repository/material_repository.dart';
import '../../domain/models/material/material_category.dart';
import '../../domain/models/material/material_item.dart';
import '../material/material_detail_screen.dart';

class MaterialSearchScreen extends StatefulWidget {
  const MaterialSearchScreen({Key? key}) : super(key: key);

  @override
  State<MaterialSearchScreen> createState() => _MaterialSearchScreenState();
}

class _MaterialSearchScreenState extends State<MaterialSearchScreen> {
  final MaterialRepository _repository = MaterialRepository();
  final TextEditingController _searchController = TextEditingController();

  List<MaterialItem> _allMaterials = [];
  List<MaterialItem> _filteredMaterials = [];
  List<MaterialCategory> _allCategories = [];

  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategoryFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final materials = await _repository.getMaterials();
      final categories = await _repository.getCategories();

      setState(() {
        _allMaterials = materials;
        _filteredMaterials = materials;
        _allCategories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _performSearch();
    });
  }

  void _performSearch() {
    if (_searchQuery.isEmpty && _selectedCategoryFilter == 'all') {
      _filteredMaterials = _allMaterials;
      return;
    }

    _filteredMaterials = _allMaterials.where((material) {
      // Filter by category first
      if (_selectedCategoryFilter != 'all') {
        if (material.category.toLowerCase() != _selectedCategoryFilter.toLowerCase()) {
          return false;
        }
      }

      // If no search query, return materials after category filter
      if (_searchQuery.isEmpty) {
        return true;
      }

      final query = _searchQuery.toLowerCase();

      // Search in title
      if (material.title.toLowerCase().contains(query)) {
        return true;
      }

      // Search in Arabic title
      if (material.arabicTitle != null &&
          material.arabicTitle!.toLowerCase().contains(query)) {
        return true;
      }

      // Search in category
      if (material.category.toLowerCase().contains(query)) {
        return true;
      }

      // Search in content
      if (material.contentText.toLowerCase().contains(query)) {
        return true;
      }

      // Search in tags
      for (var tag in material.tags) {
        if (tag.toLowerCase().contains(query)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  void _onCategoryFilterChanged(String? category) {
    setState(() {
      _selectedCategoryFilter = category ?? 'all';
      _performSearch();
    });
  }

  Color _getCategoryColor(String category) {
    final colorMap = {
      'doa': const Color(0xFFD4945F),
      'ratib': const Color(0xFF90A88E),
      'qasidah': const Color(0xFF8B7355),
      'umum': const Color(0xFFE8A05D),
      'tahlil & jenazah': const Color(0xFF6B8E7D),
      'panduan ibadah': const Color(0xFF5A8C6B),
      'amalan khusus': const Color(0xFFB8906D),
      'sholawat': const Color(0xFFE8A05D),
      'al-quran': const Color(0xFF5A8C6B),
      'hizib': const Color(0xFF90A88E),
      'manaqib & istighosah': const Color(0xFF6B8E7D),
      'puji-pujian & bilal': const Color(0xFFD4945F),
      'amalan tahunan': const Color(0xFF8B7355),
    };
    return colorMap[category.toLowerCase()] ?? const Color(0xFF5A8C6B);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Bacaan'),
        backgroundColor: const Color(0xFF5A8C6B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF5A8C6B),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: EdgeInsets.all(AppPadding.p16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari judul, kategori, atau konten...',
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF5A8C6B)),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppPadding.p20.w,
                          vertical: AppPadding.p16.h,
                        ),
                      ),
                      onSubmitted: (value) {
                        _performSearch();
                      },
                    ),
                  ),
                ),
                // Category Filter
                Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip('Semua', 'all'),
                      ..._allCategories.map((category) {
                        return _buildCategoryChip(
                          category.title,
                          category.filterKey,
                        );
                      }).toList(),
                    ],
                  ),
                ),
                SizedBox(height: AppSize.s12.h),
              ],
            ),
          ),

          // Results
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = _selectedCategoryFilter == value;
    return Padding(
      padding: EdgeInsets.only(right: AppSize.s8.w),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          _onCategoryFilterChanged(selected ? value : 'all');
        },
        backgroundColor: Colors.white.withAlpha(128),
        selectedColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF5A8C6B) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p12.w,
          vertical: AppSize.s8.h,
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF5A8C6B),
        ),
      );
    }

    if (_filteredMaterials.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Result count
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p16.w,
            vertical: AppSize.s12.h,
          ),
          color: Colors.grey[100],
          child: Row(
            children: [
              Icon(
                Icons.article_outlined,
                size: AppSize.s16.r,
                color: Colors.grey[600],
              ),
              SizedBox(width: AppSize.s8.w),
              Text(
                'Ditemukan ${_filteredMaterials.length} bacaan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        // Results list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(AppPadding.p16.w),
            itemCount: _filteredMaterials.length,
            itemBuilder: (context, index) {
              final material = _filteredMaterials[index];
              final categoryColor = _getCategoryColor(material.category);

              return _SearchResultCard(
                material: material,
                categoryColor: categoryColor,
                searchQuery: _searchQuery,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaterialDetailScreen(
                        material: material,
                        categoryColor: categoryColor,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isEmpty ? Icons.search : Icons.search_off,
              size: 80.r,
              color: Colors.grey[300],
            ),
            SizedBox(height: AppSize.s16.h),
            Text(
              _searchQuery.isEmpty
                  ? 'Mulai mencari bacaan'
                  : 'Tidak ditemukan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            SizedBox(height: AppSize.s8.h),
            Text(
              _searchQuery.isEmpty
                  ? 'Ketik kata kunci untuk mencari bacaan'
                  : 'Coba kata kunci lain',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[400],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final MaterialItem material;
  final Color categoryColor;
  final String searchQuery;
  final VoidCallback onTap;

  const _SearchResultCard({
    required this.material,
    required this.categoryColor,
    required this.searchQuery,
    required this.onTap,
  });

  String _getHighlightedSnippet(String text, String query) {
    if (query.isEmpty) return text;

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) return text.length > 100 ? '${text.substring(0, 100)}...' : text;

    final start = (index - 30).clamp(0, text.length);
    final end = (index + query.length + 70).clamp(0, text.length);

    String snippet = text.substring(start, end);
    if (start > 0) snippet = '...$snippet';
    if (end < text.length) snippet = '$snippet...';

    return snippet;
  }

  @override
  Widget build(BuildContext context) {
    final contentSnippet = searchQuery.isNotEmpty
        ? _getHighlightedSnippet(material.contentText, searchQuery)
        : (material.contentText.length > 100
            ? '${material.contentText.substring(0, 100)}...'
            : material.contentText);

    return Card(
      margin: EdgeInsets.only(bottom: AppPadding.p12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSize.s12.r),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s12.w,
                  vertical: AppSize.s4.h,
                ),
                decoration: BoxDecoration(
                  color: categoryColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  material.category,
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: AppSize.s12.h),
              // Title
              Text(
                material.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Arabic title
              if (material.arabicTitle != null) ...[
                SizedBox(height: AppSize.s8.h),
                Text(
                  material.arabicTitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.w500,
                        height: 1.8,
                      ),
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              // Content snippet
              SizedBox(height: AppSize.s8.h),
              Text(
                contentSnippet,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              // Tags if available
              if (material.tags.isNotEmpty) ...[
                SizedBox(height: AppSize.s12.h),
                Wrap(
                  spacing: AppSize.s8.w,
                  runSpacing: AppSize.s8.h,
                  children: material.tags.take(3).map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.s8.w,
                        vertical: AppSize.s4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: FontSize.s10,
                          color: Colors.grey[700],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
