import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/notes_repository.dart';
import '../../../domain/models/note/note_model.dart';

// ============================================================================
// STATE CLASSES
// ============================================================================

abstract class BerandaNotesState {
  const BerandaNotesState();
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BerandaNotesLoaded &&
          runtimeType == other.runtimeType &&
          notes == other.notes;

  @override
  int get hashCode => notes.hashCode;
}

class BerandaNotesError extends BerandaNotesState {
  final String message;

  const BerandaNotesError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BerandaNotesError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
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

// ============================================================================
// CUBIT CLASS
// ============================================================================

class BerandaNotesCubit extends Cubit<BerandaNotesState> {
  final NotesRepository _repository;

  BerandaNotesCubit(this._repository) : super(const BerandaNotesInitial());

  Future<void> loadNotes() async {
    try {
      emit(const BerandaNotesLoading());
      final notes = await _repository.getAllNotes();
      emit(BerandaNotesLoaded(notes));
    } catch (e) {
      emit(BerandaNotesError(e.toString()));
    }
  }

  Future<void> createNote(NoteModel note) async {
    try {
      await _repository.createNote(note);
      emit(const BerandaNoteCreated());
      await loadNotes();
    } catch (e) {
      emit(BerandaNotesError(e.toString()));
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      await _repository.updateNote(note);
      emit(const BerandaNoteUpdated());
      await loadNotes();
    } catch (e) {
      emit(BerandaNotesError(e.toString()));
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _repository.deleteNote(id);
      emit(const BerandaNoteDeleted());
      await loadNotes();
    } catch (e) {
      emit(BerandaNotesError(e.toString()));
    }
  }

  Future<void> searchNotes(String query) async {
    try {
      emit(const BerandaNotesLoading());
      final results = await _repository.searchNotes(query);
      emit(BerandaNotesLoaded(results));
    } catch (e) {
      emit(BerandaNotesError(e.toString()));
    }
  }

  Future<void> togglePin(String id) async {
    try {
      await _repository.togglePin(id);
      await loadNotes();
    } catch (e) {
      emit(BerandaNotesError(e.toString()));
    }
  }
}

