part of 'beranda_category_cubit.dart';

abstract class BerandaCategoryState extends Equatable {
  const BerandaCategoryState();

  @override
  List<Object?> get props => [];
}

class BerandaCategoryInitial extends BerandaCategoryState {
  const BerandaCategoryInitial();
}

class BerandaCategoryLoading extends BerandaCategoryState {
  const BerandaCategoryLoading();
}

class BerandaCategoryLoaded extends BerandaCategoryState {
  final List<CategoryModel> categories;

  const BerandaCategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class BerandaCategoryError extends BerandaCategoryState {
  final String message;

  const BerandaCategoryError(this.message);

  @override
  List<Object?> get props => [message];
}