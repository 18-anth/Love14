class Poem {
  final String id;
  final String title;
  final String content;
  final String author;
  bool isFavorite;
  final DateTime date;

  Poem({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    this.isFavorite = false,
    required this.date,
  });
}