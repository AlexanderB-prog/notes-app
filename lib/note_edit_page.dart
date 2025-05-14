import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes/models/note_model.dart';

class NoteEditPage extends StatefulWidget {
  const NoteEditPage({super.key, required this.note});

  final Note? note;

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  String? title;
  String? content;

  @override
  void initState() {
    title = widget.note?.title;
    content = widget.note?.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(widget.note != null ? 'Редактирование' : 'Создание'),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Заголовок заметки',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextFormField(
              initialValue: title,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onSecondary,
                contentPadding: const EdgeInsets.all(16.0),
              ),
              onChanged: (value) => setState(
                () {
                  title = value;
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Текст заметки',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: content,
                maxLines: 10,
                minLines: 1,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onSecondary,
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                onChanged: (value) => setState(
                  () {
                    content = value;
                  },
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: !(title?.isNotEmpty == true) ||
                      (content == widget.note?.content &&
                          title == widget.note?.title)
                  ? null
                  : () {
                      if (widget.note == null) {
                        context.read<NotesBloc>().add(
                              AddNoteEvent(
                                Note(
                                  title: title ?? '',
                                  content: content ?? '',
                                  createdAt: DateTime.now(),
                                ),
                              ),
                            );
                      } else {
                        context.read<NotesBloc>().add(
                              UpdateNoteEvent(
                                widget.note!,
                                Note(
                                  title: title ?? '',
                                  content: content ?? '',
                                  createdAt: DateTime.now(),
                                ),
                              ),
                            );
                      }
                      Navigator.of(context).pop();
                    },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Сохранить',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}
