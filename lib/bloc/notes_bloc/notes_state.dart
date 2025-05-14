part of 'notes_bloc.dart';

class NotesState extends Equatable {
  final NotesStatus status;
  final List<Note> allNotes;
  final List<Note> searchNotes;
  final String? searchQuery;
  final String? errorMessage;
  final bool isSearch;

  const NotesState({
    this.status = NotesStatus.initial,
    this.allNotes = const [],
    this.searchNotes = const [],
    this.searchQuery,
    this.errorMessage,
    this.isSearch = false,
  });

  @override
  List<Object?> get props => [
        status,
        allNotes,
        searchNotes,
        errorMessage,
        searchQuery,
        isSearch,
      ];

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? allNotes,
    List<Note>? searchNotes,
    String? searchQuery,
    String? errorMessage,
    bool? isSearch,
  }) {
    return NotesState(
      status: status ?? this.status,
      allNotes: allNotes ?? this.allNotes,
      searchNotes: searchNotes ?? this.searchNotes,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      isSearch: isSearch ?? this.isSearch,
    );
  }

  NotesState copyWithFiltered({String? query}) {
    final searchQuery = query ?? this.searchQuery;
    final filtered = searchQuery?.isNotEmpty == true
        ? allNotes
            .where(
              (note) =>
                  note.title
                      .toLowerCase()
                      .contains(searchQuery!.toLowerCase()) ||
                  note.content
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()),
            )
            .toList()
        : allNotes;

    return NotesState(
      status: status,
      allNotes: allNotes,
      searchNotes: filtered,
      searchQuery: searchQuery,
      errorMessage: errorMessage,
      isSearch: isSearch,
    );
  }
}

enum NotesStatus { initial, loading, success, failure }
