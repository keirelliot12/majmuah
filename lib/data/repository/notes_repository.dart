import '../../domain/models/note/note_model.dart';
import '../data_source/local/notes_local_data_source.dart';

/// Repository untuk mengelola notes data
class NotesRepository {
  final NotesLocalDataSource _localDataSource;

  NotesRepository(this._localDataSource);

  /// Get semua notes
  Future<List<NoteModel>> getAllNotes() async {
    try {
      return await _localDataSource.getAllNotes();
    } catch (e) {
      throw Exception('Failed to get all notes: $e');
    }
  }

  /// Get note by id
  Future<NoteModel?> getNoteById(String id) async {
    try {
      return await _localDataSource.getNoteById(id);
    } catch (e) {
      throw Exception('Failed to get note: $e');
    }
  }

  /// Create note
  Future<void> createNote(NoteModel note) async {
    try {
      await _localDataSource.createNote(note);
    } catch (e) {
      throw Exception('Failed to create note: $e');
    }
  }

  /// Update note
  Future<void> updateNote(NoteModel note) async {
    try {
      await _localDataSource.updateNote(note);
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  /// Delete note
  Future<void> deleteNote(String id) async {
    try {
      await _localDataSource.deleteNote(id);
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  /// Search notes
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      return await _localDataSource.searchNotes(query);
    } catch (e) {
      throw Exception('Failed to search notes: $e');
    }
  }

  /// Toggle pin
  Future<void> togglePin(String id) async {
    try {
      await _localDataSource.togglePin(id);
    } catch (e) {
      throw Exception('Failed to toggle pin: $e');
    }
  }

  /// Get pinned notes
  Future<List<NoteModel>> getPinnedNotes() async {
    try {
      return await _localDataSource.getPinnedNotes();
    } catch (e) {
      throw Exception('Failed to get pinned notes: $e');
    }
  }

  /// Update note color
  Future<void> updateNoteColor(String id, int colorIndex) async {
    try {
      await _localDataSource.updateNoteColor(id, colorIndex);
    } catch (e) {
      throw Exception('Failed to update note color: $e');
    }
  }

  /// Clear all notes
  Future<void> clearAllNotes() async {
    try {
      await _localDataSource.clearAll();
    } catch (e) {
      throw Exception('Failed to clear notes: $e');
    }
  }
}
