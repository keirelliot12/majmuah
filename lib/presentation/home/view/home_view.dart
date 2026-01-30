import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/utils/constants.dart';
import '../../../app/utils/custom_search.dart';
import '../../../di/di.dart';
import '../../../domain/models/quran/quran_model.dart';
import '../../../domain/models/material/material_model.dart';
import '../../components/mydrawer.dart';
import '../../../app/resources/resources.dart';

import '../cubit/home_cubit.dart';
import '../cubit/beranda_material_cubit.dart';
import '../cubit/beranda_material_state.dart';
import '../screens/quran/cubit/quran_cubit.dart';
import '../viewmodel/home_viewmodel.dart';
import '../widgets/home_header.dart';
import '../widgets/prayer_countdown_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/menu_grid_widget.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/last_read_card.dart';
import '../widgets/wisdom_quote_card.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel _viewModel = instance<HomeViewModel>();

  HomeView({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Helper method to map 6 internal indices to 5 bottom nav items
  // Internal: 0=Home, 1=Quran, 2=Hadith, 3=Prayer, 4=Adhkar, 5=Settings
  // BottomNav: 0=Home, 1=Quran, 2=Prayer, 3=Adhkar, 4=Settings (skip Hadith)
  int _mapIndexTo5Items(int internalIndex) {
    if (internalIndex == 0) return 0; // Home
    if (internalIndex == 1) return 1; // Quran
    if (internalIndex == 2) return 0; // Hadith -> show Home (hidden)
    if (internalIndex == 3) return 2; // Prayer
    if (internalIndex == 4) return 3; // Adhkar
    if (internalIndex == 5) return 4; // Settings
    return 0;
  }

  // Helper method to map 5 bottom nav items back to 6 internal indices
  int _mapIndexFrom5Items(int navIndex) {
    if (navIndex == 0) return 0; // Home
    if (navIndex == 1) return 1; // Quran
    if (navIndex == 2) return 3; // Prayer
    if (navIndex == 3) return 4; // Adhkar
    if (navIndex == 4) return 5; // Settings
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => instance<HomeCubit>()..isThereABookMarked()),
        BlocProvider(create: (context) => instance<BerandaMaterialCubit>()..getLastRead()),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          bool darkMode = cubit.darkModeOn(context);
          var quranCubit = QuranCubit.get(context);
          List<QuranModel> quranList = quranCubit.quranData;
          int currentIndex = cubit.currentIndex;
          bool isHomeScreen = currentIndex == Constants.homeIndex;

          return Scaffold(
            key: _scaffoldKey,
            floatingActionButton: isThereABookMarkedPage == true &&
                    currentIndex == Constants.quranIndex
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.quranRoute,
                        arguments: {
                          'quranList': quranList,
                          'pageNo': cubit.getBookMarkPage(),
                        },
                      );
                    },
                    backgroundColor: darkMode
                        ? ColorManager.darkSecondary
                        : ColorManager.lightPrimary,
                    child: const Icon(
                      Icons.bookmark,
                      color: ColorManager.gold,
                    ),
                  )
                : currentIndex == Constants.adhkarIndex
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.customAdhkarRoute,
                          );
                        },
                        backgroundColor: darkMode
                            ? ColorManager.darkSecondary
                            : ColorManager.lightPrimary,
                        child: SvgPicture.asset(
                          ImageAsset.adhkarIcon,
                          width: AppSize.s50.h,
                          height: AppSize.s50.h,
                          colorFilter: const ColorFilter.mode(
                              ColorManager.gold, BlendMode.srcIn),
                        ),
                      )
                    : Container(),
            appBar: isHomeScreen
                ? null  // HomeHeader will be part of body for Beranda
                : AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Text(
                      _viewModel.titles[currentIndex],
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: ColorManager.gold),
                    ),
                    leading: IconButton(
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: Icon(
                        Icons.sort,
                        size: AppSize.s20.r,
                      ),
                    ),
                    actions: currentIndex == Constants.quranIndex
                        ? [
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                showSearch(
                                    context: context,
                                    delegate: CustomSearch());
                              },
                            )
                          ]
                        : [],
                  ),
            drawer: MyDrawer(),
            bottomNavigationBar: isHomeScreen
                ? CustomBottomNavBar(
                    currentIndex: _mapIndexTo5Items(currentIndex),
                    onTabChanged: (index) {
                      cubit.changeBotNavIndex(_mapIndexFrom5Items(index));
                    },
                  )
                : BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: const Color(0xFF90A88E), // Sage green
                    selectedIconTheme: IconThemeData(
                        color: const Color(0xFF90A88E), size: AppSize.s24.r),
                    selectedLabelStyle:
                        getSemiBoldStyle(fontSize: FontSize.s12),
                    unselectedLabelStyle:
                        getRegularStyle(fontSize: FontSize.s10),
                    unselectedItemColor: Colors.grey,
                    unselectedIconTheme: IconThemeData(
                        color: Colors.grey, size: AppSize.s20.r),
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    enableFeedback: true,
                    currentIndex: _mapIndexTo5Items(currentIndex),
                    onTap: (int index) {
                      cubit.changeBotNavIndex(_mapIndexFrom5Items(index));
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: AppStrings.beranda.tr(),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          ImageAsset.quranIcon,
                          width: AppSize.s20.r,
                          height: AppSize.s20.r,
                          colorFilter: ColorFilter.mode(
                              _mapIndexTo5Items(currentIndex) == 1
                                  ? const Color(0xFF90A88E)
                                  : Colors.grey,
                              BlendMode.srcIn),
                        ),
                        label: AppStrings.quran.tr(),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          ImageAsset.prayerIcon,
                          width: AppSize.s20.r,
                          height: AppSize.s20.r,
                          colorFilter: ColorFilter.mode(
                              _mapIndexTo5Items(currentIndex) == 2
                                  ? const Color(0xFF90A88E)
                                  : Colors.grey,
                              BlendMode.srcIn),
                        ),
                        label: AppStrings.prayerTimes.tr(),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          ImageAsset.adhkarIcon,
                          width: AppSize.s20.r,
                          height: AppSize.s20.r,
                          colorFilter: ColorFilter.mode(
                              _mapIndexTo5Items(currentIndex) == 3
                                  ? const Color(0xFF90A88E)
                                  : Colors.grey,
                              BlendMode.srcIn),
                        ),
                        label: AppStrings.adhkar.tr(),
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.settings_outlined),
                        activeIcon: const Icon(Icons.settings),
                        label: AppStrings.settings.tr(),
                      ),
                    ],
                  ),
            body: isHomeScreen
                ? _buildBerandaScreen(context)
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.w),
                    child: _viewModel.screens[currentIndex],
                  ),
          );
        },
      ),
    );
  }

  /// Build Beranda/Home screen with new design
  Widget _buildBerandaScreen(BuildContext context) {
    return Stack(
      children: [
        // Full-screen gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.lemonYellow,
                AppColors.islamicTeal,
              ],
            ),
          ),
        ),

        // Main content
        SafeArea(
          child: Column(
            children: [
              // Custom Header with location and date
              const HomeHeader(),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: AppPadding.p100.h),
                  child: Column(
                    children: [
                      // Prayer countdown card with glassmorphism
                      const PrayerCountdownCard(),

                      SizedBox(height: AppSize.s8.h),

                      // Search bar
                      SearchBarWidget(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.smartSearchRoute);
                        },
                      ),

                      SizedBox(height: AppSize.s8.h),

                      // Last read card with real data
                      BlocBuilder<BerandaMaterialCubit, BerandaMaterialState>(
                        buildWhen: (previous, current) => current is BerandaLastReadLoaded,
                        builder: (context, materialState) {
                          String lastReadTitle = 'Ratib Al-Haddad';
                          MaterialModel? lastReadMaterial;

                          if (materialState is BerandaLastReadLoaded && materialState.lastRead != null) {
                            lastReadTitle = materialState.lastRead!.title;
                            lastReadMaterial = materialState.lastRead;
                          }

                          return LastReadCard(
                            title: lastReadTitle,
                            onTap: () {
                              if (lastReadMaterial != null) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.materialDetailRoute,
                                  arguments: {
                                    'material': lastReadMaterial,
                                    'categoryColor': AppColors.blue500,
                                  },
                                );
                              } else {
                                _handleMenuTap(context, 'Terakhir Dibaca');
                              }
                            },
                          );
                        },
                      ),

                      SizedBox(height: AppSize.s16.h),

                      // Menu grid (4x2)
                      MenuGridWidget(
                        menuItems: MenuGridWidget.createDefaultMenuItems(
                          onAuradSholatTap: () => _handleMenuTap(context, 'Aurad Sholat'),
                          onDoaTawasulTap: () => _handleMenuTap(context, 'Doa & Tawassul'),
                          onRatibTap: () => _handleMenuTap(context, 'Ratib'),
                          onKhutbahTap: () => _handleMenuTap(context, 'Khutbah'),
                          onMaulidTap: () => _handleMenuTap(context, 'Maulid'),
                          onTahlilZiarahTap: () => _handleMenuTap(context, 'Tahlil & Ziarah'),
                          onNotesTap: () => _handleMenuTap(context, 'Notes'),
                          onLainnyaTap: () => _handleMenuTap(context, 'Lainnya'),
                        ),
                      ),

                      SizedBox(height: AppSize.s24.h),

                      // Wisdom quote card with glassmorphism
                      const WisdomQuoteCard(),

                      SizedBox(height: AppSize.s24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Handle menu item tap
  void _handleMenuTap(BuildContext context, String menuName) {
    switch (menuName) {
      case 'Aurad Sholat':
        Navigator.pushNamed(context, Routes.materialListRoute, arguments: {
          'categoryName': 'Aurad Shalat',
          'categoryFilterKey': 'Aurad Shalat',
          'categoryColor': AppColors.emerald500,
        });
        break;
      case 'Doa & Tawassul':
        Navigator.pushNamed(context, Routes.materialListRoute, arguments: {
          'categoryName': 'Doa & Tawasul',
          'categoryFilterKey': 'Doa & Tawasul',
          'categoryColor': AppColors.amber500,
        });
        break;
      case 'Ratib':
        Navigator.pushNamed(context, Routes.materialListRoute, arguments: {
          'categoryName': 'Ratib',
          'categoryFilterKey': 'Ratib',
          'categoryColor': AppColors.indigo500,
        });
        break;
      case 'Khutbah':
        Navigator.pushNamed(context, Routes.materialListRoute, arguments: {
          'categoryName': 'Khutbah',
          'categoryFilterKey': 'Khutbah',
          'categoryColor': AppColors.rose500,
        });
        break;
      case 'Maulid':
        Navigator.pushNamed(context, Routes.materialListRoute, arguments: {
          'categoryName': 'Maulid',
          'categoryFilterKey': 'Maulid',
          'categoryColor': AppColors.orange500,
        });
        break;
      case 'Tahlil & Ziarah':
        Navigator.pushNamed(context, Routes.materialListRoute, arguments: {
          'categoryName': 'Tahlil & Ziarah',
          'categoryFilterKey': 'Tahlil & Ziarah',
          'categoryColor': AppColors.teal600,
        });
        break;
      case 'Notes':
        Navigator.pushNamed(context, Routes.notesListRoute);
        break;
      case 'Lainnya':
        Navigator.pushNamed(context, Routes.allCategoriesRoute);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigasi ke $menuName - Belum tersedia')),
        );
    }
  }
}
