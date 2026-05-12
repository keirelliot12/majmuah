import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:annibros/app/utils/extensions.dart';

import '../../../../../app/resources/resources.dart';
import '../../../../../domain/models/adhkar/adhkar_model.dart';
import '../../../../components/separator.dart';

import '../cubit/adhkar_cubit.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({Key? key}) : super(key: key);

  static const Map<String, String> _indonesianCategoryTitles = {
    'أذكار الصباح': 'Dzikir Pagi',
    'أذكار المساء': 'Dzikir Petang',
    'أذكار الاستيقاظ من النوم': 'Dzikir Bangun Tidur',
    'دعاء لبس الثوب': 'Doa Memakai Pakaian',
    'دعاء لبس الثوب الجديد': 'Doa Memakai Pakaian Baru',
    'ما يقول إذا وضع الثوب': 'Doa Melepas Pakaian',
    'دعاء دخول الخلاء - الحمام': 'Doa Masuk Kamar Mandi',
    'دعاء الخروج من الخلاء - الحمام': 'Doa Keluar Kamar Mandi',
    'الذكر قبل الوضوء': 'Dzikir Sebelum Wudhu',
    'الذكر بعد الفراغ من الوضوء': 'Dzikir Setelah Wudhu',
    'الذكر عند الخروج من المنزل': 'Dzikir Keluar Rumah',
    'الذكر عند دخول المنزل': 'Dzikir Masuk Rumah',
    'دعاء الذهاب إلى المسجد': 'Doa Berangkat ke Masjid',
    'دعاء دخول المسجد': 'Doa Masuk Masjid',
    'دعاء الخروج من المسجد': 'Doa Keluar Masjid',
    'أذكار الآذان': 'Dzikir Ketika Adzan',
    'دعاء الاستفتاح': 'Doa Iftitah',
    'دعاء الركوع': 'Doa Rukuk',
    'دعاء الرفع من الركوع': 'Doa Bangkit dari Rukuk',
    'دعاء السجود': 'Doa Sujud',
    'دعاء الجلسة بين السجدتين': 'Doa Duduk di Antara Dua Sujud',
    'دعاء سجود التلاوة': 'Doa Sujud Tilawah',
    'التشهد': 'Tasyahud',
    'الصلاة على النبي بعد التشهد': 'Shalawat Setelah Tasyahud',
    'الدعاء بعد التشهد الأخير قبل السلام':
        'Doa Setelah Tasyahud Akhir Sebelum Salam',
    'الأذكار بعد السلام من الصلاة': 'Dzikir Setelah Shalat',
    'دعاء صلاة الاستخارة': 'Doa Shalat Istikharah',
    'أذكار النوم': 'Dzikir Sebelum Tidur',
    'الدعاء إذا تقلب في الليل': 'Doa Ketika Terbangun di Malam Hari',
    'دعاء الفزع في النوم و من بلي بالوحشة':
        'Doa Ketika Takut dalam Tidur',
    'ما يفعل من رأى الرؤيا أو الحلم في النوم':
        'Doa dan Adab Ketika Bermimpi',
    'دعاء قنوت الوتر': 'Doa Qunut Witir',
    'الذكر عقب السلام من الوتر': 'Dzikir Setelah Salam Witir',
    'دعاء الهم والحزن': 'Doa Saat Gundah dan Sedih',
    'دعاء الكرب': 'Doa Saat Kesulitan',
    'دعاء لقاء العدو و ذي السلطان': 'Doa Menghadapi Musuh dan Penguasa',
    'دعاء من خاف ظلم السلطان': 'Doa Takut Kezaliman Penguasa',
    'الدعاء على العدو': 'Doa Menghadapi Musuh',
    'ما يقول من خاف قوما': 'Doa Saat Takut kepada Suatu Kaum',
    'دعاء من أصابه وسوسة في الإيمان': 'Doa Saat Waswas dalam Iman',
    'دعاء قضاء الدين': 'Doa Melunasi Utang',
    'دعاء الوسوسة في الصلاة و القراءة':
        'Doa Saat Waswas dalam Shalat dan Bacaan',
    'دعاء من استصعب عليه أمر': 'Doa Ketika Urusan Terasa Sulit',
    'ما يقول ويفعل من أذنب ذنبا': 'Doa dan Amalan Setelah Berbuat Dosa',
    'دعاء طرد الشيطان و وساوسه': 'Doa Mengusir Godaan Setan',
    'الدعاء حينما يقع ما لا يرضاه أو غلب على أمره':
        'Doa Saat Mengalami Hal yang Tidak Disukai',
    'ﺗﻬنئة المولود له وجوابه': 'Ucapan Selamat Kelahiran dan Jawabannya',
    'ما يعوذ به الأولاد - رقية': 'Doa Perlindungan untuk Anak',
    'الدعاء للمريض في عيادته': 'Doa untuk Orang Sakit Saat Menjenguk',
    'فضل عيادة المريض': 'Keutamaan Menjenguk Orang Sakit',
    'دعاء المريض الذي يئس من حياته': 'Doa Orang Sakit yang Putus Harapan',
    'تلقين المحتضر': 'Talqin untuk Orang yang Sakaratul Maut',
    'دعاء من أصيب بمصيبة': 'Doa Ketika Tertimpa Musibah',
    'الدعاء عند إغماض الميت': 'Doa Saat Memejamkan Mata Jenazah',
    'الدعاء للميت في الصلاة عليه': 'Doa untuk Jenazah dalam Shalat Jenazah',
    'الدعاء للفرط في الصلاة عليه': 'Doa untuk Anak Kecil dalam Shalat Jenazah',
    'دعاء التعزية': 'Doa Takziyah',
    'الدعاء عند إدخال الميت القبر': 'Doa Saat Memasukkan Jenazah ke Kubur',
    'الدعاء بعد دفن الميت': 'Doa Setelah Pemakaman',
    'دعاء زيارة القبور': 'Doa Ziarah Kubur',
    'دعاء الريح': 'Doa Ketika Angin Bertiup',
    'دعاء الرعد': 'Doa Ketika Mendengar Petir',
    'من أدعية الاستسقاء': 'Doa Memohon Hujan',
    'الدعاء إذا نزل المطر': 'Doa Ketika Turun Hujan',
    'الذكر بعد نزول المطر': 'Dzikir Setelah Turun Hujan',
    'من أدعية الاستصحاء': 'Doa Memohon Hujan Berhenti',
    'دعاء رؤية الهلال': 'Doa Melihat Hilal',
    'الدعاء عند إفطار الصائم - الصوم': 'Doa Ketika Berbuka Puasa',
    'الدعاء قبل الطعام': 'Doa Sebelum Makan',
    'الدعاء عند الفراغ من الطعام': 'Doa Setelah Makan',
    'دعاء الضيف لصاحب الطعام': 'Doa Tamu untuk Tuan Rumah',
    'التعريض بالدعاء لطلب الطعام أو الشراب':
        'Doa Isyarat Meminta Makanan atau Minuman',
    'الدعاء إذا أفطر عند أهل بيت - طعام':
        'Doa Saat Berbuka di Rumah Orang Lain',
    'دعاء الصائم إذا حضر الطعام ولم يفطر':
        'Doa Orang Puasa Saat Hidangan Disajikan',
    'ما يقول الصائم إذا سابه أحد':
        'Ucapan Orang Puasa Saat Dicela',
    'الدعاء عند رؤية باكورة الثمر': 'Doa Melihat Buah Pertama',
    'دعاء العطاس': 'Doa Ketika Bersin',
    'ما يقال للكافر إذا عطس فحمد الله':
        'Ucapan untuk Non-Muslim yang Bersin',
    'الدعاء للمتزوج': 'Doa untuk Pengantin',
    'دعاء المتزوج و شراء الدابة':
        'Doa Setelah Menikah dan Membeli Kendaraan',
    'الدعاء قبل إتيان الزوجة - الجماع': 'Doa Sebelum Berhubungan Suami Istri',
    'دعاء الغضب': 'Doa Saat Marah',
    'دعاء من رأى مبتلى': 'Doa Ketika Melihat Orang Tertimpa Ujian',
    'ما يقال في اﻟﻤﺠلس': 'Doa dalam Majelis',
    'كفارة اﻟﻤﺠلس': 'Doa Kafaratul Majelis',
    'الدعاء لمن قال غفر الله لك': 'Doa untuk Orang yang Mendoakan Ampunan',
    'الدعاء لمن صنع إليك معروفا': 'Doa untuk Orang yang Berbuat Baik',
    'ما يعصم الله به من الدجال': 'Doa Perlindungan dari Dajjal',
    'الدعاء لمن قال إني أحبك في الله':
        'Doa untuk Orang yang Mengatakan Cinta Karena Allah',
    'الدعاء لمن عرض عليك ماله': 'Doa untuk Orang yang Menawarkan Hartanya',
    'الدعاء لمن أقرض عند القضاء': 'Doa untuk Pemberi Pinjaman Saat Membayar',
    'دعاء الخوف من الشرك': 'Doa Takut Terjerumus Syirik',
    'الدعاء لمن قال بارك الله فيك':
        'Doa untuk Orang yang Mengucapkan Barakallahu Fiik',
    'دعاء كراهية الطيرة': 'Doa Menolak Tathayyur',
    'دعاء الركوب': 'Doa Naik Kendaraan',
    'دعاء السفر': 'Doa Perjalanan',
    'دعاء دخول القرية أو البلدة': 'Doa Masuk Desa atau Kota',
    'دعاء دخول السوق': 'Doa Masuk Pasar',
    'الدعاء إذا تعس المركوب': 'Doa Saat Kendaraan Tersandung',
    'دعاء المسافر للمقيم': 'Doa Musafir untuk Orang yang Ditinggal',
    'دعاء المقيم للمسافر': 'Doa Orang Mukim untuk Musafir',
    'التكبير و التسبيح في سير السفر':
        'Takbir dan Tasbih dalam Perjalanan',
    'دعاء المسافر إذا أسحر': 'Doa Musafir Ketika Memasuki Waktu Sahur',
    'الدعاء إذا نزل مترلا في سفر أو غيره':
        'Doa Ketika Singgah dalam Perjalanan',
    'ذكر الرجوع من السفر': 'Dzikir Pulang dari Perjalanan',
    'ما يقول من أتاه أمر يسره أو يكرهه':
        'Doa Saat Mendapat Hal Menyenangkan atau Tidak Disukai',
    'فضل الصلاة على النبي صلى الله عليه و سلم':
        'Keutamaan Bershalawat kepada Nabi',
    'إفشاء السلام': 'Menyebarkan Salam',
    'كيف يرد السلام على الكافر إذا سلم':
        'Cara Menjawab Salam Non-Muslim',
    'الدعاء عند سماع صياح الديك ونهيق الحمار':
        'Doa Mendengar Ayam Berkokok dan Keledai Meringkik',
    'دعاء نباح الكلب بالليل': 'Doa Mendengar Gonggongan Anjing di Malam Hari',
    'الدعاء لمن سببته': 'Doa untuk Orang yang Pernah Dicela',
    'ما يقول المسلم إذا مدح المسلم': 'Ucapan Saat Memuji Sesama Muslim',
    'ما يقول المسلم إذا زكي': 'Ucapan Saat Dipuji atau Disucikan',
    'كيف يلبي المحرم في الحج أو العمرة ؟':
        'Talbiyah Orang Ihram dalam Haji atau Umrah',
    'التكبير إذا أتى الركن الأسود': 'Takbir Ketika Mendatangi Hajar Aswad',
    'الدعاء بين الركن اليماني والحجر الأسود':
        'Doa antara Rukun Yamani dan Hajar Aswad',
    'دعاء الوقوف على الصفا والمروة': 'Doa Saat di Shafa dan Marwah',
    'الدعاء يوم عرفة': 'Doa Hari Arafah',
    'الذكر عند المشعر الحرام': 'Dzikir di Masyaril Haram',
    'التكبير عند رمي الجمار مع كل حصاة':
        'Takbir Saat Melempar Jumrah',
    'دعاء التعجب والأمر السار': 'Doa Saat Kagum dan Gembira',
    'ما يفعل من أتاه أمر يسره': 'Amalan Saat Mendapat Kabar Gembira',
    'ما يقول من أحس وجعا في جسده': 'Doa Saat Merasakan Sakit di Tubuh',
    'دعاء من خشي أن يصيب شيئا بعينه':
        'Doa Saat Khawatir Menimpa Sesuatu dengan Ain',
    'ما يقال عند الفزع': 'Doa Saat Terkejut',
    'ما يقول عند الذبح أو النحر': 'Doa Saat Menyembelih',
    'ما يقول لرد كيد مردة الشياطين':
        'Doa Menolak Tipu Daya Setan yang Durhaka',
    'الاستغفار و التوبة': 'Istighfar dan Taubat',
    'التسبيح، التحميد، التهليل، التكبير':
        'Tasbih, Tahmid, Tahlil, dan Takbir',
    'كيف كان النبي يسبح؟': 'Cara Nabi Bertasbih',
    'من أنواع الخير والآداب الجامعة': 'Ragam Kebaikan dan Adab Umum',
    'الرُّقية الشرعية من القرآن الكريم': 'Ruqyah Syar\'iyyah dari Al-Quran',
    'الرُّقية الشرعية من السنة النبوية': 'Ruqyah Syar\'iyyah dari Sunnah',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdhkarCubit, AdhkarState>(
      builder: (context, state) {
        AdhkarCubit cubit = AdhkarCubit.get(context);
        List<AdhkarModel> adhkarList = cubit.adhkarList;
        final adhkarCategories =
            cubit.getAdhkarCategories(adhkarList: adhkarList);
        return ConditionalBuilder(
          condition: adhkarList.isNotEmpty,
          builder: (BuildContext context) {
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _adhkarIndexItem(
                  adhkarId: (index + 1).toString().tr(),
                  adhkarCategory: adhkarCategories[index].orEmpty(),
                  adhkarList: adhkarList,
                  context: context,
                );
              },
              separatorBuilder: (context, index) => getSeparator(context),
              itemCount: adhkarCategories.length,
            );
          },
          fallback: (BuildContext context) {
            return const Center(
                child: CircularProgressIndicator(color: ColorManager.gold));
          },
        );
      },
    );
  }

  Widget _adhkarIndexItem(
      {required String adhkarId,
      required String adhkarCategory,
      required List<AdhkarModel> adhkarList,
      // required String pageNo,
      required BuildContext context}) {
    final indonesianTitle =
        _indonesianCategoryTitles[adhkarCategory] ?? adhkarCategory;

    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.p5.h),
      child: ListTile(
        style: ListTileStyle.list,
        leading: Padding(
          padding: EdgeInsets.only(top: AppPadding.p5.h),
          child: Text(
            adhkarId,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontFamily: FontConstants.uthmanTNFontFamily),
          ),
        ),
        title: Text(
          indonesianTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: FontConstants.elMessiriFontFamily,
              ),
        ),
        subtitle: indonesianTitle == adhkarCategory
            ? null
            : Text(
                adhkarCategory,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: FontConstants.uthmanTNFontFamily,
                    ),
              ),
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.adhkarRoute,
            arguments: {
              'adhkarList': adhkarList,
              'category': adhkarCategory,
            },
          );
        },
      ),
    );
  }
}
