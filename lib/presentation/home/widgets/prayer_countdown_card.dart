import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:islamic/app/resources/resources.dart';
import 'package:islamic/domain/models/prayer_timings/prayer_timings_model.dart';
import 'package:islamic/presentation/components/glass_container.dart';
import 'package:islamic/presentation/home/screens/prayer_times/cubit/prayer_timings_cubit.dart';

/// Displays a countdown card for the next prayer time with glassmorphism effect.
///
/// Features:
/// - Horizontal layout with icon, prayer info, and countdown
/// - Glassmorphism background (white/40 with blur)
/// - Live countdown timer that updates every second
class PrayerCountdownCard extends StatefulWidget {
  const PrayerCountdownCard({Key? key}) : super(key: key);

  @override
  State<PrayerCountdownCard> createState() => _PrayerCountdownCardState();
}

class _PrayerCountdownCardState extends State<PrayerCountdownCard> {
  Timer? _timer;
  String _prayerName = 'DZUHUR';
  String _prayerTime = '12:05';
  Duration _remainingTime = const Duration(hours: 2, minutes: 45, seconds: 12);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
          } else {
            // Refresh timings if countdown reaches zero
            context.read<PrayerTimingsCubit>().getPrayerTimings();
          }
        });
      }
    });
  }

  void _updateTimings(TimingsModel? timings) {
    if (timings == null) return;

    final now = DateTime.now();
    final prayerTimes = {
      'Fajr': timings.fajr,
      'Sunrise': timings.sunrise,
      'Dhuhr': timings.dhuhr,
      'Asr': timings.asr,
      'Maghrib': timings.maghrib,
      'Isha': timings.isha,
    };

    String nextName = 'Fajr';
    String nextTimeStr = timings.fajr;
    Duration nextDuration = const Duration(hours: 24);

    for (var entry in prayerTimes.entries) {
      try {
        final timeStr = entry.value.replaceFirst(RegExp(r'\s.*'), '');
        final parts = timeStr.split(':');
        final prayerTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );

        if (prayerTime.isAfter(now)) {
          final diff = prayerTime.difference(now);
          if (diff < nextDuration) {
            nextDuration = diff;
            nextName = entry.key;
            nextTimeStr = entry.value;
          }
        }
      } catch (e) {
        // Handle parsing error if any
      }
    }

    if (nextName == 'Fajr' && nextDuration == const Duration(hours: 24)) {
      // All prayers passed, next is tomorrow's Fajr
      try {
        final timeStr = timings.fajr.replaceFirst(RegExp(r'\s.*'), '');
        final parts = timeStr.split(':');
        final tomorrowFajr = DateTime(
          now.year,
          now.month,
          now.day + 1,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
        nextDuration = tomorrowFajr.difference(now);
        nextName = 'Fajr';
        nextTimeStr = timings.fajr;
      } catch (e) {}
    }

    _prayerName = nextName.toUpperCase();
    _prayerTime = nextTimeStr;
    _remainingTime = nextDuration;
  }

  String _formatCountdown(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '-$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
      builder: (context, state) {
        if (state is GetPrayerTimesSuccessState) {
          _updateTimings(state.prayerTimingsModel.data?.timings);
        } else {
          // Fallback to cubit's internal model if state is not success yet
          final cubit = context.read<PrayerTimingsCubit>();
          if (cubit.prayerTimingsModel.data?.timings != null) {
            _updateTimings(cubit.prayerTimingsModel.data?.timings);
          }
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0.w,
            vertical: 8.0.h,
          ),
          child: GlassContainer(
            borderRadius: 24.r,
            padding: EdgeInsets.all(16.0.w),
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
                        color: AppColors.islamicTeal.withAlpha(102),
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
                SizedBox(width: 12.0.w),

                // Center: Prayer name and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BERIKUTNYA: $_prayerName',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 4.0.h),
                      Text(
                        _prayerTime,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: Countdown with divider
                Container(
                  padding: EdgeInsets.only(left: 16.0.w),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black.withAlpha(13),
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
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.0.h),
                      Text(
                        _formatCountdown(_remainingTime),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
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
      },
    );
  }
}
