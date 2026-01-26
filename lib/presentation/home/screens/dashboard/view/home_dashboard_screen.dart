import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic/app/utils/extensions.dart';

import '../../../../../app/resources/resources.dart';
import '../../../../../app/utils/custom_search.dart';
import '../../../../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../prayer_times/cubit/prayer_timings_cubit.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
      builder: (context, state) {
        PrayerTimingsCubit cubit = PrayerTimingsCubit.get(context);
        PrayerTimingsModel prayerTimingsModel = cubit.prayerTimingsModel;
        final currentLocale = context.locale;
        bool isEnglish =
            currentLocale.languageCode == LanguageType.english.getValue();

        return CustomScrollView(
          slivers: [
            // Header with Prayer Times
            SliverToBoxAdapter(
              child: _HomeHeader(
                prayerTimingsModel: prayerTimingsModel,
                isEnglish: isEnglish,
              ),
            ),

            // Search Bar (overlapping)
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: const _SearchBarWidget(),
              ),
            ),

            // Menu Grid
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppPadding.p16.w,
                0,
                AppPadding.p16.w,
                AppPadding.p16.h,
              ),
              sliver: const _MenuGrid(),
            ),
          ],
        );
      },
    );
  }
}

// ==================== HOME HEADER WIDGET ====================
class _HomeHeader extends StatelessWidget {
  final PrayerTimingsModel prayerTimingsModel;
  final bool isEnglish;

  const _HomeHeader({
    required this.prayerTimingsModel,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.30,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8D76E), // Yellow
            Color(0xFFC8CF7E), // Yellow-green
            Color(0xFF90A88E), // Sage green
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p20.w,
            vertical: AppPadding.p16.h,
          ),
          child: prayerTimingsModel.code != 200
              ? _buildLoadingContent(context)
              : _buildPrayerContent(context),
        ),
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.gettingLocation.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: AppSize.s16.h),
          SizedBox(
            width: AppSize.s200.w,
            child: LinearProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.white.withAlpha(76),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dates Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnglish
                      ? prayerTimingsModel.data!.date!.gregorian!.weekday!.en
                      : prayerTimingsModel.data!.date!.hijri!.weekday!.ar,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: AppSize.s4.h),
                Text(
                  isEnglish
                      ? "${prayerTimingsModel.data!.date!.hijri!.day} ${prayerTimingsModel.data!.date!.hijri!.month!.en} ${prayerTimingsModel.data!.date!.hijri!.year}"
                      : "${prayerTimingsModel.data!.date!.hijri!.day} ${prayerTimingsModel.data!.date!.hijri!.month!.ar} ${prayerTimingsModel.data!.date!.hijri!.year}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ],
            ),
            Text(
              prayerTimingsModel.data!.date!.gregorian!.date,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
            ),
          ],
        ),

        const Spacer(),

        // Prayer Times Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _PrayerTimeCard(
              name: isEnglish ? "FAJR" : "الفجر",
              time: prayerTimingsModel.data!.timings!.fajr
                  .convertTo12HourFormat(),
              icon: Icons.nightlight_round,
            ),
            _PrayerTimeCard(
              name: isEnglish ? "DHUHR" : "الظهر",
              time: prayerTimingsModel.data!.timings!.dhuhr
                  .convertTo12HourFormat(),
              icon: Icons.wb_sunny,
            ),
          ],
        ),

        SizedBox(height: AppSize.s40.h),
      ],
    );
  }
}

// Prayer Time Card Component
class _PrayerTimeCard extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;

  const _PrayerTimeCard({
    required this.name,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p20.w,
        vertical: AppPadding.p12.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(204),
        borderRadius: BorderRadius.circular(AppSize.s12.r),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF5A7C6B),
            size: AppSize.s24.r,
          ),
          SizedBox(height: AppSize.s8.h),
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: AppSize.s4.h),
          Text(
            time,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s18,
                ),
          ),
        ],
      ),
    );
  }
}

// ==================== SEARCH BAR WIDGET ====================
class _SearchBarWidget extends StatelessWidget {
  const _SearchBarWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p20.w),
      child: GestureDetector(
        onTap: () {
          showSearch(context: context, delegate: CustomSearch());
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p20.w,
            vertical: AppPadding.p16.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(38),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: const Color(0xFF90A88E),
                size: AppSize.s24.r,
              ),
              SizedBox(width: AppSize.s12.w),
              Expanded(
                child: Text(
                  AppStrings.searchWordOrAyat.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black38,
                      ),
                ),
              ),
              Icon(
                Icons.mic,
                color: Colors.black38,
                size: AppSize.s20.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== MENU GRID WIDGET ====================
class _MenuGrid extends StatelessWidget {
  const _MenuGrid();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'name': 'Aurad Shalat',
        'icon': Icons.auto_stories_outlined,
        'color': const Color(0xFF5A8C6B),
      },
      {
        'name': 'Doa & Tawasul',
        'icon': Icons.pan_tool_outlined,
        'color': const Color(0xFFD4945F),
      },
      {
        'name': 'Ratib',
        'icon': Icons.menu_book_outlined,
        'color': const Color(0xFF90A88E),
      },
      {
        'name': 'Khutbah',
        'icon': Icons.record_voice_over_outlined,
        'color': const Color(0xFFE8A05D),
      },
      {
        'name': 'Maulid',
        'icon': Icons.celebration_outlined,
        'color': const Color(0xFF8B7355),
      },
      {
        'name': 'Tahlil & Ziarah',
        'icon': Icons.mosque_outlined,
        'color': const Color(0xFF6B8E7D),
      },
      {
        'name': 'Notes',
        'icon': Icons.note_outlined,
        'color': const Color(0xFFB8906D),
      },
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // First 6 items in 2-column grid
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSize.s16.w,
                mainAxisSpacing: AppSize.s16.h,
                childAspectRatio: 1.0,
              ),
              itemCount: 6,
              itemBuilder: (context, gridIndex) {
                return _MenuCard(
                  name: menuItems[gridIndex]['name'] as String,
                  icon: menuItems[gridIndex]['icon'] as IconData,
                  color: menuItems[gridIndex]['color'] as Color,
                  onTap: () => _handleMenuTap(context, gridIndex),
                );
              },
            );
          } else if (index == 1) {
            // 7th item (Notes) - Full width
            return Padding(
              padding: EdgeInsets.only(top: AppSize.s16.h),
              child: _MenuCard(
                name: menuItems[6]['name'] as String,
                icon: menuItems[6]['icon'] as IconData,
                color: menuItems[6]['color'] as Color,
                isFullWidth: true,
                onTap: () => _handleMenuTap(context, 6),
              ),
            );
          }
          return null;
        },
        childCount: 2,
      ),
    );
  }

  void _handleMenuTap(BuildContext context, int index) {
    final menuNames = [
      'Aurad Shalat',
      'Doa & Tawasul',
      'Ratib',
      'Khutbah',
      'Maulid',
      'Tahlil & Ziarah',
      'Notes',
    ];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menuNames[index]} clicked'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

// ==================== MENU CARD WIDGET ====================
class _MenuCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isFullWidth;
  final VoidCallback onTap;

  const _MenuCard({
    required this.name,
    required this.icon,
    required this.color,
    this.isFullWidth = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isFullWidth ? AppSize.s100.h : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.s16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isFullWidth
            ? _buildFullWidthContent(context)
            : _buildGridContent(context),
      ),
    );
  }

  Widget _buildGridContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(AppPadding.p16.w),
          decoration: BoxDecoration(
            color: color.withAlpha(51),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppSize.s40.r,
            color: color,
          ),
        ),
        SizedBox(height: AppSize.s12.h),
        Text(
          name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: FontSize.s14,
              ),
        ),
      ],
    );
  }

  Widget _buildFullWidthContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p20.w,
        vertical: AppPadding.p16.h,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppPadding.p12.w),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppSize.s35.r,
              color: color,
            ),
          ),
          SizedBox(width: AppPadding.p16.w),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black38,
            size: AppSize.s20.r,
          ),
        ],
      ),
    );
  }
}
