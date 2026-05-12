import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/resources/resources.dart';

class CategoryVisual {
  final IconData icon;
  final Color color;
  final String? assetPath;

  const CategoryVisual({
    required this.icon,
    required this.color,
    this.assetPath,
  });
}

class CategoryVisuals {
  const CategoryVisuals._();

  static CategoryVisual forCategory(
    String category, {
    Color? fallbackColor,
    String? assetPath,
  }) {
    switch (_normalize(category)) {
      case 'al quran':
        return CategoryVisual(
          icon: Symbols.menu_book,
          color: AppColors.tealGreen,
          assetPath: assetPath ?? 'assets/icons/al_quran.png',
        );
      case 'aurad shalat':
      case 'aurad sholat':
      case 'aurad doa':
        return CategoryVisual(
          icon: Symbols.mosque,
          color: AppColors.emerald500,
          assetPath: assetPath ?? 'assets/icons/aurad_shalat.png',
        );
      case 'doa tawasul':
      case 'doa tawassul':
        return CategoryVisual(
          icon: Symbols.front_hand,
          color: AppColors.amber500,
          assetPath: assetPath ?? 'assets/icons/doa_tawasul.png',
        );
      case 'hizib ratib':
        return CategoryVisual(
          icon: Symbols.auto_stories,
          color: AppColors.indigo500,
          assetPath: assetPath ?? 'assets/icons/ratib.png',
        );
      case 'puji bilal':
      case 'puji pujian bilal':
        return CategoryVisual(
          icon: Symbols.record_voice_over,
          color: AppColors.amber500,
          assetPath: assetPath ?? 'assets/icons/puji_pujian_bilal.png',
        );
      case 'amalan hijriyah':
        return CategoryVisual(
          icon: Icons.calendar_month_rounded,
          color: AppColors.teal600,
          assetPath: assetPath ?? 'assets/icons/doa_tawasul.png',
        );
      case 'sholawat':
        return CategoryVisual(
          icon: Symbols.star,
          color: AppColors.rose500,
          assetPath: assetPath ?? 'assets/icons/sholawat.png',
        );
      case 'ratib':
        return CategoryVisual(
          icon: Symbols.auto_stories,
          color: AppColors.indigo500,
          assetPath: assetPath ?? 'assets/icons/ratib.png',
        );
      case 'hizib':
        return CategoryVisual(
          icon: Symbols.wb_twilight,
          color: AppColors.teal600,
          assetPath: assetPath ?? 'assets/icons/ratib.png',
        );
      case 'maulid':
        return CategoryVisual(
          icon: Symbols.auto_awesome,
          color: AppColors.orange500,
          assetPath: assetPath ?? 'assets/icons/maulid.png',
        );
      case 'qasidah':
      case 'qosidah pilihan':
        return CategoryVisual(
          icon: Icons.music_note_rounded,
          color: AppColors.cyan600,
          assetPath: assetPath ?? 'assets/icons/qasidah.png',
        );
      case 'tahlil ziarah':
        return CategoryVisual(
          icon: Symbols.history_edu,
          color: AppColors.teal600,
          assetPath: assetPath ?? 'assets/icons/tahlil_ziarah.png',
        );
      case 'manaqib istighosah':
        return CategoryVisual(
          icon: Icons.volunteer_activism_rounded,
          color: AppColors.blue500,
          assetPath: assetPath,
        );
      case 'panduan ibadah':
      case 'kaifiyah':
        return CategoryVisual(
          icon: Symbols.local_library,
          color: AppColors.tealGreen,
          assetPath: assetPath ?? 'assets/icons/panduan_ibadah.png',
        );
      case 'notes':
        return CategoryVisual(
          icon: Symbols.edit_note,
          color: AppColors.cyan600,
          assetPath: assetPath,
        );
      case 'khutbah':
        return CategoryVisual(
          icon: Symbols.record_voice_over,
          color: AppColors.rose500,
          assetPath: assetPath,
        );
      case 'kbihu nur multazam':
      case 'kbihu':
        return CategoryVisual(
          icon: Icons.account_balance_rounded,
          color: AppColors.blue500,
          assetPath: assetPath ?? 'assets/icons/kbihu_nur_multazam.png',
        );
      case 'profil':
        return CategoryVisual(
          icon: Icons.badge_outlined,
          color: AppColors.blue500,
          assetPath: assetPath ?? 'assets/icons/kbihu_profil.png',
        );
      case 'manasik haji':
        return CategoryVisual(
          icon: Icons.account_balance_outlined,
          color: AppColors.tealGreen,
          assetPath: assetPath ?? 'assets/icons/kbihu_manasik_haji.png',
        );
      case 'manasik umroh':
        return CategoryVisual(
          icon: Icons.route_outlined,
          color: AppColors.emerald500,
          assetPath: assetPath ?? 'assets/icons/kbihu_manasik_umroh.png',
        );
      case 'tempat sejarah':
        return CategoryVisual(
          icon: Icons.history_edu_outlined,
          color: AppColors.amber500,
          assetPath: assetPath ?? 'assets/icons/kbihu_tempat_sejarah.png',
        );
      case "do'a":
        return CategoryVisual(
          icon: Icons.volunteer_activism_outlined,
          color: AppColors.rose500,
          assetPath: assetPath ?? 'assets/icons/kbihu_doa.png',
        );
      case 'dialog dan hikmah':
        return CategoryVisual(
          icon: Icons.forum_outlined,
          color: AppColors.indigo500,
          assetPath: assetPath ?? 'assets/icons/kbihu_dialog_hikmah.png',
        );
      case 'lainnya':
        return CategoryVisual(
          icon: Symbols.grid_view,
          color: AppColors.gray500,
          assetPath: assetPath ?? 'assets/icons/lainnya.png',
        );
      default:
        return CategoryVisual(
          icon: Symbols.library_books,
          color: fallbackColor ?? AppColors.tealGreen,
          assetPath: assetPath,
        );
    }
  }

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('&', ' ')
        .replaceAll("'", '')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
