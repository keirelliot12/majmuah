import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:annibros/app/resources/resources.dart';
import 'package:annibros/domain/models/prayer_timings/prayer_timings_model.dart';
import 'package:annibros/presentation/components/glass_container.dart';
import 'package:annibros/presentation/home/screens/prayer_times/cubit/prayer_timings_cubit.dart';

class PrayerCountdownCard extends StatefulWidget {
  const PrayerCountdownCard({Key? key}) : super(key: key);

  @override
  State<PrayerCountdownCard> createState() => _PrayerCountdownCardState();
}

class _PrayerCountdownCardState extends State<PrayerCountdownCard> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
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
        final cubit = context.read<PrayerTimingsCubit>();
        final timings = state is GetPrayerTimesSuccessState
            ? state.prayerTimingsModel.data?.timings
            : cubit.prayerTimingsModel.data?.timings;
        final nextPrayer = _resolveNextPrayer(timings);

        return Padding(
          padding: EdgeInsets.fromLTRB(22.0.w, 10.0.h, 22.0.w, 8.0.h),
          child: GlassContainer(
            borderRadius: 22.r,
            padding: EdgeInsets.all(16.0.w),
            blur: 16.0,
            opacity: 0.92,
            borderColor: Colors.white.withAlpha(154),
            elevation: 18.r,
            shadowColor: AppColors.deepEmerald.withAlpha(24),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: AppColors.emerald,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepEmerald.withAlpha(36),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.r),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Symbols.wb_twilight,
                      color: AppColors.limeGold,
                      size: 22.r,
                    ),
                  ),
                ),
                SizedBox(width: 12.0.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextPrayer == null
                            ? 'JADWAL SHALAT'
                            : 'BERIKUTNYA: ${nextPrayer.name.toUpperCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald.withAlpha(178),
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 4.0.h),
                      Text(
                        nextPrayer?.timeLabel ?? '--:--',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepEmerald,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16.0.w),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.emerald.withAlpha(22),
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
                          color: AppColors.emerald.withAlpha(166),
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 4.0.h),
                      Text(
                        nextPrayer == null
                            ? 'Memuat'
                            : _formatCountdown(nextPrayer.remaining),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warmGold,
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

  _NextPrayer? _resolveNextPrayer(TimingsModel? timings) {
    if (timings == null) return null;

    final prayerTimes = {
      'Subuh': timings.fajr,
      'Terbit': timings.sunrise,
      'Dzuhur': timings.dhuhr,
      'Ashar': timings.asr,
      'Maghrib': timings.maghrib,
      'Isya': timings.isha,
    };

    _NextPrayer? nextPrayer;
    for (final entry in prayerTimes.entries) {
      final prayerDateTime = _parsePrayerDateTime(entry.value, _now);
      if (prayerDateTime == null || !prayerDateTime.isAfter(_now)) continue;

      final candidate = _NextPrayer(
        name: entry.key,
        timeLabel: _cleanTimeLabel(entry.value),
        remaining: prayerDateTime.difference(_now),
      );

      if (nextPrayer == null || candidate.remaining < nextPrayer.remaining) {
        nextPrayer = candidate;
      }
    }

    if (nextPrayer != null) return nextPrayer;

    final tomorrowFajr = _parsePrayerDateTime(
      timings.fajr,
      _now.add(const Duration(days: 1)),
    );
    if (tomorrowFajr == null) return null;

    return _NextPrayer(
      name: 'Subuh',
      timeLabel: _cleanTimeLabel(timings.fajr),
      remaining: tomorrowFajr.difference(_now),
    );
  }

  DateTime? _parsePrayerDateTime(String rawValue, DateTime date) {
    try {
      final timeStr = _cleanTimeLabel(rawValue);
      final parts = timeStr.split(':');
      if (parts.length < 2) return null;
      return DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  String _cleanTimeLabel(String rawValue) {
    return rawValue.replaceFirst(RegExp(r'\s.*'), '').trim();
  }

  String _formatCountdown(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final hours = safeDuration.inHours.toString().padLeft(2, '0');
    final minutes = safeDuration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = safeDuration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class _NextPrayer {
  final String name;
  final String timeLabel;
  final Duration remaining;

  const _NextPrayer({
    required this.name,
    required this.timeLabel,
    required this.remaining,
  });
}
