import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../components/app_brand_logo.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  _goNext() {
    Navigator.pushReplacementNamed(context, Routes.homeRoute);
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  AppColors.surfaceMuted,
                  AppColors.emerald,
                  AppColors.deepEmerald,
                ],
                stops: [0.0, 0.34, 0.78, 1.0],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Placeholder for top space

                  Column(
                    children: [
                      const AppBrandLogo(size: 116),
                      SizedBox(height: 18.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withAlpha(225),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: AppColors.limeGold.withAlpha(120),
                          ),
                        ),
                        child: Text(
                          'Amaliyah & Aurad Salafus Sholeh',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepEmerald,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Loading/Footer
                  Padding(
                    padding: EdgeInsets.only(bottom: 60.h),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.limeGold,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Menyiapkan Amalan',
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom bar indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              width: 120.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(25),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
