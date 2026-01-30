import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:islamic/app/resources/resources.dart';

/// Displays the header section of the home page with location, date, and notification bell.
///
/// Shows:
/// - Location icon + current location text (left top)
/// - Hijri date below location
/// - Notification bell icon with glassmorphism (right)
///
/// Responsive layout adapts to different screen sizes.
class HomeHeader extends StatefulWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late String _hijriDate;
  late String _dayName;

  @override
  void initState() {
    super.initState();
    _updateDates();
  }

  void _updateDates() {
    // Get current day name in Indonesian
    final now = DateTime.now();
    final List<String> dayNames = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Ahad'
    ];
    _dayName = dayNames[now.weekday - 1];

    // Hijri date placeholder - format: "13 Rajab 1445 H"
    _hijriDate = '13 Rajab 1445 H';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p24.w,
        vertical: AppPadding.p16.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Location and Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.location_on,
                    color: Colors.grey.shade800,
                    size: AppSize.s16.r,
                  ),
                  SizedBox(width: AppSize.s4.w),
                  Text(
                    'KUDUS, INDONESIA',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeightsManager.bold,
                          fontSize: FontSize.s12,
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.s4.h),

              // Hijri Date
              Text(
                '$_dayName, $_hijriDate',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeightsManager.medium,
                      fontSize: FontSize.s12,
                    ),
              ),
            ],
          ),

          // Right: Notification Bell with glassmorphism
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(AppPadding.p10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(76),
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(color: Colors.white.withAlpha(76), width: 1),
                ),
                child: Stack(
                  children: [
                    Icon(
                      Symbols.notifications,
                      color: Colors.grey.shade800,
                      size: AppSize.s24.r,
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: AppColors.darkerTeal,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
