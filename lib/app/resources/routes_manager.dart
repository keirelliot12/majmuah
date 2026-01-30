import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:islamic/app/resources/strings_manager.dart';
import 'package:islamic/presentation/browseyoutube/view/browseyoutube_screen.dart';
import 'package:islamic/presentation/pillars/view/pillars_screen.dart';

import '../../di/di.dart';
import '../../presentation/custom_adhkar/view/custom_adhkar_view.dart';
import '../../presentation/custom_adhkar/view/custom_dhikr_view.dart';
import '../../presentation/dhikr_builder/view/dhikr_builder_view.dart';
import '../../presentation/hadith_builder/view/hadith_builder_view.dart';
import '../../presentation/home/view/home_view.dart';
import '../../presentation/surah_builder/view/surah_builder_view.dart';
import '../../presentation/home/screens/all_categories/all_categories_screen.dart';
import '../../presentation/material/material_list_screen.dart';
import '../../presentation/material/material_detail_screen.dart';
import '../../presentation/notes/notes_list_screen.dart';
import '../../presentation/notes/note_detail_screen.dart';
import '../../presentation/search/search_result_screen.dart';
import '../../domain/models/note/note_model.dart';

class Routes {
  static const String dashboardRoute = "/";
  static const String homeRoute = "/home";
  static const String quranRoute = "/quran";
  static const String hadithRoute = "/hadith";
  static const String adhkarRoute = "/adhkar";
  static const String customAdhkarRoute = "/customAdhkar";
  static const String customDhikrRoute = "/customDhikr";
  static const String pillarsRoute = "/pillars";
  static const String browsenetRoute = "/browse";

  // Beranda Feature Routes
  static const String allCategoriesRoute = "/beranda/categories";
  static const String materialListRoute = "/beranda/materialList";
  static const String materialDetailRoute = "/beranda/materialDetail";
  static const String notesListRoute = "/beranda/notes";
  static const String noteDetailRoute = "/beranda/noteDetail";
  static const String searchResultRoute = "/beranda/search";
}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeRoute:
        initQuranModule();
        initHadithModule();
        initAdhkarModule();
        initPrayerTimingsModule();
        initBerandaModule();
        return MaterialPageRoute(builder: (_) => HomeView());
      case Routes.quranRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => SurahBuilderView(
                quranList: args["quranList"], pageNo: args["pageNo"]));
      case Routes.hadithRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) =>
                HadithBuilderView(hadithModel: args["hadithModel"]));
      case Routes.adhkarRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => DhikrBuilderView(
                adhkarList: args["adhkarList"], category: args["category"]));
      case Routes.customAdhkarRoute:
        initCustomAdhkarModule();
        return MaterialPageRoute(builder: (_) => CustomAdhkarView());
      case Routes.customDhikrRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => CustomDhikrView(
                  customDhikrText: args["customDhikrText"],
                  noOfRepetitions: args["noOfRepetitions"],
                ));
      case Routes.pillarsRoute:
        return MaterialPageRoute(builder: (_) => PillarsScreen());
      case Routes.browsenetRoute:
        return MaterialPageRoute(builder: (_) => BrowseYoutubeScreen());

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
      case Routes.notesListRoute:
        initBerandaModule();
        return MaterialPageRoute(builder: (_) => const NotesListScreen());
      case Routes.noteDetailRoute:
        initBerandaModule();
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => NoteDetailScreen(
            note: args?['note'] as NoteModel?,
          ),
        );
      case Routes.searchResultRoute:
        initBerandaModule();
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SearchResultScreen(
            query: args['query'],
          ),
        );

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.noRouteFound.tr(),
          ),
        ),
        body: Center(
          child: Text(
            AppStrings.noRouteFound.tr(),
          ),
        ),
      ),
    );
  }
}
