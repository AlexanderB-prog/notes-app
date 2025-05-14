import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/repository/data_repository/data_repository_interface.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final DataRepositoryInterface dataRepository;

  NotesBloc(this.dataRepository) : super(const NotesState()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<SearchStatusNoteEvent>(_onSearchStatusNote);
    on<SearchNotesEvent>(_onSearchNotes);
  }

  Future<void> _onLoadNotes(
    LoadNotesEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      final notes = await dataRepository.getAllNotes();
      emit(
        state.copyWith(
          status: NotesStatus.success,
          allNotes: notes,
          searchNotes: notes,
        ),
      );
      emit(state.copyWithFiltered(query: state.searchQuery ?? ''));
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesStatus.failure,
          errorMessage: 'Ошибка загрузки заметок',
        ),
      );
    }
  }

  Future<void> _onAddNote(AddNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await dataRepository.addNote(event.note);
      add(LoadNotesEvent());
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesStatus.failure,
          errorMessage: 'Ошибка добавления заметки',
        ),
      );
    }
  }

  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await dataRepository.addNote(event.note);
      await dataRepository.deleteNote(event.oldNote);
      add(LoadNotesEvent());
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesStatus.failure,
          errorMessage: 'Ошибка обновления заметки',
        ),
      );
    }
  }

  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await dataRepository.deleteNote(event.note);
      add(LoadNotesEvent());
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesStatus.failure,
          errorMessage: 'Ошибка удаления заметки',
        ),
      );
    }
  }

  void _onSearchStatusNote(
    SearchStatusNoteEvent event,
    Emitter<NotesState> emit,
  ) {
    try {
      emit(
        state.copyWith(
          status: NotesStatus.success,
          searchQuery: '',
          isSearch: !state.isSearch,
        ),
      );
      emit(state.copyWithFiltered());
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesStatus.failure,
          errorMessage: 'Ошибка поиска заметки',
        ),
      );
    }
  }

  void _onSearchNotes(SearchNotesEvent event, Emitter<NotesState> emit) {
    try {
      emit(state.copyWithFiltered(query: event.query));
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesStatus.failure,
          errorMessage: 'Ошибка поиска заметки',
        ),
      );
    }
  }
}
