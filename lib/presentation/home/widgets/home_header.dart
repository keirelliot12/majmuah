import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:annibros/app/resources/resources.dart';
import 'package:annibros/app/utils/constants.dart';
import 'package:annibros/presentation/home/cubit/home_cubit.dart';
import 'package:annibros/presentation/home/screens/prayer_times/cubit/prayer_timings_cubit.dart';
import '../../components/app_brand_logo.dart';

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
      padding: EdgeInsets.fromLTRB(22.0.w, 14.0.h, 22.0.w, 10.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Location and Date
          Expanded(
            child: Column(
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
                          color: AppColors.lemonYellow.withAlpha(230),
                          size: 16.0.r,
                        ),
                        SizedBox(width: 4.0.w),
                        Flexible(
                          child: Text(
                            locationText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.white.withAlpha(238),
                                  fontWeight: FontWeightsManager.bold,
                                  fontSize: 12.0.sp,
                                  letterSpacing: 0,
                                ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 4.0.h),

                BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
                  builder: (context, state) {
                    final cubit = PrayerTimingsCubit.get(context);
                    final date = cubit.prayerTimingsModel.data?.date;
                    final hijri = date?.hijri;
                    final hijriText = hijri == null
                        ? 'Kalender Hijriyah memuat...'
                        : '${hijri.day} ${hijri.month?.en ?? ''} ${hijri.year} H';
                    final gregorianText = _formatGregorianDate();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hijriText,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.limeGold.withAlpha(230),
                                fontWeight: FontWeightsManager.bold,
                                fontSize: 12.0.sp,
                              ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          gregorianText,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.white.withAlpha(194),
                                fontWeight: FontWeightsManager.medium,
                                fontSize: 12.0.sp,
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),
          const AppBrandLogo(size: 48),
        ],
      ),
    );
  }

  String _formatGregorianDate() {
    final now = DateTime.now();
    const dayNames = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Ahad',
    ];
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${dayNames[now.weekday - 1]}, ${now.day} ${monthNames[now.month - 1]} ${now.year}';
  }
}
