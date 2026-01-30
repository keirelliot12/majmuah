import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/material_content_repository.dart';
import 'beranda_material_state.dart';

// ============================================================================
// CUBIT CLASS
// ============================================================================

class BerandaMaterialCubit extends Cubit<BerandaMaterialState> {
  final MaterialContentRepository _repository;

  BerandaMaterialCubit(this._repository) : super(const BerandaMaterialInitial());

  Future<void> loadMaterialsByCategory(String category) async {
    try {
      emit(const BerandaMaterialLoading());
      final materials = await _repository.getMaterialsByCategory(category);
      emit(BerandaMaterialLoaded(materials));
    } catch (e) {
      emit(BerandaMaterialError(e.toString()));
    }
  }

  Future<void> searchMaterials(String query) async {
    try {
      emit(const BerandaMaterialLoading());
      final results = await _repository.searchMaterials(query);
      emit(BerandaMaterialLoaded(results));
    } catch (e) {
      emit(BerandaMaterialError(e.toString()));
    }
  }

  Future<void> toggleBookmark(String materialId) async {
    try {
      await _repository.toggleBookmark(materialId);
      emit(const BerandaMaterialBookmarkToggled());
    } catch (e) {
      emit(BerandaMaterialError(e.toString()));
    }
  }

  Future<void> setLastRead(String materialId) async {
    try {
      await _repository.updateLastRead(materialId);
    } catch (e) {
      emit(BerandaMaterialError(e.toString()));
    }
  }

  Future<void> getLastRead() async {
    try {
      final lastRead = await _repository.getLastReadMaterial();
      emit(BerandaLastReadLoaded(lastRead));
    } catch (e) {
      emit(BerandaMaterialError(e.toString()));
    }
  }
}
