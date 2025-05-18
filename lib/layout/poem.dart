import 'package:cloud_firestore/cloud_firestore.dart';

class Poem {
  final String id;
  final String title;
  final String content;
  final String author;
  final bool isFavorite;
  final DateTime date;

  Poem({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.isFavorite,
    required this.date,
  });

  factory Poem.fromMap(Map<String, dynamic> map, String id) {
    return Poem(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      author: map['author'] ?? 'Anónimo',
      isFavorite: map['isFavorite'] ?? false,
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'isFavorite': isFavorite,
      'date': date,
    };
  }
}
