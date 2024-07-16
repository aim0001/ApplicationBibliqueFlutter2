class Verse {
  final String book;
  final int chapter;
  final int verse;
  final String text;
  Verse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text
  });

  // Méthode Factory pour créer un objet Verse à partir de données JSON
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      book: json['book'],
      chapter: json['chapter'],
      verse: json['verse'],
      text: json['text'],
    );
  }
}
