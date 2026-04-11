import 'package:flutter/material.dart';
import '../../presentation/home/cubit/beranda_material_cubit.dart';
import '../../presentation/home/cubit/beranda_material_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/di.dart';
import '../../domain/models/material/material_model.dart';

class MaterialSearchDelegate extends SearchDelegate<MaterialModel?> {
  @override
  String? get searchFieldLabel => 'Cari Surah, Wirid, atau Doa...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Cari materi favoritmu'),
      );
    }
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BerandaMaterialCubit>()..searchMaterials(query),
      child: BlocBuilder<BerandaMaterialCubit, BerandaMaterialState>(
        builder: (context, state) {
          if (state is BerandaMaterialLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BerandaMaterialLoaded) {
            final results = state.materials;
            if (results.isEmpty) {
              return const Center(child: Text('Tidak ada hasil ditemukan'));
            }
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final material = results[index];
                return ListTile(
                  title: Text(material.title),
                  subtitle: Text(material.category),
                  onTap: () {
                    close(context, material);
                  },
                );
              },
            );
          } else if (state is BerandaMaterialError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }
}
