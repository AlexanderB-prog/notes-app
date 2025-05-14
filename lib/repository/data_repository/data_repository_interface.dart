import 'package:notes/models/note_model.dart';

abstract interface class DataRepositoryInterface {
  Future<void> close();

  Future<List<Note>> getAllNotes();

  Future<void> addNote(Note note);

  Future<void> deleteNote(Note note);

  Future<void> updateNote({
    required Note oldNote,
    required Note note,
  });
}
