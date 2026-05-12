import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:annibros/app/resources/strings_manager.dart';
import 'package:annibros/presentation/browseyoutube/view/browseyoutube_screen.dart';

import '../../di/di.dart';
import '../../presentation/custom_adhkar/view/custom_adhkar_view.dart';
import '../../presentation/custom_adhkar/view/custom_dhikr_view.dart';
import '../../presentation/dhikr_builder/view/dhikr_builder_view.dart';
import '../../presentation/home/view/home_view.dart';
import '../../presentation/home/cubit/beranda_material_cubit.dart';
import '../../presentation/surah_builder/view/surah_builder_view.dart';
import '../../presentation/home/screens/all_categories/all_categories_screen.dart';
import '../../presentation/material/material_list_screen.dart';
import '../../presentation/material/material_detail_screen.dart';
import '../../presentation/search/search_result_screen.dart';
import '../../presentation/search/smart_search_screen.dart';
import '../../presentation/splash/splash_view.dart';
import '../../presentation/settings/download_manager_screen.dart';

class Routes {
  static const String splashRoute = "/";
  static const String homeRoute = "/home";
  static const String quranRoute = "/quran";
  static const String hadithRoute = "/hadith";
  static const String adhkarRoute = "/adhkar";
  static const String customAdhkarRoute = "/customAdhkar";
  static const String customDhikrRoute = "/customDhikr";
  static const String browsenetRoute = "/browse";

  // Beranda Feature Routes
  static const String allCategoriesRoute = "/beranda/categories";
  static const String materialListRoute = "/beranda/materialList";
  static const String materialDetailRoute = "/beranda/materialDetail";
  static const String notesListRoute = "/beranda/notes";
  static const String noteDetailRoute = "/beranda/noteDetail";
  static const String searchResultRoute = "/beranda/search";
  static const String smartSearchRoute = "/beranda/smartSearch";
  static const String downloadManagerRoute = "/settings/downloadManager";
}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.homeRoute:
        initQuranModule();
        initAdhkarModule();
        initPrayerTimingsModule();
        initBerandaModule();
        return MaterialPageRoute(builder: (_) => HomeView());
      case Routes.quranRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SurahBuilderView(
            quranList: args["quranList"],
            pageNo: args["pageNo"],
          ),
        );
      case Routes.adhkarRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DhikrBuilderView(
            adhkarList: args["adhkarList"],
            category: args["category"],
          ),
        );
      case Routes.customAdhkarRoute:
        initCustomAdhkarModule();
        return MaterialPageRoute(builder: (_) => CustomAdhkarView());
      case Routes.customDhikrRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CustomDhikrView(
            customDhikrText: args["customDhikrText"],
            noOfRepetitions: args["noOfRepetitions"],
          ),
        );
      case Routes.browsenetRoute:
        return MaterialPageRoute(builder: (_) => BrowseYoutubeScreen());
      case Routes.downloadManagerRoute:
        return MaterialPageRoute(builder: (_) => const DownloadManagerScreen());

      // Beranda Feature Case
      case Routes.allCategoriesRoute:
        initBerandaModule();
        return MaterialPageRoute(builder: (_) => const AllCategoriesScreen());
      case Routes.materialListRoute:
        initBerandaModule();
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MaterialListScreen(
            categoryName: args['categoryName'],
            categoryFilterKey: args['categoryFilterKey'],
            categoryColor: args['categoryColor'],
            categoryIconAsset: args['categoryIconAsset'],
          ),
        );
      case Routes.materialDetailRoute:
        initBerandaModule();
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MaterialDetailScreen(
            material: args['material'],
            categoryColor: args['categoryColor'],
          ),
        );
      case Routes.searchResultRoute:
        initBerandaModule();
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SearchResultScreen(query: args['query']),
        );
      case Routes.smartSearchRoute:
        initBerandaModule();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => instance<BerandaMaterialCubit>(),
            child: const SmartSearchScreen(),
          ),
        );

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text(AppStrings.noRouteFound.tr())),
        body: Center(child: Text(AppStrings.noRouteFound.tr())),
      ),
    );
  }
}
