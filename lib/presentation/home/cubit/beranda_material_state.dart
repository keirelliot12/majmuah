import 'package:equatable/equatable.dart';
import '../../../domain/models/material/material_model.dart';

abstract class BerandaMaterialState extends Equatable {
  const BerandaMaterialState();

  @override
  List<Object?> get props => [];
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
  List<Object?> get props => [materials];
}

class BerandaMaterialError extends BerandaMaterialState {
  final String message;

  const BerandaMaterialError(this.message);

  @override
  List<Object?> get props => [message];
}

class BerandaMaterialBookmarkToggled extends BerandaMaterialState {
  const BerandaMaterialBookmarkToggled();
}

class BerandaLastReadLoaded extends BerandaMaterialState {
  final MaterialModel? lastRead;

  const BerandaLastReadLoaded(this.lastRead);

  @override
  List<Object?> get props => [lastRead];
}
