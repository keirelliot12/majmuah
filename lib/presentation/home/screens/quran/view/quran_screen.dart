import 'dart:ui' as ui;

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/models/quran/quran_model.dart';
import '../../../../../domain/models/download/download_manifest.dart';
import '../../../../../app/resources/resources.dart';

import '../cubit/quran_cubit.dart';
import '../../../../download/cubit/download_cubit.dart';
import '../../../../download/cubit/download_state.dart';
import '../../../../download/widgets/download_prompt_dialog.dart';
import '../../../../download/widgets/download_progress_sheet.dart';
import '../../../../../di/di.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _hasShownInitialDownloadPrompt = false;
  bool _isQuranDownloaded = false;
  bool _isProgressSheetVisible = false;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => instance<DownloadCubit>()..checkManifest(),
        ),
      ],
      child: BlocListener<DownloadCubit, DownloadState>(
        listener: (context, state) {
          if (state is DownloadManifestLoaded) {
            _isQuranDownloaded = state.isQuranFullyDownloaded;

            if (!_isQuranDownloaded && !_hasShownInitialDownloadPrompt) {
              _hasShownInitialDownloadPrompt = true;
              _showDownloadPrompt(context);
            }
          } else if (state is DownloadSuccess) {
            _closeProgressSheet(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DownloadFailure) {
            _closeProgressSheet(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is DownloadProgressState) {
            _showProgressSheet(context, state);
          }
        },
        child: BlocBuilder<DownloadCubit, DownloadState>(
          builder: (context, downloadState) {
            bool isDownloaded = _isQuranDownloaded;
            if (downloadState is DownloadManifestLoaded) {
              isDownloaded = downloadState.isQuranFullyDownloaded;
            }

            return BlocBuilder<QuranCubit, QuranState>(
              builder: (context, state) {
                QuranCubit cubit = QuranCubit.get(context);
                List<QuranModel> quranList = cubit.quranData;

                final currentLocale = context.locale;
                bool isEnglish =
                    currentLocale.languageCode ==
                    LanguageType.english.getValue();

                return ConditionalBuilder(
                  condition: quranList.isNotEmpty,
                  builder: (BuildContext context) {
                    final allItems = _buildDisplayItems(quranList);
                    final visibleItems = _filterItems(allItems);

                    return ColoredBox(
                      color: AppColors.background,
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              16.h,
                              20.w,
                              10.h,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: _QuranHeaderCard(
                                totalSurah: allItems.length,
                                isDownloaded: isDownloaded,
                                onManageDownload: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.downloadManagerRoute,
                                  );
                                },
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            sliver: SliverToBoxAdapter(
                              child: _QuranSearchBar(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _query = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                            sliver: SliverToBoxAdapter(
                              child: _QuickAccessChips(
                                items: allItems,
                                onSelected: (item) => _openSurahItem(
                                  item: item,
                                  quranList: quranList,
                                  isDownloaded: isDownloaded,
                                  downloadState: downloadState,
                                  context: context,
                                ),
                              ),
                            ),
                          ),
                          if (!isDownloaded)
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                              sliver: SliverToBoxAdapter(
                                child: _DownloadStatusBanner(
                                  onTap: () => _showDownloadPrompt(context),
                                ),
                              ),
                            ),
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              16.h,
                              20.w,
                              96.h,
                            ),
                            sliver: _SurahListCard(
                              items: visibleItems,
                              isEnglish: isEnglish,
                              onTap: (item) => _openSurahItem(
                                item: item,
                                quranList: quranList,
                                isDownloaded: isDownloaded,
                                downloadState: downloadState,
                                context: context,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  fallback: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.gold,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<_SurahDisplayItem> _buildDisplayItems(List<QuranModel> quranList) {
    return List<_SurahDisplayItem>.generate(quranList.length, (index) {
      final model = quranList[index];
      return _SurahDisplayItem(
        number: index + 1,
        name: model.name,
        englishName: model.englishName,
        pageNo: model.ayahs.first.page,
      );
    });
  }

  List<_SurahDisplayItem> _filterItems(List<_SurahDisplayItem> items) {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return items;

    return items.where((item) {
      return item.number.toString().contains(normalizedQuery) ||
          item.name.toLowerCase().contains(normalizedQuery) ||
          item.englishName.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  void _showDownloadPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DownloadPromptDialog(
        featureName: "Al-Quran",
        description:
            "Pilih paket mushaf yang ingin diunduh. Setiap paket berisi sekitar 10 juz.",
        totalSize: "120 MB",
        onDownload: () {
          Navigator.pushNamed(context, Routes.downloadManagerRoute);
        },
      ),
    );
  }

  void _showPackageDownloadPrompt(BuildContext context, QuranChunk chunk) {
    showDialog(
      context: context,
      builder: (_) => DownloadPromptDialog(
        featureName: chunk.title,
        description:
            "Untuk membuka halaman ini, unduh ${chunk.title} terlebih dahulu.",
        totalSize: _formatSize(chunk.sizeBytes),
        onDownload: () {
          DownloadCubit.get(context).downloadQuranChunk(chunk);
        },
      ),
    );
  }

  void _showProgressSheet(BuildContext context, DownloadProgressState state) {
    if (_isProgressSheetVisible) return;

    _isProgressSheetVisible = true;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocBuilder<DownloadCubit, DownloadState>(
        bloc: DownloadCubit.get(context),
        builder: (context, currentState) {
          if (currentState is DownloadProgressState) {
            return DownloadProgressSheet(
              progress: currentState.progress,
              currentChunk: currentState.currentChunk,
              totalChunks: currentState.totalChunks,
            );
          }

          return DownloadProgressSheet(
            progress: state.progress,
            currentChunk: state.currentChunk,
            totalChunks: state.totalChunks,
          );
        },
      ),
    ).whenComplete(() {
      _isProgressSheetVisible = false;
    });
  }

  void _closeProgressSheet(BuildContext context) {
    if (!_isProgressSheetVisible) return;
    Navigator.of(context).pop();
    _isProgressSheetVisible = false;
  }

  void _openSurahItem({
    required _SurahDisplayItem item,
    required List<QuranModel> quranList,
    required bool isDownloaded,
    required DownloadState downloadState,
    required BuildContext context,
  }) {
    final requiredChunk = _requiredChunk(downloadState, item.pageNo);
    final isPageDownloaded = requiredChunk == null
        ? isDownloaded
        : _isChunkDownloaded(downloadState, requiredChunk.id);

    if (!isPageDownloaded) {
      if (requiredChunk == null) {
        _showDownloadPrompt(context);
      } else {
        _showPackageDownloadPrompt(context, requiredChunk);
      }
      return;
    }

    Navigator.pushNamed(
      context,
      Routes.quranRoute,
      arguments: {'quranList': quranList, 'pageNo': item.pageNo},
    );
  }

  QuranChunk? _requiredChunk(DownloadState state, int pageNo) {
    final manifest = _manifestFrom(state);
    if (manifest == null) return null;

    for (final chunk in manifest.quran.chunks) {
      if (pageNo >= chunk.startPage && pageNo <= chunk.endPage) {
        return chunk;
      }
    }
    return null;
  }

  DownloadManifest? _manifestFrom(DownloadState state) {
    if (state is DownloadManifestLoaded) return state.manifest;
    if (state is DownloadProgressState) return state.manifest;
    return null;
  }

  bool _isChunkDownloaded(DownloadState state, String chunkId) {
    if (state is DownloadManifestLoaded) {
      return state.downloadedChunks.contains(chunkId);
    }
    if (state is DownloadProgressState) {
      return state.downloadedChunks.contains(chunkId);
    }
    return _isQuranDownloaded;
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return "belum diketahui";
    final mb = bytes / (1024 * 1024);
    return "${mb.toStringAsFixed(0)} MB";
  }
}

class _SurahDisplayItem {
  const _SurahDisplayItem({
    required this.number,
    required this.name,
    required this.englishName,
    required this.pageNo,
  });

  final int number;
  final String name;
  final String englishName;
  final int pageNo;
}

class _QuranHeaderCard extends StatelessWidget {
  const _QuranHeaderCard({
    required this.totalSurah,
    required this.isDownloaded,
    required this.onManageDownload,
  });

  final int totalSurah;
  final bool isDownloaded;
  final VoidCallback onManageDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.deepEmerald, AppColors.emerald],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: AppColors.limeGold.withAlpha(44),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.limeGold.withAlpha(90)),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.limeGold,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Al-Quran',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      '$totalSurah surah tersedia',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.surface.withAlpha(190),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onManageDownload,
                borderRadius: BorderRadius.circular(999.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDownloaded
                        ? AppColors.limeGold
                        : AppColors.surface.withAlpha(28),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    isDownloaded ? 'Offline' : 'Unduh',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isDownloaded
                          ? AppColors.deepEmerald
                          : AppColors.surface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Text(
            'Baca surah, cari cepat, dan unduh mushaf per paket saat diperlukan.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.surface.withAlpha(222),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuranSearchBar extends StatelessWidget {
  const _QuranSearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Cari surah...',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: const BorderSide(color: AppColors.softBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: const BorderSide(color: AppColors.softBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: const BorderSide(color: AppColors.tealGreen, width: 1.2),
        ),
      ),
    );
  }
}

class _QuickAccessChips extends StatelessWidget {
  const _QuickAccessChips({required this.items, required this.onSelected});

  final List<_SurahDisplayItem> items;
  final ValueChanged<_SurahDisplayItem> onSelected;

  @override
  Widget build(BuildContext context) {
    const names = ['Al-Kahf', 'Yaseen', 'Al-Mulk', 'Ar-Rahmaan', 'Al-Waaqia'];
    final quickItems = <_SurahDisplayItem>[];

    for (final name in names) {
      for (final item in items) {
        if (item.englishName == name) {
          quickItems.add(item);
          break;
        }
      }
    }

    if (quickItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akses cepat',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.mutedEmerald,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: quickItems.map((item) {
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ActionChip(
                  label: Text(item.englishName),
                  avatar: const Icon(Icons.auto_stories_rounded, size: 16),
                  onPressed: () => onSelected(item),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.softBorder),
                  labelStyle: const TextStyle(color: AppColors.deepEmerald),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DownloadStatusBanner extends StatelessWidget {
  const _DownloadStatusBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: AppColors.limeGold.withAlpha(70),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: const Icon(
                  Icons.cloud_download_rounded,
                  color: AppColors.deepEmerald,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Mushaf bisa diunduh per paket. Buka surah atau kelola unduhan untuk memilih paket.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.deepEmerald,
                    height: 1.3,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.deepEmerald,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahListCard extends StatelessWidget {
  const _SurahListCard({
    required this.items,
    required this.isEnglish,
    required this.onTap,
  });

  final List<_SurahDisplayItem> items;
  final bool isEnglish;
  final ValueChanged<_SurahDisplayItem> onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: AppColors.softBorder),
          ),
          child: Column(
            children: [
              const Icon(Icons.search_off_rounded, color: AppColors.tealGreen),
              SizedBox(height: 8.h),
              Text(
                'Surah tidak ditemukan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.deepEmerald,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final itemIndex = index ~/ 2;
        if (index.isOdd) return SizedBox(height: 8.h);

        return _SurahRow(
          item: items[itemIndex],
          isEnglish: isEnglish,
          onTap: () => onTap(items[itemIndex]),
        );
      }, childCount: items.length * 2 - 1),
    );
  }
}

class _SurahRow extends StatelessWidget {
  const _SurahRow({
    required this.item,
    required this.isEnglish,
    required this.onTap,
  });

  final _SurahDisplayItem item;
  final bool isEnglish;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryName = isEnglish ? item.englishName : item.name;
    final secondaryName = isEnglish ? item.name : item.englishName;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.softBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.limeGold.withAlpha(55),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.limeGold.withAlpha(120)),
                ),
                child: Text(
                  item.number.toString(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.deepEmerald,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      primaryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.deepEmerald,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Halaman ${item.pageNo} - $secondaryName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedEmerald,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 112.w,
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  textDirection: ui.TextDirection.rtl,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.deepEmerald,
                    fontFamily: FontConstants.meQuranFontFamily,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
