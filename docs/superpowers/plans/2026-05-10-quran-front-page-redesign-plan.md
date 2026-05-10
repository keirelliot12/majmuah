# Quran Front Page Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign only the Al-Quran front/list page so it feels polished, mobile-first, and aligned with the existing Annibros brand while preserving the current per-package Quran download flow.

**Architecture:** Keep the existing `QuranScreen` state, `DownloadCubit`, and route-to-reader logic intact. Replace the plain table-style list with a branded header, search/filter field, quick access chips, download status banner, and card-like surah rows inside the same screen file to keep this small and reversible.

**Tech Stack:** Flutter, Bloc, Easy Localization, Flutter ScreenUtil, existing Annibros `AppColors`, existing Quran/download models and routes.

---

## Scope

In scope:
- Redesign the Al-Quran tab/front page only.
- Use Annibros brand colors already defined in `AppColors`: `deepEmerald`, `emerald`, `tealGreen`, `limeGold`, `background`, `surface`, `surfaceMuted`, and `softBorder`.
- Preserve current Quran reader route: `Routes.quranRoute`.
- Preserve current download behavior:
  - List remains visible even when mushaf packages are not downloaded.
  - Initial prompt may still appear and can be dismissed.
  - Tapping a surah whose page package is missing prompts download for the required package.
  - Download manager route remains `Routes.downloadManagerRoute`.
- Add local surah search/filter on this front page.

Out of scope:
- Redesign Quran reader/page view.
- Implement Juz or Page tab browsing.
- Add new bitmap icons.
- Change Quran asset package URLs.
- Change bottom navigation, drawer, or global app bar behavior.

## File Structure

- Modify: `lib/presentation/home/screens/quran/view/quran_screen.dart`
  - Owns the full redesigned front page UI.
  - Keeps `DownloadCubit` listener and existing tap/download routing logic.
  - Adds a local `TextEditingController` and filter state.
  - Adds focused private widgets/helpers inside the same file:
    - `_QuranHeaderCard`
    - `_QuranSearchBar`
    - `_QuickAccessChips`
    - `_DownloadStatusBanner`
    - `_SurahListCard`
    - `_SurahRow`
    - `_SurahDisplayItem`

No new production files are needed for this slice.

## Task 1: Add Local Search State and Display Model

**Files:**
- Modify: `lib/presentation/home/screens/quran/view/quran_screen.dart`

- [ ] **Step 1: Add state fields and dispose**

Add these fields inside `_QuranScreenState`:

```dart
final TextEditingController _searchController = TextEditingController();
String _query = '';
```

Add this method inside `_QuranScreenState`:

```dart
@override
void dispose() {
  _searchController.dispose();
  super.dispose();
}
```

- [ ] **Step 2: Add a private display model**

Add this class after `_QuranScreenState`:

```dart
class _SurahDisplayItem {
  const _SurahDisplayItem({
    required this.number,
    required this.name,
    required this.englishName,
    required this.pageNo,
    required this.model,
  });

  final int number;
  final String name;
  final String englishName;
  final int pageNo;
  final QuranModel model;
}
```

- [ ] **Step 3: Add filter helpers**

Add these methods inside `_QuranScreenState`:

```dart
List<_SurahDisplayItem> _buildDisplayItems(List<QuranModel> quranList) {
  return List<_SurahDisplayItem>.generate(quranList.length, (index) {
    final model = quranList[index];
    return _SurahDisplayItem(
      number: index + 1,
      name: model.name,
      englishName: model.englishName,
      pageNo: model.ayahs.first.page,
      model: model,
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
```

- [ ] **Step 4: Run analyzer for early syntax check**

Run:

```powershell
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib\presentation\home\screens\quran\view\quran_screen.dart
```

Expected: either `No issues found!` or only pre-existing project-wide warnings outside this file. Fix any new syntax/type issue in `quran_screen.dart` before continuing.

## Task 2: Replace Plain Table With Branded Page Layout

**Files:**
- Modify: `lib/presentation/home/screens/quran/view/quran_screen.dart`

- [ ] **Step 1: Replace the current `Column` in the loaded builder**

Inside `ConditionalBuilder.builder`, replace the current `Column` containing `ListTile` and `ListView.separated` with:

```dart
final allItems = _buildDisplayItems(quranList);
final visibleItems = _filterItems(allItems);

return CustomScrollView(
  physics: const BouncingScrollPhysics(),
  slivers: [
    SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 10.h),
      sliver: SliverToBoxAdapter(
        child: _QuranHeaderCard(
          totalSurah: allItems.length,
          isDownloaded: isDownloaded,
          onManageDownload: () {
            Navigator.pushNamed(context, Routes.downloadManagerRoute);
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
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 96.h),
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
);
```

- [ ] **Step 2: Extract tap logic from `_surahsIndexItem`**

Add this method inside `_QuranScreenState`:

```dart
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
```

- [ ] **Step 3: Remove `_surahsIndexItem` after all callers are gone**

Delete the old `_surahsIndexItem` method. The new UI must call `_openSurahItem` instead.

- [ ] **Step 4: Run analyzer**

Run:

```powershell
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib\presentation\home\screens\quran\view\quran_screen.dart
```

Expected: no new issues from `quran_screen.dart`.

## Task 3: Add Header, Search, Quick Access, Banner, and Surah Card Widgets

**Files:**
- Modify: `lib/presentation/home/screens/quran/view/quran_screen.dart`

- [ ] **Step 1: Add `_QuranHeaderCard`**

Add this widget after `_SurahDisplayItem`:

```dart
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
        color: AppColors.deepEmerald,
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
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
```

- [ ] **Step 2: Add `_QuranSearchBar`**

Add:

```dart
class _QuranSearchBar extends StatelessWidget {
  const _QuranSearchBar({
    required this.controller,
    required this.onChanged,
  });

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
          borderSide: const BorderSide(
            color: AppColors.tealGreen,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Add `_QuickAccessChips`**

Add:

```dart
class _QuickAccessChips extends StatelessWidget {
  const _QuickAccessChips({
    required this.items,
    required this.onSelected,
  });

  final List<_SurahDisplayItem> items;
  final ValueChanged<_SurahDisplayItem> onSelected;

  @override
  Widget build(BuildContext context) {
    const names = ['Al-Kahf', 'Yaseen', 'Al-Mulk', 'Ar-Rahmaan', 'Al-Waaqia'];
    final quickItems = names
        .map(
          (name) => items.where((item) => item.englishName == name).firstOrNull,
        )
        .whereType<_SurahDisplayItem>()
        .toList();

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
```

If the Dart SDK in this repo does not support `Iterable.firstOrNull`, replace the mapping block with a small local loop:

```dart
final quickItems = <_SurahDisplayItem>[];
for (final name in names) {
  for (final item in items) {
    if (item.englishName == name) {
      quickItems.add(item);
      break;
    }
  }
}
```

- [ ] **Step 4: Add `_DownloadStatusBanner`**

Add:

```dart
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
              const Icon(Icons.chevron_right_rounded, color: AppColors.deepEmerald),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Add `_SurahListCard` and `_SurahRow`**

Add:

```dart
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

    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        return _SurahRow(
          item: items[index],
          isEnglish: isEnglish,
          onTap: () => onTap(items[index]),
        );
      },
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
                      'Halaman ${item.pageNo} • $secondaryName',
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
              Flexible(
                flex: 0,
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
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
```

- [ ] **Step 6: If `SliverList.separated` is not available**

Use this compatible replacement inside `_SurahListCard.build`:

```dart
return SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      final itemIndex = index ~/ 2;
      if (index.isOdd) return SizedBox(height: 8.h);
      return _SurahRow(
        item: items[itemIndex],
        isEnglish: isEnglish,
        onTap: () => onTap(items[itemIndex]),
      );
    },
    childCount: items.length * 2 - 1,
  ),
);
```

## Task 4: Format and Verify the Redesign

**Files:**
- Verify: `lib/presentation/home/screens/quran/view/quran_screen.dart`

- [ ] **Step 1: Format the changed file**

Run:

```powershell
dart format lib\presentation\home\screens\quran\view\quran_screen.dart
```

Expected: formatter completes successfully and reports one formatted file or no changes.

- [ ] **Step 2: Analyze the changed file**

Run:

```powershell
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib\presentation\home\screens\quran\view\quran_screen.dart
```

Expected: no new analyzer errors.

- [ ] **Step 3: Build web**

Run:

```powershell
flutter build web --no-wasm-dry-run
```

Expected: build succeeds.

- [ ] **Step 4: Browser verification in mobile viewport**

Open the current local app URL, for example:

```text
http://localhost:8797/
```

Verify:
- Al-Quran tab list page shows the new branded header.
- Colors read as Annibros green/lime/off-white, not blue/cyan from the random reference screenshot.
- Search filters by surah number, Arabic name, and English/Latin name.
- Quick access chips open the same download/read flow as a normal surah row.
- If Quran package is missing, list still remains visible and tapping a surah prompts download for the relevant package.
- Bottom navigation remains visible.
- Reader page is unchanged.

## Self-Review

- Spec coverage: The plan targets only the Al-Quran front/list page, follows Annibros colors, preserves download flow, and avoids reader/page-view changes.
- Placeholder scan: No task relies on vague deferred-work steps. Compatibility fallbacks are explicit.
- Type consistency: `_SurahDisplayItem`, `_openSurahItem`, and all widget constructor signatures match the usage in Task 2.
- Risk note: `firstOrNull` and `SliverList.separated` may depend on SDK/framework versions, so the plan includes direct fallback code for both.
