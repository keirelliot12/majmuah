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

  static CategoryVisual forCategory(String category, {Color? fallbackColor}) {
    switch (_normalize(category)) {
      case 'al quran':
        return const CategoryVisual(
          icon: Symbols.menu_book,
          color: AppColors.tealGreen,
        );
      case 'aurad shalat':
      case 'aurad sholat':
      case 'aurad doa':
        return const CategoryVisual(
          icon: Symbols.mosque,
          color: AppColors.emerald500,
          assetPath: 'assets/images/icons/aurad_doa.png',
        );
      case 'doa tawasul':
      case 'doa tawassul':
        return const CategoryVisual(
          icon: Symbols.front_hand,
          color: AppColors.amber500,
        );
      case 'hizib ratib':
        return const CategoryVisual(
          icon: Symbols.auto_stories,
          color: AppColors.indigo500,
          assetPath: 'assets/images/icons/hizib_ratib.png',
        );
      case 'puji bilal':
      case 'puji pujian bilal':
        return const CategoryVisual(
          icon: Symbols.record_voice_over,
          color: AppColors.amber500,
          assetPath: 'assets/images/icons/puji_bilal.png',
        );
      case 'amalan hijriyah':
        return const CategoryVisual(
          icon: Icons.calendar_month_rounded,
          color: AppColors.teal600,
          assetPath: 'assets/images/icons/amalan_hijriyah.png',
        );
      case 'sholawat':
        return const CategoryVisual(
          icon: Symbols.star,
          color: AppColors.rose500,
        );
      case 'ratib':
        return const CategoryVisual(
          icon: Symbols.auto_stories,
          color: AppColors.indigo500,
        );
      case 'hizib':
        return const CategoryVisual(
          icon: Symbols.wb_twilight,
          color: AppColors.teal600,
        );
      case 'maulid':
        return const CategoryVisual(
          icon: Symbols.auto_awesome,
          color: AppColors.orange500,
          assetPath: 'assets/images/icons/maulid.png',
        );
      case 'qasidah':
      case 'qosidah pilihan':
        return const CategoryVisual(
          icon: Icons.music_note_rounded,
          color: AppColors.cyan600,
        );
      case 'tahlil ziarah':
        return const CategoryVisual(
          icon: Symbols.history_edu,
          color: AppColors.teal600,
          assetPath: 'assets/images/icons/tahlil_ziarah.png',
        );
      case 'manaqib istighosah':
        return const CategoryVisual(
          icon: Icons.volunteer_activism_rounded,
          color: AppColors.blue500,
        );
      case 'panduan ibadah':
      case 'kaifiyah':
        return const CategoryVisual(
          icon: Symbols.local_library,
          color: AppColors.tealGreen,
        );
      case 'notes':
        return const CategoryVisual(
          icon: Symbols.edit_note,
          color: AppColors.cyan600,
        );
      case 'khutbah':
        return const CategoryVisual(
          icon: Symbols.record_voice_over,
          color: AppColors.rose500,
        );
      case 'kbihu nur multazam':
      case 'kbihu':
        return const CategoryVisual(
          icon: Icons.account_balance_rounded,
          color: AppColors.blue500,
          assetPath: 'assets/images/icons/kbihu.png',
        );
      case 'profil':
        return const CategoryVisual(
          icon: Icons.badge_outlined,
          color: AppColors.blue500,
        );
      case 'manasik haji':
        return const CategoryVisual(
          icon: Icons.account_balance_outlined,
          color: AppColors.tealGreen,
        );
      case 'manasik umroh':
        return const CategoryVisual(
          icon: Icons.route_outlined,
          color: AppColors.emerald500,
        );
      case 'tempat sejarah':
        return const CategoryVisual(
          icon: Icons.history_edu_outlined,
          color: AppColors.amber500,
        );
      case "do'a":
        return const CategoryVisual(
          icon: Icons.volunteer_activism_outlined,
          color: AppColors.rose500,
        );
      case 'dialog dan hikmah':
        return const CategoryVisual(
          icon: Icons.forum_outlined,
          color: AppColors.indigo500,
        );
      case 'lainnya':
        return const CategoryVisual(
          icon: Symbols.grid_view,
          color: AppColors.gray500,
          assetPath: 'assets/images/icons/lainnya.png',
        );
      default:
        return CategoryVisual(
          icon: Symbols.library_books,
          color: fallbackColor ?? AppColors.tealGreen,
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
