import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/resources/resources.dart';

class CategoryVisual {
  final IconData icon;
  final Color color;

  const CategoryVisual({
    required this.icon,
    required this.color,
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
        return const CategoryVisual(
          icon: Symbols.mosque,
          color: AppColors.emerald500,
        );
      case 'doa tawasul':
      case 'doa tawassul':
        return const CategoryVisual(
          icon: Symbols.front_hand,
          color: AppColors.amber500,
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
        );
      case 'qasidah':
        return const CategoryVisual(
          icon: Icons.music_note_rounded,
          color: AppColors.cyan600,
        );
      case 'tahlil ziarah':
        return const CategoryVisual(
          icon: Symbols.history_edu,
          color: AppColors.teal600,
        );
      case 'manaqib istighosah':
        return const CategoryVisual(
          icon: Icons.volunteer_activism_rounded,
          color: AppColors.blue500,
        );
      case 'puji pujian bilal':
        return const CategoryVisual(
          icon: Symbols.record_voice_over,
          color: AppColors.amber500,
        );
      case 'panduan ibadah':
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
      case 'lainnya':
        return const CategoryVisual(
          icon: Symbols.grid_view,
          color: AppColors.gray500,
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
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
