import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:islamic/app/resources/resources.dart';
import 'package:islamic/presentation/components/glass_container.dart';

/// Displays a countdown card for the next prayer time with glassmorphism effect.
///
/// Features:
/// - Horizontal layout with icon, prayer info, and countdown
/// - Glassmorphism background (white/40 with blur)
/// - Live countdown timer that updates every second
class PrayerCountdownCard extends StatefulWidget {
  final String? prayerName;
  final String? prayerTime;
  final Duration? timeUntilPrayer;

  const PrayerCountdownCard({
    Key? key,
    this.prayerName = 'Dzuhur',
    this.prayerTime = '12:05',
    this.timeUntilPrayer,
  }) : super(key: key);

  @override
  State<PrayerCountdownCard> createState() => _PrayerCountdownCardState();
}

class _PrayerCountdownCardState extends State<PrayerCountdownCard> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.timeUntilPrayer ?? Duration(hours: 2, minutes: 45, seconds: 12);
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
          } else {
            _remainingTime = Duration(hours: 0, minutes: 0, seconds: 0);
          }
        });
      }
    });
  }

  String _formatCountdown(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '-$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p24.w,
        vertical: AppPadding.p8.h,
      ),
      child: GlassContainer(
        borderRadius: 24.r,
        padding: EdgeInsets.all(AppPadding.p16.w),
        blur: 20.0,
        opacity: 0.4,
        child: Row(
          children: [
            // Left: Prayer icon in teal container
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.islamicTeal,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.islamicTeal.withAlpha(102), // 0.4 * 255
                    blurRadius: 8.r,
                    offset: Offset(0, 4.r),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Symbols.wb_twilight,
                  color: Colors.white,
                  size: 22.r,
                ),
              ),
            ),
            SizedBox(width: AppSize.s12.w),

            // Center: Prayer name and time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BERIKUTNYA: ${widget.prayerName?.toUpperCase() ?? 'DZUHUR'}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeightsManager.bold,
                      color: Colors.grey.shade700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: AppSize.s4.h),
                  Text(
                    widget.prayerTime ?? '12:05',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeightsManager.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),

            // Right: Countdown with divider
            Container(
              padding: EdgeInsets.only(left: AppPadding.p16.w),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.black.withAlpha(13), // 0.05 * 255
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'SISA WAKTU',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeightsManager.bold,
                      color: Colors.grey.shade700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: AppSize.s4.h),
                  Text(
                    _formatCountdown(_remainingTime),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeightsManager.bold,
                      color: AppColors.islamicTeal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
