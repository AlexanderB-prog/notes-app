part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotesEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final Note note;

  const AddNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNoteEvent extends NotesEvent {
  final Note oldNote;
  final Note note;

  const UpdateNoteEvent(
    this.oldNote,
    this.note,
  );

  @override
  List<Object> get props => [note];
}

class DeleteNoteEvent extends NotesEvent {
  final Note note;

  const DeleteNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class SearchStatusNoteEvent extends NotesEvent {

  const SearchStatusNoteEvent();

  @override
  List<Object> get props => [];
}

class SearchNotesEvent extends NotesEvent {
  final String query;

  const SearchNotesEvent(this.query);

  @override
  List<Object> get props => [query];
}
