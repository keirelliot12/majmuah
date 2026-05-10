import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/utils/constants.dart';
import '../../../domain/models/quran/quran_model.dart';
import '../../components/separator.dart';
import '../../home/cubit/home_cubit.dart';
import '../../home/screens/quran/cubit/quran_cubit.dart';
import '../../../../../app/resources/resources.dart';
import '../../../../data/data_source/local/download_storage_manager.dart';
import '../../../../../di/di.dart';

class SurahBuilderView extends StatelessWidget {
  final List<QuranModel> quranList;
  final int pageNo;

  const SurahBuilderView({
    Key? key,
    required this.quranList,
    required this.pageNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DownloadStorageManager storageManager =
        instance<DownloadStorageManager>();
    final initialPage = pageNo < 1
        ? 0
        : pageNo > 604
        ? 603
        : pageNo - 1;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
        HomeCubit.get(context).isThereABookMarked().then((value) {
          isThereABookMarkedPage = value;
        });
      },
      child: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          QuranCubit cubit = QuranCubit.get(context);
          HomeCubit homeCubit = HomeCubit.get(context);
          bool darkMode = homeCubit.darkModeOn(context);
          final PageController pageController = PageController(
            initialPage: initialPage,
          );

          //Get Current App Locale
          final currentLocale = context.locale;

          //Check if current app language is English
          bool isEnglish =
              currentLocale.languageCode == LanguageType.english.getValue();

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppPadding.p8.r),
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  reverse: isEnglish,
                  controller: pageController,
                  itemCount: 604,
                  itemBuilder: (BuildContext context, int index) {
                    var quranPageNumber = index + 1;
                    final List<QuranModel> pageSurahsList = cubit.getPageSurahs(
                      quran: quranList,
                      pageNo: quranPageNumber,
                    );
                    final List<AyahModel> ayahs = cubit.getAyahsFromPageNo(
                      quranList: quranList,
                      pageNo: quranPageNumber,
                    );
                    if (pageSurahsList.isEmpty || ayahs.isEmpty) {
                      return _missingPageState(context, quranPageNumber);
                    }

                    final List<String> pageSurahsNamesList = List.of(
                      pageSurahsList.map((surah) => surah.name),
                    );
                    final String surahNameOnScreen = pageSurahsNamesList.first;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${AppStrings.juz.tr()}: ${ayahs.first.juz.toString().tr()}، ${AppStrings.hizb.tr()}: ${((ayahs.first.hizbQuarter / 4).ceil()).toString().tr()} ",
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontFamily:
                                        FontConstants.uthmanTNFontFamily,
                                    color: Theme.of(
                                      context,
                                    ).unselectedWidgetColor,
                                  ),
                            ),
                            Text(
                              surahNameOnScreen,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    wordSpacing: AppSize.s5.w,
                                    letterSpacing: AppSize.s0_1.w,
                                    fontFamily: FontConstants.meQuranFontFamily,
                                    color: Theme.of(
                                      context,
                                    ).unselectedWidgetColor,
                                  ),
                            ),
                          ],
                        ),
                        getSeparator(context),
                        //Quran with Images
                        Expanded(
                          child: Center(
                            child: FutureBuilder<String?>(
                              future: storageManager.getQuranPagePath(
                                quranPageNumber,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Image.file(
                                    File(snapshot.data!),
                                    color: darkMode ? Colors.white : null,
                                    colorBlendMode: BlendMode.srcIn,
                                    fit: BoxFit.fitWidth,
                                  );
                                }

                                return _missingPageState(
                                  context,
                                  quranPageNumber,
                                );
                              },
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: Text("$quranPageNumber"),
                          onPressed: () {
                            homeCubit.bookMarkPage(quranPageNumber);
                          },
                          backgroundColor: darkMode
                              ? ColorManager.darkSecondary
                              : ColorManager.lightPrimary,
                          child: Icon(
                            homeCubit.isPageBookMarked(quranPageNumber)
                                ? Icons.bookmark
                                : Icons.bookmark_add_outlined,
                            color: ColorManager.gold,
                          ),
                        ),
                        getSeparator(context),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppPadding.p8.h,
                          ),
                          child: Text(
                            (quranPageNumber).toString().tr(),
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontFamily: FontConstants.uthmanTNFontFamily,
                                  height: AppSize.s1.h,
                                  color: Theme.of(
                                    context,
                                  ).unselectedWidgetColor,
                                ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _missingPageState(BuildContext context, int quranPageNumber) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_for_offline_outlined,
              size: 64.sp,
              color: Theme.of(context).unselectedWidgetColor,
            ),
            SizedBox(height: 16.h),
            Text(
              "Halaman $quranPageNumber belum tersedia di perangkat.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.h),
            Text(
              "Kembali ke daftar surah untuk mengunduh mushaf.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 20.h),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Kembali"),
            ),
          ],
        ),
      ),
    );
  }
}
