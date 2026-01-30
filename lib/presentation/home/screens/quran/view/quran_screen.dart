import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/models/quran/quran_model.dart';
import '../../../../components/separator.dart';
import '../../../../../app/resources/resources.dart';

import '../cubit/quran_cubit.dart';
import '../../../../download/cubit/download_cubit.dart';
import '../../../../download/cubit/download_state.dart';
import '../../../../download/widgets/download_prompt_dialog.dart';
import '../../../../download/widgets/download_progress_sheet.dart';
import '../../../../../di/di.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => instance<DownloadCubit>()..checkManifest()),
      ],
      child: BlocListener<DownloadCubit, DownloadState>(
        listener: (context, state) {
          if (state is DownloadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is DownloadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is DownloadProgressState) {
            _showProgressSheet(context, state);
          }
        },
        child: BlocBuilder<DownloadCubit, DownloadState>(
          builder: (context, downloadState) {
            bool isDownloaded = false;
            if (downloadState is DownloadManifestLoaded) {
              isDownloaded = downloadState.isQuranFullyDownloaded;
            }

            return BlocBuilder<QuranCubit, QuranState>(
              builder: (context, state) {
                QuranCubit cubit = QuranCubit.get(context);
                List<QuranModel> quranList = cubit.quranData;

                final currentLocale = context.locale;
                bool isEnglish =
                    currentLocale.languageCode == LanguageType.english.getValue();

                if (!isDownloaded && downloadState is DownloadManifestLoaded) {
                  return _buildDownloadPromptView(context, downloadState);
                }

                return ConditionalBuilder(
                  condition: quranList.isNotEmpty,
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        ListTile(
                          style: ListTileStyle.list,
                          leading: Text(
                            AppStrings.number.tr(),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontFamily: FontConstants.uthmanTNFontFamily),
                          ),
                          title: Padding(
                            padding: EdgeInsets.symmetric(vertical: AppPadding.p5.h),
                            child: Text(
                              AppStrings.surahName.tr(),
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontFamily: FontConstants.uthmanTNFontFamily),
                            ),
                          ),
                          trailing: Text(
                            AppStrings.pageNumber.tr(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontFamily: FontConstants.uthmanTNFontFamily),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => _surahsIndexItem(
                                surahId: (index + 1).toString().tr(),
                                surahName: quranList[index].name,
                                englishSurahName: quranList[index].englishName,
                                pageNo: quranList[index].ayahs[0].page,
                                quranList: quranList,
                                isEnglish: isEnglish,
                                context: context),
                            separatorBuilder: (context, index) => getSeparator(context),
                            itemCount: quranList.length,
                          ),
                        ),
                      ],
                    );
                  },
                  fallback: (BuildContext context) {
                    return const Center(
                        child: CircularProgressIndicator(color: ColorManager.gold));
                  },
                );

              },
            );
          },
        ),
      ),
    );
  }

  void _showProgressSheet(BuildContext context, DownloadProgressState state) {
    // Only show if not already showing (logic to handle multiple progress updates)
    // For simplicity in this sprint, we use a persistent sheet model
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => DownloadProgressSheet(
        progress: state.progress,
        currentChunk: state.currentChunk,
        totalChunks: state.totalChunks,
      ),
    );
  }

  Widget _buildDownloadPromptView(BuildContext context, DownloadManifestLoaded state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppPadding.p20.r),
              decoration: BoxDecoration(
                color: ColorManager.gold.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_download_outlined,
                size: AppSize.s90.sp,
                color: ColorManager.gold,
              ),
            ),
            SizedBox(height: AppSize.s24.h),
            Text(
              'Mushaf Belum Diunduh',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: AppSize.s12.h),
            Text(
              'Agar dapat membaca Al-Quran secara offline, Anda perlu mengunduh data mushaf terlebih dahulu.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSize.s32.h),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => DownloadPromptDialog(
                    featureName: "Al-Quran",
                    description: "Anda akan mengunduh data mushaf Al-Quran. Pastikan koneksi internet stabil.",
                    totalSize: "120 MB",
                    onDownload: () {
                      DownloadCubit.get(context).startQuranDownload();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Download Sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.lightPrimary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p24.w, vertical: AppPadding.p12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s12.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _surahsIndexItem(
      {required String surahId,
      required String surahName,
      required String englishSurahName,
      required int pageNo,
      required List<QuranModel> quranList,
      required bool isEnglish,
      required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.p5.h),
      child: ListTile(
        style: ListTileStyle.list,
        leading: Padding(
          padding: EdgeInsets.only(top: AppPadding.p5.h),
          child: Text(
            surahId,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontFamily: FontConstants.uthmanTNFontFamily),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: AppPadding.p5.h),
          child: Text(
            isEnglish ? englishSurahName : surahName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: FontConstants.meQuranFontFamily,
                wordSpacing: AppSize.s5.w,
                letterSpacing: AppSize.s0_1.w),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.symmetric(vertical: AppPadding.p5.h),
          child: Text(
            isEnglish ? surahName : englishSurahName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontFamily: FontConstants.meQuranFontFamily,
                color: Theme.of(context).unselectedWidgetColor,
                wordSpacing: AppSize.s5.w,
                letterSpacing: AppSize.s0_1.w),
          ),
        ),
        trailing: Text(
          pageNo.toString().tr(),
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontFamily: FontConstants.uthmanTNFontFamily),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.quranRoute,
            arguments: {
              'quranList': quranList,
              'pageNo': pageNo,
            },
          );
        },
      ),
    );
  }
}
