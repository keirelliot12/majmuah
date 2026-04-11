import 'package:equatable/equatable.dart';
import '../../../domain/models/note/note_model.dart';

abstract class BerandaNotesState extends Equatable {
  const BerandaNotesState();

  @override
  List<Object?> get props => [];
}

class BerandaNotesInitial extends BerandaNotesState {
  const BerandaNotesInitial();
}

class BerandaNotesLoading extends BerandaNotesState {
  const BerandaNotesLoading();
}

class BerandaNotesLoaded extends BerandaNotesState {
  final List<NoteModel> notes;

  const BerandaNotesLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class BerandaNotesError extends BerandaNotesState {
  final String message;

  const BerandaNotesError(this.message);

  @override
  List<Object?> get props => [message];
}

class BerandaNoteCreated extends BerandaNotesState {
  const BerandaNoteCreated();
}

class BerandaNoteUpdated extends BerandaNotesState {
  const BerandaNoteUpdated();
}

class BerandaNoteDeleted extends BerandaNotesState {
  const BerandaNoteDeleted();
}
