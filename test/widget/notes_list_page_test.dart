import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/notes_list_page.dart';

import '../test_helpers/fake_notes_repository.dart';

void main() {
  group('NotesListPage Widget Tests', () {
    late FakeNotesRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeNotesRepository();
    });

    testWidgets('Displays empty state when no notes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => NotesBloc(fakeRepository),
            child: const NotesListPage(),
          ),
        ),
      );

      expect(find.text('Заметок нет'), findsOneWidget);
    });

    testWidgets('Displays notes when they exist', (tester) async {
      await fakeRepository.addNote(Note(
          title: 'Тестовая заметка',
          content: 'Текст',
          createdAt: DateTime.now()));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => NotesBloc(fakeRepository)..add(LoadNotesEvent()),
            child: const NotesListPage(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Тестовая заметка'), findsOneWidget);
      expect(find.text('Текст'), findsOneWidget);
    });
  });
}
