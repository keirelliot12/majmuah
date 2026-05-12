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

  // Helper method to map screen indices to bottom nav indices.
  // Internal: 0=Home, 1=Quran, 2=Prayer, 3=Adhkar, 4=Settings
  int _mapIndexTo5Items(int internalIndex) {
    return internalIndex;
  }

  // Helper method to map bottom nav indices back to screen indices.
  int _mapIndexFrom5Items(int navIndex) {
    return navIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => instance<HomeCubit>()..isThereABookMarked(),
        ),
        BlocProvider(
          create: (context) => instance<BerandaMaterialCubit>()..getLastRead(),
        ),
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
            floatingActionButton:
                isThereABookMarkedPage == true &&
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
                    child: const Icon(Icons.bookmark, color: ColorManager.gold),
                  )
                : currentIndex == Constants.adhkarIndex
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.customAdhkarRoute);
                    },
                    backgroundColor: darkMode
                        ? ColorManager.darkSecondary
                        : ColorManager.lightPrimary,
                    child: SvgPicture.asset(
                      ImageAsset.adhkarIcon,
                      width: AppSize.s50.h,
                      height: AppSize.s50.h,
                      colorFilter: const ColorFilter.mode(
                        ColorManager.gold,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : Container(),
            appBar: isHomeScreen
                ? null // HomeHeader will be part of body for Beranda
                : AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Text(
                      _viewModel.titles[currentIndex],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorManager.gold,
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: Icon(Icons.sort, size: AppSize.s20.r),
                    ),
                    actions: currentIndex == Constants.quranIndex
                        ? [
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: CustomSearch(),
                                );
                              },
                            ),
                          ]
                        : [],
                  ),
            drawer: MyDrawer(),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _mapIndexTo5Items(currentIndex),
              onTabChanged: (index) {
                cubit.changeBotNavIndex(_mapIndexFrom5Items(index));
              },
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
        Container(color: AppColors.background),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 265.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.deepEmerald,
                  AppColors.emerald,
                  AppColors.deepEmerald,
                ],
                stops: const [0, 0.58, 1],
              ),
            ),
          ),
        ),
        Positioned(
          top: 58.h,
          right: -42.w,
          child: Container(
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          top: 190.h,
          left: -36.w,
          child: Container(
            width: 92.w,
            height: 92.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              const HomeHeader(),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: AppPadding.p100.h),
                  child: Column(
                    children: [
                      const PrayerCountdownCard(),

                      SizedBox(height: AppSize.s6.h),

                      SearchBarWidget(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.smartSearchRoute);
                        },
                      ),

                      SizedBox(height: AppSize.s6.h),

                      BlocBuilder<BerandaMaterialCubit, BerandaMaterialState>(
                        buildWhen: (previous, current) =>
                            current is BerandaLastReadLoaded,
                        builder: (context, materialState) {
                          String lastReadTitle = 'Ratib Al-Haddad';
                          MaterialModel? lastReadMaterial;

                          if (materialState is BerandaLastReadLoaded &&
                              materialState.lastRead != null) {
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

                      SizedBox(height: AppSize.s14.h),

                      MenuGridWidget(
                        menuItems: MenuGridWidget.createDefaultMenuItems(
                          onAuradDoaTap: () =>
                              _handleMenuTap(context, "Aurad & Doa'"),
                          onHizibRatibTap: () =>
                              _handleMenuTap(context, 'Hizib & Ratib'),
                          onPujiBilalTap: () =>
                              _handleMenuTap(context, 'Puji-pujian & Bilal'),
                          onAmalanHijriyahTap: () =>
                              _handleMenuTap(context, 'Amalan Hijriyah'),
                          onMaulidTap: () => _handleMenuTap(context, 'Maulid'),
                          onTahlilZiarahTap: () =>
                              _handleMenuTap(context, 'Tahlil & Ziarah'),
                          onKbihuTap: () =>
                              _handleMenuTap(context, 'KBIHU Nur Multazam'),
                          onLainnyaTap: () =>
                              _handleMenuTap(context, 'Lainnya'),
                        ),
                      ),

                      SizedBox(height: AppSize.s18.h),

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
      case "Aurad & Doa'":
        Navigator.pushNamed(
          context,
          Routes.materialListRoute,
          arguments: {
            'categoryName': "Aurad & Doa'",
            'categoryFilterKey': "Aurad & Doa'",
            'categoryColor': AppColors.emerald500,
            'categoryIconAsset': 'assets/icons/aurad_shalat.png',
          },
        );
        break;
      case 'Hizib & Ratib':
        Navigator.pushNamed(
          context,
          Routes.materialListRoute,
          arguments: {
            'categoryName': 'Hizib & Ratib',
            'categoryFilterKey': 'Hizib & Ratib',
            'categoryColor': AppColors.indigo500,
            'categoryIconAsset': 'assets/icons/ratib.png',
          },
        );
        break;
      case 'Puji-pujian & Bilal':
        Navigator.pushNamed(
          context,
          Routes.materialListRoute,
          arguments: {
            'categoryName': 'Puji-pujian & Bilal',
            'categoryFilterKey': 'Puji-pujian & Bilal',
            'categoryColor': AppColors.amber500,
            'categoryIconAsset': 'assets/icons/puji_pujian_bilal.png',
          },
        );
        break;
      case 'Amalan Hijriyah':
        Navigator.pushNamed(
          context,
          Routes.materialListRoute,
          arguments: {
            'categoryName': 'Amalan Hijriyah',
            'categoryFilterKey': 'Amalan Hijriyah',
            'categoryColor': AppColors.teal600,
            'categoryIconAsset': 'assets/icons/doa_tawasul.png',
          },
        );
        break;
      case 'Maulid':
        Navigator.pushNamed(
          context,
          Routes.materialListRoute,
          arguments: {
            'categoryName': 'Maulid',
            'categoryFilterKey': 'Maulid',
            'categoryColor': AppColors.orange500,
            'categoryIconAsset': 'assets/icons/maulid.png',
          },
        );
        break;
      case 'Tahlil & Ziarah':
        Navigator.pushNamed(
          context,
          Routes.materialListRoute,
          arguments: {
            'categoryName': 'Tahlil & Ziarah',
            'categoryFilterKey': 'Tahlil & Ziarah',
            'categoryColor': AppColors.teal600,
            'categoryIconAsset': 'assets/icons/tahlil_ziarah.png',
          },
        );
        break;
      case 'KBIHU Nur Multazam':
        Navigator.pushNamed(
          context,
          Routes.materialListRoute,
          arguments: {
            'categoryName': 'KBIHU Nur Multazam',
            'categoryFilterKey': 'KBIHU Nur Multazam',
            'categoryColor': AppColors.blue500,
            'categoryIconAsset': 'assets/icons/kbihu_nur_multazam.png',
          },
        );
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
