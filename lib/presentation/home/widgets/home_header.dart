import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:islamic/app/resources/resources.dart';
import 'package:islamic/app/utils/constants.dart';
import 'package:islamic/presentation/home/cubit/home_cubit.dart';
import 'package:islamic/presentation/home/screens/prayer_times/cubit/prayer_timings_cubit.dart';

/// Displays the header section of the home page with location, date, and notification bell.
///
/// Shows:
/// - Location icon + current location text (left top)
/// - Hijri date below location
/// - Notification bell icon with glassmorphism (right)
class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0.w,
        vertical: 16.0.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Location and Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location from constants.dart
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final String cityName = recordLocation.$1;
                  final String countryName = recordLocation.$2;

                  final locationText = cityName.isEmpty
                      ? 'MENCARI LOKASI...'
                      : '${cityName.toUpperCase()}, ${countryName.toUpperCase()}';

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.location_on,
                        color: Colors.grey.shade800,
                        size: 16.0.r,
                      ),
                      SizedBox(width: 4.0.w),
                      Text(
                        locationText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeightsManager.bold,
                              fontSize: 12.0.sp,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 4.0.h),

              // Date from PrayerTimingsCubit
              BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
                builder: (context, state) {
                  final cubit = PrayerTimingsCubit.get(context);
                  final timings = cubit.prayerTimingsModel.data;

                  String dayName = '';
                  String hijriDate = '';

                  if (timings != null && timings.date != null) {
                    final hijri = timings.date!.hijri;
                    if (hijri != null) {
                      dayName = hijri.weekday?.en ?? '';
                      hijriDate = '${hijri.day} ${hijri.month?.en} ${hijri.year} H';
                    }
                  }

                  // Fallback to local system date if API data not available
                  if (dayName.isEmpty || hijriDate.isEmpty) {
                    final now = DateTime.now();
                    final List<String> dayNames = [
                      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'
                    ];
                    final List<String> monthNames = [
                      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
                      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
                    ];
                    dayName = dayNames[now.weekday - 1];
                    hijriDate = '${now.day} ${monthNames[now.month - 1]} ${now.year}';
                  }

                  return Text(
                    '$dayName, $hijriDate',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeightsManager.medium,
                          fontSize: 12.0.sp,
                        ),
                  );
                },
              ),
            ],
          ),

          // Right: Notification Bell with glassmorphism
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(12.0.w),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(102),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withAlpha(51), width: 1),
                ),
                child: Icon(
                  Symbols.notifications,
                  color: Colors.grey.shade800,
                  size: 24.0.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
