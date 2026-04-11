import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../app/resources/resources.dart';

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
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFEF9C3),
                  Color(0xFFFDE047),
                  Color(0xFF0D9488),
                  Color(0xFF134E4A),
                ],
                stops: [0.0, 0.15, 0.7, 1.0],
              ),
            ),
          ),

          // Decorative blur elements
          Positioned(
            top: -50.h,
            right: -50.w,
            child: Container(
              width: 250.r,
              height: 250.r,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: -50.w,
            child: Container(
              width: 180.r,
              height: 180.r,
              decoration: BoxDecoration(
                color: const Color(0xFF134E4A).withAlpha(50),
                shape: BoxShape.circle,
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

                  // Logo and Title
                  Column(
                    children: [
                      // Configurable Logo (easily change to Image.asset)
                      Container(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Icon(
                          Symbols.mosque,
                          size: 100.r,
                          color: const Color(0xFF064E3B),
                          fill: 1.0,
                        ),
                        // To use an image instead, replace Icon above with:
                        // child: Image.asset(ImageAsset.launcherIcon, width: 100.r, height: 100.r),
                      ),

                      Text(
                        'AN-NIBROS',
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          color: const Color(0xFF064E3B),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        'SPIRITUAL COMPANION',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: const Color(0xFF064E3B).withAlpha(180),
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
