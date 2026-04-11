import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../app/resources/resources.dart';
import '../../domain/models/prayer_timings/prayer_timings_model.dart';

class PrayerTimeWidget extends StatefulWidget {
  /// Prayer timings data from API
  final PrayerTimingsModel prayerTimingsModel;

  /// Location string (e.g., "Kudus, Indonesia")
  final String location;

  /// Whether to display in English or Arabic
  final bool isEnglish;

  /// Optional custom height
  final double? height;

  /// Optional callback when widget updates
  final VoidCallback? onUpdate;

  const PrayerTimeWidget({
    Key? key,
    required this.prayerTimingsModel,
    required this.location,
    required this.isEnglish,
    this.height,
    this.onUpdate,
  }) : super(key: key);

  @override
  State<PrayerTimeWidget> createState() => _PrayerTimeWidgetState();
}

class _PrayerTimeWidgetState extends State<PrayerTimeWidget> {
  late Timer _countdownTimer;
  late Duration _remainingTime;
  late String _nextPrayerName;
  late String _nextPrayerTime;

  @override
  void initState() {
    super.initState();
    _initializeNextPrayer();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  void _initializeNextPrayer() {
    _updateNextPrayer();
  }

  void _updateNextPrayer() {
    if (widget.prayerTimingsModel.code != 200 ||
        widget.prayerTimingsModel.data?.timings == null) {
      _nextPrayerName = 'N/A';
      _nextPrayerTime = '00:00';
      _remainingTime = Duration.zero;
      return;
    }

    final timings = widget.prayerTimingsModel.data!.timings!;
    final now = DateTime.now();

    // List of prayers with their times
    final prayers = [
      {
        'name': widget.isEnglish ? 'Fajr' : 'الفجر',
        'time': timings.fajr,
        'arabicName': 'الفجر',
      },
      {
        'name': widget.isEnglish ? 'Dhuhr' : 'الظهر',
        'time': timings.dhuhr,
        'arabicName': 'الظهر',
      },
      {
        'name': widget.isEnglish ? 'Asr' : 'العصر',
        'time': timings.asr,
        'arabicName': 'العصر',
      },
      {
        'name': widget.isEnglish ? 'Maghrib' : 'المغرب',
        'time': timings.maghrib,
        'arabicName': 'المغرب',
      },
      {
        'name': widget.isEnglish ? 'Isha' : 'العشاء',
        'time': timings.isha,
        'arabicName': 'العشاء',
      },
    ];

    // Find next prayer
    DateTime? nextPrayerDateTime;
    String? nextPrayerNameTemp;

    for (final prayer in prayers) {
      final prayerTime = _parseTimeString(prayer['time'] as String);
      if (prayerTime != null) {
        final prayerDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          prayerTime.hour,
          prayerTime.minute,
        );

        if (prayerDateTime.isAfter(now)) {
          nextPrayerDateTime = prayerDateTime;
          nextPrayerNameTemp = prayer['name'] as String;
          break;
        }
      }
    }

    // If no prayer found today, next prayer is tomorrow's Fajr
    if (nextPrayerDateTime == null) {
      final fajrTime = _parseTimeString(prayers[0]['time'] as String);
      if (fajrTime != null) {
        nextPrayerDateTime = DateTime(
          now.year,
          now.month,
          now.day + 1,
          fajrTime.hour,
          fajrTime.minute,
        );
        nextPrayerNameTemp = prayers[0]['name'] as String;
      }
    }

    if (nextPrayerDateTime != null && nextPrayerNameTemp != null) {
      _nextPrayerName = nextPrayerNameTemp;
      _nextPrayerTime = _formatTimeString(
        (prayers.firstWhere((p) => p['name'] == nextPrayerNameTemp)['time']
            as String),
      );
      _remainingTime = nextPrayerDateTime.difference(now);
    } else {
      _nextPrayerName = 'N/A';
      _nextPrayerTime = '00:00';
      _remainingTime = Duration.zero;
    }

    widget.onUpdate?.call();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _updateNextPrayer();
        });
      }
    });
  }

  DateTime? _parseTimeString(String timeString) {
    try {
      // Expected format: "14:30" or similar
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      }
    } catch (e) {
      debugPrint('Error parsing time: $e');
    }
    return null;
  }

  String _formatTimeString(String timeString) {
    try {
      final time = _parseTimeString(timeString);
      if (time != null) {
        return DateFormat('HH:mm').format(time);
      }
    } catch (e) {
      debugPrint('Error formatting time: $e');
    }
    return timeString;
  }

  String _formatCountdown(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _getFormattedDate() {
    if (widget.prayerTimingsModel.code != 200 ||
        widget.prayerTimingsModel.data == null) {
      return '';
    }

    final hijriDate = widget.prayerTimingsModel.data!.date!.hijri;
    if (hijriDate == null) return '';

    if (widget.isEnglish) {
      return '${hijriDate.day} ${hijriDate.month?.en} ${hijriDate.year} H';
    } else {
      return '${hijriDate.day} ${hijriDate.month?.ar} ${hijriDate.year} H';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 180.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.lemonYellow,
            AppColors.tealGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSize.s24.r),
      ),
      padding: EdgeInsets.all(AppPadding.p16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location and Date Row
          _buildHeaderRow(),
          SizedBox(height: AppSize.s12.h),

          // Prayer Info Row
          _buildPrayerInfoRow(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white.withAlpha(204), // 80% opacity
                    size: AppSize.s16.r,
                  ),
                  SizedBox(width: AppSize.s4.w),
                  Expanded(
                    child: Text(
                      widget.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withAlpha(204),
                            fontWeight: FontWeightsManager.semiBold,
                            fontSize: FontSize.s12,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.s4.h),
              Text(
                _getFormattedDate(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(153), // 60% opacity
                      fontWeight: FontWeightsManager.regular,
                      fontSize: FontSize.s11,
                    ),
              ),
            ],
          ),
        ),

        // Notification Bell (optional)
        Container(
          width: AppSize.s40.r,
          height: AppSize.s40.r,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(76), // 30% opacity
            borderRadius: BorderRadius.circular(AppSize.s12.r),
            border: Border.all(
              color: Colors.white.withAlpha(51), // 20% opacity
              width: 1,
            ),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: Colors.white.withAlpha(204),
            size: AppSize.s18.r,
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerInfoRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(102), // 40% opacity
        borderRadius: BorderRadius.circular(AppSize.s20.r),
        border: Border.all(
          color: Colors.white.withAlpha(102), // 40% opacity
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p12.w,
        vertical: AppPadding.p12.h,
      ),
      child: Row(
        children: [
          // Prayer Icon and Name
          Expanded(
            child: Row(
              children: [
                Container(
                  width: AppSize.s40.r,
                  height: AppSize.s40.r,
                  decoration: BoxDecoration(
                    color: AppColors.tealGreen,
                    borderRadius: BorderRadius.circular(AppSize.s10.r),
                  ),
                  child: Icon(
                    Icons.wb_twilight_rounded,
                    color: Colors.white,
                    size: AppSize.s24.r,
                  ),
                ),
                SizedBox(width: AppSize.s12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isEnglish ? 'Next Prayer' : 'الصلاة القادمة',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white.withAlpha(178), // 70% opacity
                              fontWeight: FontWeightsManager.bold,
                              fontSize: FontSize.s10,
                              letterSpacing: 0.5,
                            ),
                      ),
                      SizedBox(height: AppSize.s2.h),
                      Row(
                        children: [
                          Text(
                            _nextPrayerName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeightsManager.bold,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          SizedBox(width: AppSize.s8.w),
                          Text(
                            _nextPrayerTime,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeightsManager.bold,
                              fontSize: FontSize.s14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: AppSize.s50.h,
            color: Colors.black.withAlpha(13), // Very subtle divider
          ),
          SizedBox(width: AppSize.s12.w),

          // Countdown Timer
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isEnglish ? 'Time Left' : 'الوقت المتبقي',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withAlpha(178), // 70% opacity
                      fontWeight: FontWeightsManager.bold,
                      fontSize: FontSize.s10,
                      letterSpacing: 0.5,
                    ),
              ),
              SizedBox(height: AppSize.s2.h),
              Text(
                _formatCountdown(_remainingTime),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeightsManager.bold,
                      fontSize: FontSize.s14,
                      fontFamily: 'monospace', // Monospace for timer
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Convenience builder function
class PrayerTimeWidgetBuilder {
  /// Create Prayer Time Widget with default styling
  static Widget create({
    required PrayerTimingsModel prayerTimingsModel,
    required String location,
    required bool isEnglish,
    VoidCallback? onUpdate,
  }) {
    return PrayerTimeWidget(
      prayerTimingsModel: prayerTimingsModel,
      location: location,
      isEnglish: isEnglish,
      onUpdate: onUpdate,
    );
  }

  /// Create Prayer Time Widget with custom height
  static Widget withHeight({
    required PrayerTimingsModel prayerTimingsModel,
    required String location,
    required bool isEnglish,
    required double height,
    VoidCallback? onUpdate,
  }) {
    return PrayerTimeWidget(
      prayerTimingsModel: prayerTimingsModel,
      location: location,
      isEnglish: isEnglish,
      height: height,
      onUpdate: onUpdate,
    );
  }
}
