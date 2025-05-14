import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:notes/repository/data_repository/data_repository_interface.dart';
import 'package:notes/repository/data_repository/data_repository_isar.dart';

DataRepositoryInterface dataRepository() {
  if (kIsWeb) {
    return DataRepositoryIsar();
  } else {
    return DataRepositoryIsar();
  }
}
