import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/models/note/note_model.dart';

/// Local data source untuk menyimpan dan mengambil notes dari SharedPreferences
class NotesLocalDataSource {
  static const String _notesKey = 'notes_list';
  static const String _lastReadKey = 'last_read_material';
  static const String _bookmarksKey = 'bookmarked_materials';

  final SharedPreferences _prefs;

  NotesLocalDataSource(this._prefs);

  /// Get semua notes
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final notesJson = _prefs.getString(_notesKey);
      if (notesJson == null) return [];

      final List<dynamic> decoded = jsonDecode(notesJson);
      return decoded
          .map((note) => NoteModel.fromJson(note as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notes: $e');
    }
  }

  /// Get note by id
  Future<NoteModel?> getNoteById(String id) async {
    try {
      final notes = await getAllNotes();
      try {
        return notes.firstWhere((note) => note.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get note: $e');
    }
  }

  /// Create note
  Future<void> createNote(NoteModel note) async {
    try {
      final notes = await getAllNotes();
      notes.add(note);
      await _saveNotes(notes);
    } catch (e) {
      throw Exception('Failed to create note: $e');
    }
  }

  /// Update note
  Future<void> updateNote(NoteModel note) async {
    try {
      final notes = await getAllNotes();
      final index = notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        notes[index] = note;
        await _saveNotes(notes);
      }
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  /// Delete note
  Future<void> deleteNote(String id) async {
    try {
      final notes = await getAllNotes();
      notes.removeWhere((note) => note.id == id);
      await _saveNotes(notes);
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  /// Search notes
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      final notes = await getAllNotes();
      final lowerQuery = query.toLowerCase();
      return notes
          .where((note) =>
              note.title.toLowerCase().contains(lowerQuery) ||
              note.content.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      throw Exception('Failed to search notes: $e');
    }
  }

  /// Toggle pin status
  Future<void> togglePin(String id) async {
    try {
      final note = await getNoteById(id);
      if (note != null) {
        final updatedNote = note.copyWith(isPinned: !note.isPinned);
        await updateNote(updatedNote);
      }
    } catch (e) {
      throw Exception('Failed to toggle pin: $e');
    }
  }

  /// Get pinned notes
  Future<List<NoteModel>> getPinnedNotes() async {
    try {
      final notes = await getAllNotes();
      return notes.where((note) => note.isPinned).toList();
    } catch (e) {
      throw Exception('Failed to get pinned notes: $e');
    }
  }

  /// Update note color
  Future<void> updateNoteColor(String id, int colorIndex) async {
    try {
      final note = await getNoteById(id);
      if (note != null) {
        final updatedNote = note.copyWith(colorIndex: colorIndex);
        await updateNote(updatedNote);
      }
    } catch (e) {
      throw Exception('Failed to update note color: $e');
    }
  }

  /// Save last read material
  Future<void> saveLastReadMaterial(String materialId) async {
    try {
      await _prefs.setString(_lastReadKey, materialId);
    } catch (e) {
      throw Exception('Failed to save last read material: $e');
    }
  }

  /// Get last read material id
  Future<String?> getLastReadMaterial() async {
    try {
      return _prefs.getString(_lastReadKey);
    } catch (e) {
      throw Exception('Failed to get last read material: $e');
    }
  }

  /// Get bookmarked materials
  Future<List<String>> getBookmarkedMaterials() async {
    try {
      return _prefs.getStringList(_bookmarksKey) ?? [];
    } catch (e) {
      throw Exception('Failed to get bookmarked materials: $e');
    }
  }

  /// Toggle bookmark
  Future<void> toggleBookmark(String materialId) async {
    try {
      final bookmarks = await getBookmarkedMaterials();
      if (bookmarks.contains(materialId)) {
        bookmarks.remove(materialId);
      } else {
        bookmarks.add(materialId);
      }
      await _prefs.setStringList(_bookmarksKey, bookmarks);
    } catch (e) {
      throw Exception('Failed to toggle bookmark: $e');
    }
  }

  /// Clear all data
  Future<void> clearAll() async {
    try {
      await _prefs.remove(_notesKey);
      await _prefs.remove(_lastReadKey);
      await _prefs.remove(_bookmarksKey);
    } catch (e) {
      throw Exception('Failed to clear notes: $e');
    }
  }

  /// Private method to save notes
  Future<void> _saveNotes(List<NoteModel> notes) async {
    final notesJson =
        jsonEncode(notes.map((note) => note.toJson()).toList());
    await _prefs.setString(_notesKey, notesJson);
  }
}
