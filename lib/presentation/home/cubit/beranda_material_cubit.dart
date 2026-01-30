import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/material_content_repository.dart';
import '../../../domain/models/material/material_model.dart';

// ============================================================================
// STATE CLASSES
// ============================================================================

abstract class BerandaMaterialState {
  const BerandaMaterialState();
}

class BerandaMaterialInitial extends BerandaMaterialState {
  const BerandaMaterialInitial();
}

class BerandaMaterialLoading extends BerandaMaterialState {
  const BerandaMaterialLoading();
}

class BerandaMaterialLoaded extends BerandaMaterialState {
  final List<MaterialModel> materials;

  const BerandaMaterialLoaded(this.materials);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BerandaMaterialLoaded &&
          runtimeType == other.runtimeType &&
          materials == other.materials;

  @override
  int get hashCode => materials.hashCode;
}

class BerandaMaterialError extends BerandaMaterialState {
  final String message;

  const BerandaMaterialError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BerandaMaterialError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class BerandaMaterialBookmarkToggled extends BerandaMaterialState {
  const BerandaMaterialBookmarkToggled();
}

// ============================================================================
// CUBIT CLASS
// ============================================================================

class BerandaMaterialCubit extends Cubit<BerandaMaterialState> {
  final MaterialContentRepository _repository;

  BerandaMaterialCubit(this._repository) : super(const BerandaMaterialInitial());

  Future<void> getMaterialsByCategory(String category) async {
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

  Future<void> updateLastRead(String materialId) async {
    try {
      await _repository.updateLastRead(materialId);
    } catch (e) {
      emit(BerandaMaterialError(e.toString()));
    }
  }
}


