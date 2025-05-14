import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String title;
  final String content;
  final DateTime createdAt;

  const Note({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [title, content, createdAt];
}
