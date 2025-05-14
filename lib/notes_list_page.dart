import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes/bloc/theme_bloc/theme_bloc.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/note_edit_page.dart';

class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Заметки'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  searchController.clear();
                  context.read<NotesBloc>().add(const SearchStatusNoteEvent());
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
              PopupMenuButton<ThemeMode>(
                icon: const Icon(Icons.brightness_6),
                onSelected: (themeMode) async {
                  context.read<ThemeBloc>().add(ThemeChangedEvent(themeMode));
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: ThemeMode.light,
                    child: Text('Светлая тема'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Темная тема'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: ThemeMode.system,
                    child: Text('Системная тема'),
                  ),
                ],
              ),
            ],
            bottom: state.isSearch
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(48.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Поиск заметок',
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onSecondary,
                          contentPadding: const EdgeInsets.all(16.0),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              context
                                  .read<NotesBloc>()
                                  .add(const SearchNotesEvent(''));
                            },
                          ),
                        ),
                        onChanged: (value) {
                          context
                              .read<NotesBloc>()
                              .add(SearchNotesEvent(value));
                        },
                      ),
                    ),
                  )
                : null,
          ),
          body: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, state) {
              if (state.status == NotesStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.allNotes.isEmpty) {
                return Center(
                  child: Text(
                    state.searchQuery?.isNotEmpty == true
                        ? 'Ничего не найдено'
                        : 'Заметок нет',
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.searchNotes.length,
                itemBuilder: (context, index) {
                  final note = state.searchNotes[index];
                  return Dismissible(
                    key: Key(note.createdAt.toString()),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      context.read<NotesBloc>().add(DeleteNoteEvent(note));
                    },
                    child: NoteItem(
                      note: note,
                      onTap: () => _navigateToEditScreen(context, note),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () => _navigateToEditScreen(context, null),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _navigateToEditScreen(BuildContext context, Note? note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditPage(note: note),
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteItem({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        DateFormat('HH:mm dd.MM').format(note.createdAt),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.apply(fontSizeFactor: 0.8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          context.read<NotesBloc>().add(DeleteNoteEvent(note));
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
