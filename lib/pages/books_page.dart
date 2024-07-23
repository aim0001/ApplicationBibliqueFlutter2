import 'dart:async';

import 'package:application_biblique/services/fetch_books.dart';
import 'package:application_biblique/services/fetch_verses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:application_biblique/models/book.dart';
import 'package:application_biblique/models/chapiter.dart';
import 'package:application_biblique/providers/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:expandable/expandable.dart';

class BooksPage extends StatefulWidget {
  final int chapterIdx;
  final String bookIdx;
  final String selectedLanguage;

  const BooksPage({
    super.key,
    required this.chapterIdx,
    required this.bookIdx,
    required this.selectedLanguage,
  });

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final AutoScrollController _autoScrollController = AutoScrollController();
  String stringNTestament = "";
  String stringOTestament = "";
  String stringBook = "";
  List<Book> books = [];
  List<String> translatedTitles = [];
  Book? currentBook;

  final ExpandableController _oldTestamentController = ExpandableController();
  final ExpandableController _newTestamentController = ExpandableController();

  @override
  void initState() {
    super.initState(); 
    _translateTestamentTitles();
    _translateBookTitles();
  }

  Future<void> _translateBookTitles() async {
    MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: false);
    books = mainProvider.books;

await Future.wait([
      FetchVerses.execute(
          mainProvider: mainProvider, languageCode: widget.selectedLanguage),
      FetchBooks.execute(mainProvider: mainProvider),
    ]);
    print("Liste des livres : ${books.map((book) => book.title).join(', ')}");

    print(widget.selectedLanguage);

    if (books.isEmpty) {
      // Handle the case where there are no books
      setState(() {
        currentBook = null;
        translatedTitles = [];
      });
      return;
    }

    // Find the current book, or handle the case where it is not found
    try {
      currentBook = books.firstWhere(
        (element) => element.title == mainProvider.currentVerse!.book,
      );
    } catch (e) {
      // Handle the case where the current book is not found
      setState(() {
        currentBook = null;
        translatedTitles = [];
      });
      return;
    }

    int index = books.indexOf(currentBook!);
    _autoScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: Duration(milliseconds: (10 * books.length)),
    );

    translatedTitles = books
        .map((book) =>
            getTranslatedBookTitle(book.title, widget.selectedLanguage))
        .toList();
    setState(() {});
  }

  Future<void> _translateTestamentTitles() async {

    stringNTestament =
        getTranslatedBookTitle("Nouveau Testament", widget.selectedLanguage);
    stringOTestament =
        getTranslatedBookTitle("Ancien Testament", widget.selectedLanguage);
    stringBook = getTranslatedBookTitle("Livres", widget.selectedLanguage);
  }

  String getTranslatedBookTitle(String bookTitle, String languageCode) {
    return bookTitles[languageCode]?[bookTitle] ??
        bookTitle; // Return the translated title if available, otherwise the original title
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {

            books.where((book) => _isOldTestament(book.title)).toList();

            books.where((book) => _isNewTestament(book.title)).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(stringBook),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            controller: _autoScrollController,
            children: [
              _buildTestamentPanel(
                  stringOTestament,
                  widget.selectedLanguage == "fr"
                      ? oldTestamentBooksFr
                      : oldTestamentBooksEn,
                  mainProvider,
                  _oldTestamentController),
              _buildTestamentPanel(
                  stringNTestament,
                  widget.selectedLanguage == "fr"
                      ? newTestamentBooksFr
                      : newTestamentBooksEn,
                  mainProvider,
                  _newTestamentController),
            ],
          ),
        );
      },
    );
  }

  Map<String, Map<String, String>> bookTitles = {
    "fr": {
      "Nouveau Testament": "Nouveau Testament",
      "Ancien Testament": "Ancien Testament",
      "Livres": "Livres",
      "Genèse": "Genèse",
      "Exode": "Exode",
      "Lévitique": "Lévitique",
      "Nombres": "Nombres",
      "Deutéronome": "Deutéronome",
      "Josué": "Josué",
      "Juges": "Juges",
      "Ruth": "Ruth",
      "I Samuel": "I Samuel",
      "II Samuel": "II Samuel",
      "I Rois": "I Rois",
      "II Rois": "II Rois",
      "I Chroniques": "I Chroniques",
      "II Chroniques": "II Chroniques",
      "Esdras": "Esdras",
      "Néhémie": "Néhémie",
      "Esther": "Esther",
      "Job": "Job",
      "Psaumes": "Psaumes",
      "Proverbes": "Proverbes",
      "Ecclésiaste": "Ecclésiaste",
      "Cantique des Cantiques": "Cantique des Cantiques",
      "Ésaïe": "Ésaïe",
      "Jérémie": "Jérémie",
      "Lamentations": "Lamentations",
      "Ézéchiel": "Ézéchiel",
      "Daniel": "Daniel",
      "Osée": "Osée",
      "Joël": "Joël",
      "Amos": "Amos",
      "Abdias": "Abdias",
      "Jonas": "Jonas",
      "Michée": "Michée",
      "Nahum": "Nahum",
      "Habacuc": "Habacuc",
      "Sophonie": "Sophonie",
      "Aggée": "Aggée",
      "Zacharie": "Zacharie",
      "Malachie": "Malachie",
      "Matthieu": "Matthieu",
      "Marc": "Marc",
      "Luc": "Luc",
      "Jean": "Jean",
      "Actes": "Actes",
      "Romains": "Romains",
      "I Corinthiens": "I Corinthiens",
      "II Corinthiens": "II Corinthiens",
      "Galates": "Galates",
      "Éphésiens": "Éphésiens",
      "Philippiens": "Philippiens",
      "Colossiens": "Colossiens",
      "I Thessaloniciens": "I Thessaloniciens",
      "II Thessaloniciens": "II Thessaloniciens",
      "I Timothée": "I Timothée",
      "II Timothée": "II Timothée",
      "Tite": "Tite",
      "Philémon": "Philémon",
      "Hébreux": "Hébreux",
      "Jacques": "Jacques",
      "I Pierre": "I Pierre",
      "II Pierre": "II Pierre",
      "I Jean": "I Jean",
      "II Jean": "II Jean",
      "III Jean": "III Jean",
      "Jude": "Jude",
      "Apocalypse": "Apocalypse"
    },
    "en": {
      "Nouveau Testament": "New Testament",
      "Ancien Testament": "Old Testament",
      "Livres": "Books",
      "Genèse": "Genesis",
      "Genesis": "Genèse",
      "Exode": "Exodus",
      "Exodus": "Exode",
      "Lévitique": "Leviticus",
      "Leviticus": "Lévitique",
      "Nombres": "Numbers",
      "Numbers": "Nombres",
      "Deutéronome": "Deuteronomy",
      "Deuteronomy": "Deutéronome",
      "Josué": "Joshua",
      "Joshua": "Josué",
      "Juges": "Judges",
      "Judges": "Juges",
      "Ruth": "Ruth",
      "I Samuel": "I Samuel",
      "II Samuel": "II Samuel",
      "I Rois": "I Kings",
      "I Kings": "I Rois",
      "II Rois": "II Kings",
      "II Kings": "II Rois",
      "I Chroniques": "I Chronicles",
      "I Chronicles": "I Chroniques",
      "II Chroniques": "II Chronicles",
      "II Chronicles": "II Chroniques",
      "Esdras": "Ezra",
      "Ezra": "Esdras",
      "Néhémie": "Nehemiah",
      "Nehemiah": "Néhémie",
      "Esther": "Esther",
      "Job": "Job",
      "Psaumes": "Psalms",
      "Psalms": "Psaumes",
      "Proverbes": "Proverbs",
      "Proverbs": "Proverbes",
      "Ecclésiaste": "Ecclesiastes",
      "Ecclesiastes": "Ecclésiaste",
      "Cantique des Cantiques": "Song of Solomon",
      "Song of Solomon": "Cantique des Cantiques",
      "Ésaïe": "Isaiah",
      "Isaiah": "Ésaïe",
      "Jérémie": "Jeremiah",
      "Jeremiah": "Jérémie",
      "Lamentations": "Lamentations",
      "Ézéchiel": "Ezekiel",
      "Ezekiel": "Ézéchiel",
      "Daniel": "Daniel",
      "Osée": "Hosea",
      "Hosea": "Osée",
      "Joël": "Joel",
      "Joel": "Joël",
      "Amos": "Amos",
      "Abdias": "Obadiah",
      "Obadiah": "Abdias",
      "Jonas": "Jonah",
      "Jonah": "Jonas",
      "Michée": "Micah",
      "Micah": "Michée",
      "Nahum": "Nahum",
      "Habacuc": "Habakkuk",
      "Habakkuk": "Habacuc",
      "Sophonie": "Zephaniah",
      "Zephaniah": "Sophonie",
      "Aggée": "Haggai",
      "Haggai": "Aggée",
      "Zacharie": "Zechariah",
      "Zechariah": "Zacharie",
      "Malachie": "Malachi",
      "Malachi": "Malachie",
      "Matthieu": "Matthew",
      "Matthew": "Matthieu",
      "Marc": "Mark",
      "Mark": "Marc",
      "Luc": "Luke",
      "Luke": "Luc",
      "Jean": "John",
      "John": "Jean",
      "Actes": "Acts",
      "Acts": "Actes",
      "Romains": "Romans",
      "Romans": "Romains",
      "I Corinthiens": "I Corinthians",
      "I Corinthians": "I Corinthiens",
      "II Corinthiens": "II Corinthians",
      "II Corinthians": "II Corinthiens",
      "Galates": "Galatians",
      "Galatians": "Galates",
      "Éphésiens": "Ephesians",
      "Ephesians": "Éphésiens",
      "Philippiens": "Philippians",
      "Philippians": "Philippiens",
      "Colossiens": "Colossians",
      "Colossians": "Colossiens",
      "I Thessaloniciens": "I Thessalonians",
      "I Thessalonians": "I Thessaloniciens",
      "II Thessaloniciens": "II Thessalonians",
      "II Thessalonians": "II Thessaloniciens",
      "I Timothée": "I Timothy",
      "I Timothy": "I Timothée",
      "II Timothée": "II Timothy",
      "II Timothy": "II Timothée",
      "Tite": "Titus",
      "Titus": "Tite",
      "Philémon": "Philemon",
      "Philemon": "Philémon",
      "Hébreux": "Hebrews",
      "Hebrews": "Hébreux",
      "Jacques": "James",
      "James": "Jacques",
      "I Pierre": "I Peter",
      "I Peter": "I Pierre",
      "II Pierre": "II Peter",
      "II Peter": "II Pierre",
      "I Jean": "I John",
      "I John": "I Jean",
      "II Jean": "II John",
      "II John": "II Jean",
      "III Jean": "III John",
      "III John": "III Jean",
      "Jude": "Jude",
      "Apocalypse": "Revelation",
      "Revelation": "Apocalypse"
    },
    "de": {
      "Nouveau Testament": "Neues Testament",
      "Ancien Testament": "Altes Testament",
      "Livres": "Bücher"
    },
    "es": {
      "Nouveau Testament": "Nuevo Testamento",
      "Ancien Testament": "Antiguo Testamento",
      "Livres": "Libros",
    },
    "ar": {
      "Nouveau Testament": "العهد الجديد",
      "Ancien Testament": "العهد القديم",
      "Livres": "كتب"
    },
    "pt": {
      "Nouveau Testament": "Novo Testamento",
      "Ancien Testament": "Antigo Testamento",
      "Livres": "Livros",
    }
  };

  bool _isOldTestament(String title) {
    if (widget.selectedLanguage == "fr") {
      return oldTestamentBooksFr.contains(title);
    } else {
      return oldTestamentBooksEn.contains(title);
    }
  }

  bool _isNewTestament(String title) {
    if (widget.selectedLanguage == "fr") {
      return newTestamentBooksFr.contains(title);
    } else {
      return newTestamentBooksEn.contains(title);
    }
  }

  Widget _buildTestamentPanel(
    String testamentTitle,
    List<String> testamentBooks, // Modified to take List<String>
    MainProvider mainProvider,
    ExpandableController controller,
  ) {
    return ExpandableNotifier(
      controller: controller,
      child: ExpandablePanel(
        header: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            testamentTitle,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(209, 82, 48, 9),
              fontFamily: 'Arial',
            ),
          ),
        ),
        collapsed: const SizedBox.shrink(),
        expanded: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: testamentBooks.length,
          itemBuilder: (context, index) {
            String bookTitle = testamentBooks[index];
            String translatedBookTitle = widget.selectedLanguage == "fr"
                ? bookTitle
                : getTranslatedBookTitle(bookTitle, widget.selectedLanguage);
            return AutoScrollTag(
              key: ValueKey(translatedBookTitle),
              controller: _autoScrollController,
              index: index,
              child: ListTile(
                title: ExpandablePanel(
                  controller: ExpandableController(
                      initialExpanded: currentBook?.title == bookTitle),
                  collapsed: const SizedBox.shrink(),
                  header: Text(bookTitle),
                  expanded: Wrap(
                    children: List.generate(
                        books
                            .firstWhere((element) =>
                                getTranslatedBookTitle(element.title, widget.selectedLanguage) ==
                                bookTitle)
                            .chapiters
                            .length, (index) {
                      Chapiter chapter = books
                          .firstWhere((element) =>
                              getTranslatedBookTitle(element.title, widget.selectedLanguage) ==
                              bookTitle)
                          .chapiters[index];
                      return SizedBox(
                        height: 45,
                        width: 45,
                        child: GestureDetector(
                          onTap: () {
                            // Use translated book title for search
                            int idx = mainProvider.verses.indexWhere(
                              (element) =>
                                  element.chapter == chapter.title &&
                                  element.book == bookTitle,
                            );

                            if (idx != -1) {
                              mainProvider.updateCurrentVerse(
                                verse: mainProvider.verses[idx],
                              );
                              mainProvider.scrollToIndex(index: idx);
                              Get.back();
                            } else {
                              // // Log the error
                              // print(
                              //     "Verse not found for chapter: ${chapter.title} and book: ${book.title}");
                              // // Show an error message to the user
                              // Get.snackbar(
                              //   "Erreur",
                              //   "Le verset pour le chapitre ${chapter.title} et le livre ${book.title} n'a pas été trouvé.",
                              //   snackPosition: SnackPosition.BOTTOM,
                              // );
                            }
                          },
                          child: Card(
                            color: chapter.title == widget.chapterIdx &&
                                    widget.bookIdx ==
                                        bookTitle // Use translated title for comparison
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.5)),
                            child: Center(
                              child: Text(
                                chapter.title.toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static const oldTestamentBooksFr = [
    'Genèse',
    'Exode',
    'Lévitique',
    'Nombres',
    'Deutéronome',
    'Josué',
    'Juges',
    'Ruth',
    'I Samuel',
    'II Samuel',
    'I Rois',
    'II Rois',
    'I Chroniques',
    'II Chroniques',
    'Esdras',
    'Néhémie',
    'Esther',
    'Job',
    'Psaumes',
    'Proverbes',
    'Ecclésiaste',
    'Cantique des Cantiques',
    'Ésaïe',
    'Jérémie',
    'Lamentations',
    'Ézéchiel',
    'Daniel',
    'Osée',
    'Joël',
    'Amos',
    'Abdias',
    'Jonas',
    'Michée',
    'Nahum',
    'Habacuc',
    'Sophonie',
    'Aggée',
    'Zacharie',
    'Malachie'
  ];

  static const oldTestamentBooksEn = [
    'Genesis',
    'Exodus',
    'Leviticus',
    'Numbers',
    'Deuteronomy',
    'Joshua',
    'Judges',
    'Ruth',
    'I Samuel',
    'II Samuel',
    'I Kings',
    'II Kings',
    'I Chronicles',
    'II Chronicles',
    'Ezra',
    'Nehemiah',
    'Esther',
    'Job',
    'Psalms',
    'Proverbs',
    'Ecclesiastes',
    'Song of Solomon',
    'Isaiah',
    'Jeremiah',
    'Lamentations',
    'Ezekiel',
    'Daniel',
    'Hosea',
    'Joel',
    'Amos',
    'Obadiah',
    'Jonah',
    'Micah',
    'Nahum',
    'Habakkuk',
    'Zephaniah',
    'Haggai',
    'Zechariah',
    'Malachi'
  ];

  static const newTestamentBooksFr = [
    'Matthieu',
    'Marc',
    'Luc',
    'Jean',
    'Actes',
    'Romains',
    'I Corinthiens',
    'II Corinthiens',
    'Galates',
    'Éphésiens',
    'Philippiens',
    'Colossiens',
    'I Thessaloniciens',
    'II Thessaloniciens',
    'I Timothée',
    'II Timothée',
    'Tite',
    'Philémon',
    'Hébreux',
    'Jacques',
    'I Pierre',
    'II Pierre',
    'I Jean',
    'II Jean',
    'III Jean',
    'Jude',
    'Apocalypse'
  ];

  static const newTestamentBooksEn = [
    'Matthew',
    'Mark',
    'Luke',
    'John',
    'Acts',
    'Romans',
    'I Corinthians',
    'II Corinthians',
    'Galatians',
    'Ephesians',
    'Philippians',
    'Colossians',
    'I Thessalonians',
    'II Thessalonians',
    'I Timothy',
    'II Timothy',
    'Titus',
    'Philemon',
    'Hebrews',
    'James',
    'I Peter',
    'II Peter',
    'I John',
    'II John',
    'III John',
    'Jude',
    'Revelation'
  ];
}
