import 'package:isar/isar.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/repository/data_repository/data_repository_interface.dart';
import 'package:notes/repository/data_repository/note_data.dart';
import 'package:path_provider/path_provider.dart';

class DataRepositoryIsar implements DataRepositoryInterface {
  late Future<Isar> db;

  DataRepositoryIsar() {
    db = _openDatabase();
  }

  Future<Isar> _openDatabase() async {
    Isar? isar = Isar.getInstance();

    if (isar == null) {
      final dir = await getApplicationSupportDirectory();
      isar = await Isar.open(
        [NoteDataSchema],
        directory: dir.path,
      );
    }

    return isar;
  }

  @override
  Future<void> close() async {
    final isar = await db;
    await isar.close();
  }

  @override
  Future<List<Note>> getAllNotes() async {
    final isar = await db;
    return (await isar.noteDatas.where().sortByCreatedAtDesc().findAll())
        .map(
          (noteData) => noteData.toLocal(),
        )
        .toList();
  }

  @override
  Future<void> addNote(Note note) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.noteDatas.put(NoteData.fromLocal(note));
    });
  }

  @override
  Future<void> deleteNote(Note note) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.noteDatas.where().createdAtEqualTo(note.createdAt).deleteAll();
    });
  }

  @override
  Future<void> updateNote({
    required Note oldNote,
    required Note note,
  }) async {
    await deleteNote(oldNote);
    await addNote(note);
  }
}
