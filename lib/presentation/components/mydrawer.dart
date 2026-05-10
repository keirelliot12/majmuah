import 'package:flutter/material.dart';
import '../../app/resources/resources.dart';
import '../../data/repository/material_content_repository.dart';
import '../../di/di.dart';
import '../home/helpers/category_visuals.dart';
import 'app_brand_logo.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: AppSize.s200 * 1.2,
      child: Padding(
        padding: const EdgeInsets.only(top: AppPadding.p40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p20),
              child: AppBrandLogo(size: 54, showLabel: true),
            ),
            const SizedBox(height: AppSize.s24),
            _drawerItem(
              context: context,
              icon: Icons.download_for_offline_outlined,
              title: 'Kelola Unduhan',
              subtitle: 'Mushaf dan data offline',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.downloadManagerRoute);
              },
            ),
            _drawerItem(
              context: context,
              icon: Icons.menu_book_outlined,
              title: 'Lanjutkan Bacaan',
              subtitle: 'Buka bacaan terakhir',
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                final lastRead = await instance<MaterialContentRepository>()
                    .getLastReadMaterial();

                navigator.pop();

                if (lastRead == null) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Belum ada bacaan terakhir.')),
                  );
                  return;
                }

                final categoryVisual = CategoryVisuals.forCategory(
                  lastRead.category,
                );

                navigator.pushNamed(
                  Routes.materialDetailRoute,
                  arguments: {
                    'material': lastRead,
                    'categoryColor': categoryVisual.color,
                  },
                );
              },
            ),
            _drawerItem(
              context: context,
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              subtitle: 'Annibros dan versi aplikasi',
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Annibros'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Versi pengembangan'),
                        SizedBox(height: AppSize.s16),
                        Text(
                          'Annibros adalah aplikasi bacaan Islami digital '
                          'untuk membantu akses materi ibadah dan mushaf '
                          'secara praktis.',
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          top: AppMargin.m16,
          left: AppMargin.m16,
          right: AppMargin.m16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p14,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSize.s16),
          border: Border.all(color: AppColors.softBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.emerald),
            const SizedBox(width: AppSize.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppSize.s16,
                      color: AppColors.deepEmerald,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSize.s4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: AppSize.s12,
                      color: AppColors.mutedEmerald,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.mutedEmerald),
          ],
        ),
      ),
    );
  }
}
