import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../../di/di.dart';
import '../home/cubit/beranda_material_cubit.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;

  const SearchResultScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BerandaMaterialCubit>()..searchMaterials(query),
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: Text('Cari: $query'),
          centerTitle: true,
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.darkTeal,
          elevation: 0,
        ),
        body: BlocBuilder<BerandaMaterialCubit, BerandaMaterialState>(
          builder: (context, state) {
            if (state is BerandaMaterialLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BerandaMaterialLoaded) {
              final materials = state.materials;
              if (materials.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.builder(
                padding: EdgeInsets.all(AppPadding.p16.w),
                itemCount: materials.length,
                itemBuilder: (context, index) {
                  final material = materials[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    child: ListTile(
                      title: Text(material.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(material.category, style: TextStyle(color: AppColors.tealGreen, fontSize: 12.sp)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.materialDetailRoute,
                          arguments: {
                            'material': material,
                            'categoryColor': AppColors.tealGreen,
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Gagal melakukan pencarian'));
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80.r, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          const Text('Hasil tidak ditemukan', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
