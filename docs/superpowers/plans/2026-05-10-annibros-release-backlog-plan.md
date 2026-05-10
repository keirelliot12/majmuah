# Annibros Release Backlog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Merge the remaining release work into one executable backlog, including restoring Khutbah as API-backed content and making Mutiara Hikmah API-backed while keeping the rest of the reading materials static.

**Architecture:** Static devotional materials continue to load from bundled JSON. Only two content surfaces become dynamic: `Khutbah` list/detail and dashboard `Mutiara Hikmah`, both with cache/fallback so the app remains useful offline. Existing dashboard, material list/detail, Quran download, and reading settings flows stay intact.

**Tech Stack:** Flutter, Bloc/Cubit where already used, Dio/Retrofit pattern where needed, SharedPreferences/local cache for remote content fallback, bundled JSON for static material, existing Annibros theme/components.

---

## Current Decision Record

- KBIHU stays on dashboard only; do not promote it in drawer.
- KBIHU replaced the old Notes dashboard position.
- Notes, Hadits Nawawi, and Rukun Islam remain removed from user-facing navigation.
- Khutbah was not explicitly removed by product decision. It should return as dynamic/API-backed content.
- Mutiara Hikmah should also become dynamic/API-backed content.
- All other content remains static from `assets/json/Annibros.json` and `assets/json/category.json`.

## File Structure

### Dynamic Content Layer

- Create: `lib/domain/models/remote_content/khutbah_item.dart`
  - Remote Khutbah DTO/domain model.
- Create: `lib/domain/models/remote_content/wisdom_quote.dart`
  - Remote Mutiara Hikmah model.
- Create: `lib/data/data_source/remote/annibros_content_api.dart`
  - API client for remote Khutbah and Mutiara Hikmah.
- Create: `lib/data/data_source/local/remote_content_cache.dart`
  - Cache last successful remote Khutbah and Mutiara Hikmah payloads.
- Create: `lib/data/repository/remote_content_repository.dart`
  - Fetch remote content, fallback to cache, then fallback to bundled defaults.

### Khutbah UI

- Modify: `assets/json/category.json`
  - Add `Khutbah` category back.
- Modify: `lib/presentation/home/widgets/menu_grid_widget.dart`
  - Add Khutbah if dashboard grid capacity/design allows, or keep it under Lainnya if grid should stay 8 items.
- Modify: `lib/presentation/home/view/home_view.dart`
  - Route Khutbah tap to the dynamic Khutbah screen or material list wrapper.
- Modify: `lib/presentation/home/screens/all_categories/all_categories_screen.dart`
  - Ensure Khutbah appears if not placed in dashboard grid.
- Create: `lib/presentation/khutbah/khutbah_list_screen.dart`
  - Remote-backed list of Khutbah.
- Create: `lib/presentation/khutbah/khutbah_detail_screen.dart`
  - Reader-style Khutbah detail with same typography comfort rules.

### Mutiara Hikmah UI

- Modify: `lib/presentation/home/widgets/wisdom_quote_card.dart`
  - Accept loading/error/quote state or become a small Bloc/Cubit consumer.
- Create: `lib/presentation/home/cubit/wisdom_quote_cubit.dart`
  - Load daily/latest wisdom quote from repository.
- Create: `lib/presentation/home/cubit/wisdom_quote_state.dart`
  - Loading, loaded, error-with-fallback states.
- Modify: `lib/presentation/home/view/home_view.dart`
  - Provide/load wisdom quote state.

### Polish / Verification

- Modify: `README.md`
  - Update Maulid status, Khutbah/Mutiara API decision, and remaining backlog.
- Modify: `docs/annibros-release-checkpoint.md`
  - Add this decision and current backlog.
- Modify: `docs/release-smoke-test.md`
  - Add Khutbah and Mutiara Hikmah smoke steps.

## Task 1: Restore Khutbah as a Category

**Files:**
- Modify: `assets/json/category.json`
- Modify: `lib/presentation/home/helpers/category_visuals.dart`
- Modify: `docs/release-smoke-test.md`

- [ ] **Step 1: Add Khutbah category to bundled categories**

Add this object to `assets/json/category.json` after `Kaifiyah` or before `Maulid`:

```json
{
  "id": 10,
  "title": "Khutbah",
  "icon_asset": "assets/icons/khutbah.png",
  "route": "/category",
  "filter_key": "Khutbah",
  "color_hex": "E11D48"
}
```

Then renumber following IDs if the UI depends on ordering. Keep `KBIHU Nur Multazam` present.

- [ ] **Step 2: Keep Khutbah visual mapping**

`lib/presentation/home/helpers/category_visuals.dart` already has:

```dart
case 'khutbah':
  return const CategoryVisual(
    icon: Symbols.record_voice_over,
    color: AppColors.rose500,
  );
```

Verify it remains present. If missing, restore exactly that mapping.

- [ ] **Step 3: Add smoke checklist**

Add to `docs/release-smoke-test.md`:

```markdown
- [ ] Khutbah category is visible from Lainnya or dashboard.
- [ ] Khutbah list loads from API when online.
- [ ] Khutbah list falls back to cached/default content when offline.
- [ ] Khutbah detail opens and uses readable paragraph styling.
```

## Task 2: Add Remote Content Models and Cache

**Files:**
- Create: `lib/domain/models/remote_content/khutbah_item.dart`
- Create: `lib/domain/models/remote_content/wisdom_quote.dart`
- Create: `lib/data/data_source/local/remote_content_cache.dart`

- [ ] **Step 1: Create Khutbah model**

```dart
class KhutbahItem {
  const KhutbahItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String> content;
  final DateTime? publishedAt;

  factory KhutbahItem.fromJson(Map<String, dynamic> json) {
    return KhutbahItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      content: (json['content'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      publishedAt: DateTime.tryParse(json['published_at'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'content': content,
        'published_at': publishedAt?.toIso8601String(),
      };
}
```

- [ ] **Step 2: Create Wisdom model**

```dart
class WisdomQuote {
  const WisdomQuote({
    required this.id,
    required this.text,
    required this.source,
    required this.publishedAt,
  });

  final String id;
  final String text;
  final String source;
  final DateTime? publishedAt;

  factory WisdomQuote.fromJson(Map<String, dynamic> json) {
    return WisdomQuote(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      source: json['source'] as String? ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'source': source,
        'published_at': publishedAt?.toIso8601String(),
      };
}
```

- [ ] **Step 3: Create cache helper**

Use `SharedPreferences` or the app's existing local storage pattern. Required methods:

```dart
Future<void> saveKhutbahItems(List<KhutbahItem> items);
Future<List<KhutbahItem>> getKhutbahItems();
Future<void> saveWisdomQuote(WisdomQuote quote);
Future<WisdomQuote?> getWisdomQuote();
```

Cache payload as JSON strings. Return empty/null on corrupt cache, not throw.

## Task 3: Add Remote API Repository With Fallback

**Files:**
- Create: `lib/data/data_source/remote/annibros_content_api.dart`
- Create: `lib/data/repository/remote_content_repository.dart`
- Modify: `lib/app/utils/constants.dart`

- [ ] **Step 1: Add API base URL constant**

Add a placeholder constant that can be changed later:

```dart
static const String annibrosContentBaseUrl = String.fromEnvironment(
  'ANNIBROS_CONTENT_BASE_URL',
  defaultValue: 'https://example.com/api/annibros',
);
```

- [ ] **Step 2: Create API methods**

Implement API methods with Dio or the repo's existing network pattern:

```dart
Future<List<KhutbahItem>> fetchKhutbahItems();
Future<WisdomQuote> fetchLatestWisdomQuote();
```

Expected endpoints:

```text
GET /khutbah
GET /wisdom/latest
```

Expected JSON:

```json
{
  "data": []
}
```

For wisdom:

```json
{
  "data": {
    "id": "wisdom-001",
    "text": "Isi mutiara hikmah",
    "source": "Annibros",
    "published_at": "2026-05-10T00:00:00Z"
  }
}
```

- [ ] **Step 3: Repository fallback order**

For Khutbah:

```text
API success -> save cache -> return API data
API fail -> return cache if not empty
cache empty -> return bundled fallback sample
```

For Mutiara Hikmah:

```text
API success -> save cache -> return API data
API fail -> return cached quote
cache empty -> return default quote currently shown in WisdomQuoteCard
```

## Task 4: Wire Mutiara Hikmah to API

**Files:**
- Create: `lib/presentation/home/cubit/wisdom_quote_cubit.dart`
- Create: `lib/presentation/home/cubit/wisdom_quote_state.dart`
- Modify: `lib/presentation/home/widgets/wisdom_quote_card.dart`
- Modify: `lib/presentation/home/view/home_view.dart`

- [ ] **Step 1: Create states**

States:

```dart
sealed class WisdomQuoteState {}
class WisdomQuoteInitial extends WisdomQuoteState {}
class WisdomQuoteLoading extends WisdomQuoteState {}
class WisdomQuoteLoaded extends WisdomQuoteState {
  WisdomQuoteLoaded(this.quote, {required this.isFallback});
  final WisdomQuote quote;
  final bool isFallback;
}
class WisdomQuoteError extends WisdomQuoteState {
  WisdomQuoteError(this.message);
  final String message;
}
```

- [ ] **Step 2: Create cubit**

Cubit loads `RemoteContentRepository.getLatestWisdomQuote()` on dashboard start.

- [ ] **Step 3: Update card**

`WisdomQuoteCard` should still render the same visual design, but quote text comes from state. On loading, show a short skeleton/placeholder. On error, show fallback default quote.

- [ ] **Step 4: Verify**

Run:

```powershell
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings lib\presentation\home\widgets\wisdom_quote_card.dart lib\presentation\home\view\home_view.dart
```

## Task 5: Wire Khutbah List and Detail

**Files:**
- Create: `lib/presentation/khutbah/khutbah_list_screen.dart`
- Create: `lib/presentation/khutbah/khutbah_detail_screen.dart`
- Modify: `lib/app/resources/routes_manager.dart`
- Modify: `lib/presentation/home/view/home_view.dart`
- Modify: `lib/presentation/home/screens/all_categories/all_categories_screen.dart`

- [ ] **Step 1: Add routes**

Add:

```dart
static const String khutbahListRoute = "/khutbah";
static const String khutbahDetailRoute = "/khutbah/detail";
```

- [ ] **Step 2: Create Khutbah list screen**

List requirements:
- Uses Annibros styling.
- Shows title, subtitle, publish date.
- Loading state.
- Empty state.
- Offline/fallback badge if repository returns fallback/cached data.

- [ ] **Step 3: Create Khutbah detail screen**

Detail requirements:
- Uses same reading comfort principles: justified Indonesian text, paragraph spacing, no copy button.
- No Arabic-specific RTL assumption unless content contains Arabic.
- Back button works.

- [ ] **Step 4: Wire menu**

Preferred placement:
- Put `Khutbah` under `Lainnya` first to avoid crowding dashboard.
- If user later wants dashboard tile, add it after visual review.

## Task 6: Preserve Static Content Boundaries

**Files:**
- Modify only if needed: `lib/data/data_source/remote/material_data_source.dart`
- Modify only if needed: `lib/data/repository/material_content_repository.dart`

- [ ] **Step 1: Do not convert existing static categories to API**

Keep these bundled/static:

```text
Aurad & Doa'
Hizib & Ratib
Puji-pujian & Bilal
Amalan Hijriyah
Tahlil & Ziarah
Qosidah Pilihan
Sholawat
Kaifiyah
Maulid
KBIHU Nur Multazam
```

- [ ] **Step 2: Ensure search behavior is clear**

Search can remain static-only for now. If remote Khutbah must appear in global search later, implement as a separate follow-up, not inside this slice.

## Task 7: Remaining Release Polish

**Files:**
- Modify: `assets/images/icons/`
- Modify: `README.md`
- Modify: `docs/annibros-release-checkpoint.md`
- Modify: `docs/release-smoke-test.md`

- [ ] **Step 1: Bitmap icon custom**

Generate/replace final icons for:

```text
Aurad & Doa
Hizib & Ratib
Puji & Bilal
Amalan Hijriyah
Maulid
Tahlil & Ziarah
KBIHU
Lainnya
Khutbah
```

- [ ] **Step 2: Android smoke**

Run later:

```powershell
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug
```

- [ ] **Step 3: Manual page audit**

Audit:

```text
Dashboard
Al-Quran front page
Al-Quran download manager
Material list
Material detail
Maulid detail translation toggle
Khutbah list/detail
KBIHU list/detail
Settings
Prayer times
Search
```

## Verification Before Completion

Run:

```powershell
dart format lib\data lib\domain lib\presentation docs
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings
flutter build web --no-wasm-dry-run
```

Then verify in browser mobile viewport:

```text
http://127.0.0.1:<active-port>/
```

Checklist:
- Khutbah visible from agreed navigation.
- Khutbah API fallback works.
- Mutiara Hikmah displays remote/cached/default quote.
- Existing static categories still load from bundled JSON.
- KBIHU still dashboard-only.
- No Notes/Hadits Nawawi/Rukun Islam user-facing menu returns.

## Self-Review

- Spec coverage: Adds Khutbah back as dynamic content, makes Mutiara Hikmah dynamic, preserves static content for everything else, and carries remaining release polish.
- Scope control: KBIHU remains dashboard-only and is not used to replace Khutbah.
- Risk: API contract is still placeholder. Before implementation, confirm final base URL and JSON shape or implement with configurable mock/fallback first.
