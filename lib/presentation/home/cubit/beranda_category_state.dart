part of 'beranda_category_cubit.dart';

abstract class BerandaCategoryState {
  const BerandaCategoryState();
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
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BerandaCategoryLoaded &&
              runtimeType == other.runtimeType &&
              categories == other.categories;

  @override
  int get hashCode => categories.hashCode;
}

class BerandaCategoryError extends BerandaCategoryState {
  final String message;

  const BerandaCategoryError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BerandaCategoryError &&
              runtimeType == other.runtimeType &&
              message == other.message;

  @override
  int get hashCode => message.hashCode;
}