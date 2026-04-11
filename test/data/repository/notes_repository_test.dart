import 'package:flutter_test/flutter_test.dart';
import 'package:islamic/data/data_source/local/notes_local_data_source.dart';
import 'package:islamic/data/repository/notes_repository.dart';
import 'package:islamic/domain/models/note/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('NotesRepository Tests', () {
    late NotesRepository repository;
    late NotesLocalDataSource localDataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      localDataSource = NotesLocalDataSource(prefs);
      repository = NotesRepository(localDataSource);
    });

    test('should create and retrieve note', () async {
      // Arrange
      final note = NoteModel(
        title: 'Test Note',
        content: 'Test Content',
      );

      // Act
      await repository.createNote(note);
      final retrieved = await repository.getNoteById(note.id);

      // Assert
      expect(retrieved, isNotNull);
      expect(retrieved!.title, equals('Test Note'));
      expect(retrieved.content, equals('Test Content'));
    });

    test('should update note', () async {
      // Arrange
      final note = NoteModel(
        title: 'Original Title',
        content: 'Original Content',
      );
      await repository.createNote(note);

      // Act
      final updated = note.copyWith(
        title: 'Updated Title',
        updatedAt: DateTime.now(),
      );
      await repository.updateNote(updated);
      final retrieved = await repository.getNoteById(note.id);

      // Assert
      expect(retrieved!.title, equals('Updated Title'));
    });

    test('should delete note', () async {
      // Arrange
      final note = NoteModel(
        title: 'To Delete',
        content: 'Will be deleted',
      );
      await repository.createNote(note);

      // Act
      await repository.deleteNote(note.id);
      final retrieved = await repository.getNoteById(note.id);

      // Assert
      expect(retrieved, isNull);
    });

    test('should get all notes', () async {
      // Arrange
      final note1 = NoteModel(title: 'Note 1', content: 'Content 1');
      final note2 = NoteModel(title: 'Note 2', content: 'Content 2');
      await repository.createNote(note1);
      await repository.createNote(note2);

      // Act
      final allNotes = await repository.getAllNotes();

      // Assert
      expect(allNotes.length, equals(2));
    });

    test('should search notes', () async {
      // Arrange
      final note1 = NoteModel(title: 'Flutter Tutorial', content: 'Learn Flutter');
      final note2 = NoteModel(title: 'Dart Guide', content: 'Learn Dart');
      await repository.createNote(note1);
      await repository.createNote(note2);

      // Act
      final results = await repository.searchNotes('flutter');

      // Assert
      expect(results.length, equals(1));
      expect(results.first.title, contains('Flutter'));
    });

    test('should toggle pin', () async {
      // Arrange
      final note = NoteModel(title: 'Pin Test', content: 'Test');
      await repository.createNote(note);

      // Act
      await repository.togglePin(note.id);
      var retrieved = await repository.getNoteById(note.id);
      expect(retrieved!.isPinned, isTrue);

      await repository.togglePin(note.id);
      retrieved = await repository.getNoteById(note.id);

      // Assert
      expect(retrieved!.isPinned, isFalse);
    });

    test('should get pinned notes', () async {
      // Arrange
      final note1 = NoteModel(title: 'Note 1', content: 'Content 1');
      final note2 = NoteModel(title: 'Note 2', content: 'Content 2');
      await repository.createNote(note1);
      await repository.createNote(note2);
      await repository.togglePin(note1.id);

      // Act
      final pinnedNotes = await repository.getPinnedNotes();

      // Assert
      expect(pinnedNotes.length, equals(1));
      expect(pinnedNotes.first.id, equals(note1.id));
    });

    test('should update note color', () async {
      // Arrange
      final note = NoteModel(title: 'Color Test', content: 'Test');
      await repository.createNote(note);

      // Act
      await repository.updateNoteColor(note.id, 3);
      final retrieved = await repository.getNoteById(note.id);

      // Assert
      expect(retrieved!.colorIndex, equals(3));
    });

    test('should clear all notes', () async {
      // Arrange
      final note1 = NoteModel(title: 'Note 1', content: 'Content 1');
      final note2 = NoteModel(title: 'Note 2', content: 'Content 2');
      await repository.createNote(note1);
      await repository.createNote(note2);

      // Act
      await repository.clearAllNotes();
      final allNotes = await repository.getAllNotes();

      // Assert
      expect(allNotes, isEmpty);
    });
  });
}
