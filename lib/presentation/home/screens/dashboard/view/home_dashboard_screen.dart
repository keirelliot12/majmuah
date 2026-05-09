import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/resources/resources.dart';
import '../../../../../presentation/home/widgets/custom_bottom_nav_bar.dart';
import '../../../../../presentation/home/widgets/home_header.dart';
import '../../../../../presentation/home/widgets/menu_grid_widget.dart';
import '../../../../../presentation/home/widgets/prayer_countdown_card.dart';
import '../../../../../presentation/home/widgets/search_bar_widget.dart';

/// Home Dashboard Screen - Main screen of the application
///
/// Displays:
/// - Header with location and date
/// - Prayer countdown timer
/// - Search bar
/// - Menu grid (7 items)
/// - Custom bottom navigation bar (5 items)
///
/// Uses a full-screen gradient background (Lemon Yellow -> Teal Green)
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentNavIndex = 2; // Start at "Beranda" (center)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Full-screen gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.lemonYellow, AppColors.tealGreen],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom Header with location and date
                const HomeHeader(),

                // Scrollable content (prayer card, search, menu)
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: AppPadding.p80.h),
                    child: Column(
                      children: [
                        // Prayer countdown card
                        const PrayerCountdownCard(),

                        SizedBox(height: AppSize.s8.h),

                        // Search bar
                        SearchBarWidget(
                          onTap: () {
                            // TODO: Navigate to search screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Search screen not implemented yet',
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: AppSize.s16.h),

                        // Menu grid
                        MenuGridWidget(
                          menuItems: MenuGridWidget.createDefaultMenuItems(
                            onAuradDoaTap: () => _handleMenuTap("Aurad & Doa'"),
                            onHizibRatibTap: () =>
                                _handleMenuTap('Hizib & Ratib'),
                            onPujiBilalTap: () =>
                                _handleMenuTap('Puji-pujian & Bilal'),
                            onAmalanHijriyahTap: () =>
                                _handleMenuTap('Amalan Hijriyah'),
                            onMaulidTap: () => _handleMenuTap('Maulid'),
                            onTahlilZiarahTap: () =>
                                _handleMenuTap('Tahlil & Ziarah'),
                            onKbihuTap: () =>
                                _handleMenuTap('KBIHU Nur Multazam'),
                            onLainnyaTap: () => _handleMenuTap('Lainnya'),
                          ),
                        ),

                        SizedBox(height: AppSize.s24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              onTabChanged: _onBottomNavTapped,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle menu item tap - navigate or show message
  void _handleMenuTap(String menuName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigasi ke $menuName - Not implemented yet')),
    );
    // TODO: Implement navigation to respective screens
  }

  /// Handle bottom navigation tab change
  void _onBottomNavTapped(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Quran
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Navigasi ke Quran')));
        break;
      case 1:
        // Navigate to Adzkar
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Navigasi ke Adzkar')));
        break;
      case 2:
        // Already on Beranda
        break;
      case 3:
        // Navigate to Prayer Times
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigasi ke Waktu Shalat')),
        );
        break;
      case 4:
        // Navigate to Settings
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Navigasi ke Pengaturan')));
        break;
    }
  }
}
