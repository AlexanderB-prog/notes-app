import 'package:isar/isar.dart';
import 'package:notes/models/note_model.dart';

part 'note_data.g.dart';

@collection
class NoteData {
  Id id = Isar.autoIncrement;
  late String title;
  late String content;
  @Index()
  late DateTime createdAt;

  NoteData();

  Note toLocal() => Note(
        title: title,
        content: content,
        createdAt: createdAt,
      );

  NoteData.fromLocal(Note note) {
    title = note.title;
    content = note.content;
    createdAt = note.createdAt;
  }
}
