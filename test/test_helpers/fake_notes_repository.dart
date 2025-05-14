import 'package:notes/models/note_model.dart';
import 'package:notes/repository/data_repository/data_repository_interface.dart';

class FakeNotesRepository implements DataRepositoryInterface {
  final List<Note> _notes = [];

  @override
  Future<List<Note>> getAllNotes() async {
    return List<Note>.from(_notes);
  }

  @override
  Future<void> addNote(Note note) async {
    _notes.add(note);
  }

  @override
  Future<void> deleteNote(Note note) async {
    _notes.removeWhere((n) => n.createdAt == note.createdAt);
  }

  @override
  Future<void> updateNote({required Note oldNote, required Note note}) async {
    final index = _notes.indexWhere((n) => n.createdAt == oldNote.createdAt);
    if (index != -1) {
      _notes[index] = note;
    }
  }

  @override
  Future<void> close() async {}
}