import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/category_repository.dart';
import '../../../domain/models/category/category_model.dart';

part 'beranda_category_state.dart';

class BerandaCategoryCubit extends Cubit<BerandaCategoryState> {
  final CategoryRepository _repository;

  BerandaCategoryCubit(this._repository) : super(const BerandaCategoryInitial());

  Future<void> loadCategories() async {
    try {
      emit(const BerandaCategoryLoading());
      final categories = await _repository.getAllCategories();
      emit(BerandaCategoryLoaded(categories));
    } catch (e) {
      emit(BerandaCategoryError(e.toString()));
    }
  }

  Future<void> searchCategories(String query) async {
    try {
      emit(const BerandaCategoryLoading());
      final results = await _repository.searchCategories(query);
      emit(BerandaCategoryLoaded(results));
    } catch (e) {
      emit(BerandaCategoryError(e.toString()));
    }
  }
}
