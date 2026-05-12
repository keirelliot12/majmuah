import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:annibros/presentation/home/cubit/beranda_notes_cubit.dart';
import 'package:annibros/presentation/home/cubit/beranda_notes_state.dart';
import 'package:annibros/data/repository/notes_repository.dart';
import 'package:annibros/domain/models/note/note_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'beranda_notes_cubit_test.mocks.dart';

@GenerateMocks([NotesRepository])
void main() {
  late MockNotesRepository mockRepository;
  late BerandaNotesCubit cubit;

  setUp(() {
    mockRepository = MockNotesRepository();
    cubit = BerandaNotesCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  final tNote = NoteModel(
    id: '1',
    title: 'Test Note',
    content: 'Content',
  );

  group('BerandaNotesCubit', () {
    test('initial state should be BerandaNotesInitial', () {
      expect(cubit.state, BerandaNotesInitial());
    });

    blocTest<BerandaNotesCubit, BerandaNotesState>(
      'emits [Loading, Loaded] when loadNotes is successful',
      build: () {
        when(mockRepository.getAllNotes())
            .thenAnswer((_) async => [tNote]);
        return cubit;
      },
      act: (cubit) => cubit.loadNotes(),
      expect: () => [
        BerandaNotesLoading(),
        BerandaNotesLoaded([tNote]),
      ],
    );

    blocTest<BerandaNotesCubit, BerandaNotesState>(
      'emits [Created, Loading, Loaded] when createNote is successful',
      build: () {
        when(mockRepository.createNote(any))
            .thenAnswer((_) async => {});
        when(mockRepository.getAllNotes())
            .thenAnswer((_) async => [tNote]);
        return cubit;
      },
      act: (cubit) => cubit.createNote(tNote),
      expect: () => [
        BerandaNoteCreated(),
        BerandaNotesLoading(),
        BerandaNotesLoaded([tNote]),
      ],
    );
  });
}
