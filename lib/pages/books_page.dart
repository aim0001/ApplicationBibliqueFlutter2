import 'dart:async';

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
    _translateBookTitles();
    _translateTestamentTitles();
  }

  Future<void> _translateBookTitles() async {
    MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: false);
    books = mainProvider.books;

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
        List<Book> oldTestamentBooks =
            books.where((book) => _isOldTestament(book.title)).toList();
        List<Book> newTestamentBooks =
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
      "Livres": "Bücher",
      "Genèse": "Genesis",
      "Exode": "Exodus",
      "Lévitique": "Levitikus",
      "Nombres": "Numeri",
      "Deutéronome": "Deuteronomium",
      "Josué": "Josua",
      "Juges": "Richter",
      "Ruth": "Ruth",
      "I Samuel": "I Samuel",
      "II Samuel": "II Samuel",
      "I Rois": "I Könige",
      "II Rois": "II Könige",
      "I Chroniques": "I Chronik",
      "II Chroniques": "II Chronik",
      "Esdras": "Esra",
      "Néhémie": "Nehemia",
      "Esther": "Ester",
      "Job": "Hiob",
      "Psaumes": "Psalmen",
      "Proverbes": "Sprüche",
      "Ecclésiaste": "Prediger",
      "Cantique des Cantiques": "Hohelied",
      "Ésaïe": "Jesaja",
      "Jérémie": "Jeremia",
      "Lamentations": "Klagelieder",
      "Ézéchiel": "Hesekiel",
      "Daniel": "Daniel",
      "Osée": "Hosea",
      "Joël": "Joel",
      "Amos": "Amos",
      "Abdias": "Obadja",
      "Jonas": "Jona",
      "Michée": "Micha",
      "Nahum": "Nahum",
      "Habacuc": "Habakkuk",
      "Sophonie": "Zefanja",
      "Aggée": "Haggai",
      "Zacharie": "Sacharja",
      "Malachie": "Maleachi",
      "Matthieu": "Matthäus",
      "Marc": "Markus",
      "Luc": "Lukas",
      "Jean": "Johannes",
      "Actes": "Apostelgeschichte",
      "Romains": "Römer",
      "I Corinthiens": "I Korinther",
      "II Corinthiens": "II Korinther",
      "Galates": "Galater",
      "Éphésiens": "Epheser",
      "Philippiens": "Philipper",
      "Colossiens": "Kolosser",
      "I Thessaloniciens": "I Thessalonicher",
      "II Thessaloniciens": "II Thessalonicher",
      "I Timothée": "I Timotheus",
      "II Timothée": "II Timotheus",
      "Tite": "Titus",
      "Philémon": "Philemon",
      "Hébreux": "Hebräer",
      "Jacques": "Jakobus",
      "I Pierre": "I Petrus",
      "II Pierre": "II Petrus",
      "I Jean": "I Johannes",
      "II Jean": "II Johannes",
      "III Jean": "III Johannes",
      "Jude": "Judas",
      "Apocalypse": "Offenbarung"
    },
    "es": {
      "Nouveau Testament": "Nuevo Testamento",
      "Ancien Testament": "Antiguo Testamento",
      "Livres": "Libros",
      "Genèse": "Génesis",
      "Exode": "Éxodo",
      "Lévitique": "Levítico",
      "Nombres": "Números",
      "Deutéronome": "Deuteronomio",
      "Josué": "Josué",
      "Juges": "Jueces",
      "Ruth": "Rut",
      "I Samuel": "I Samuel",
      "II Samuel": "II Samuel",
      "I Rois": "I Reyes",
      "II Rois": "II Reyes",
      "I Chroniques": "I Crónicas",
      "II Chroniques": "II Crónicas",
      "Esdras": "Esdras",
      "Néhémie": "Nehemías",
      "Esther": "Ester",
      "Job": "Job",
      "Psaumes": "Salmos",
      "Proverbes": "Proverbios",
      "Ecclésiaste": "Eclesiastés",
      "Cantique des Cantiques": "Cantar de los Cantares",
      "Ésaïe": "Isaías",
      "Jérémie": "Jeremías",
      "Lamentations": "Lamentaciones",
      "Ézéchiel": "Ezequiel",
      "Daniel": "Daniel",
      "Osée": "Oseas",
      "Joël": "Joel",
      "Amos": "Amós",
      "Abdias": "Abdías",
      "Jonas": "Jonás",
      "Michée": "Miqueas",
      "Nahum": "Nahúm",
      "Habacuc": "Habacuc",
      "Sophonie": "Sofonías",
      "Aggée": "Hageo",
      "Zacharie": "Zacarías",
      "Malachie": "Malaquías",
      "Matthieu": "Mateo",
      "Marc": "Marcos",
      "Luc": "Lucas",
      "Jean": "Juan",
      "Actes": "Hechos",
      "Romains": "Romanos",
      "I Corinthiens": "I Corintios",
      "II Corinthiens": "II Corintios",
      "Galates": "Gálatas",
      "Éphésiens": "Efesios",
      "Philippiens": "Filipenses",
      "Colossiens": "Colosenses",
      "I Thessaloniciens": "I Tesalonicenses",
      "II Thessaloniciens": "II Tesalonicenses",
      "I Timothée": "I Timoteo",
      "II Timothée": "II Timoteo",
      "Tite": "Tito",
      "Philémon": "Filemón",
      "Hébreux": "Hebreos",
      "Jacques": "Santiago",
      "I Pierre": "I Pedro",
      "II Pierre": "II Pedro",
      "I Jean": "I Juan",
      "II Jean": "II Juan",
      "III Jean": "III Juan",
      "Jude": "Judas",
      "Apocalypse": "Apocalipsis"
    },
    "ar": {
      "Nouveau Testament": "العهد الجديد",
      "Ancien Testament": "العهد القديم",
      "Livres": "كتب",
      "Genèse": "التكوين",
      "Exode": "الخروج",
      "Lévitique": "اللاويين",
      "Nombres": "العدد",
      "Deutéronome": "التثنية",
      "Josué": "يشوع",
      "Juges": "القضاة",
      "Ruth": "راعوث",
      "I Samuel": "١ صموئيل",
      "II Samuel": "٢ صموئيل",
      "I Rois": "١ ملوك",
      "II Rois": "٢ ملوك",
      "I Chroniques": "١ أخبار الأيام",
      "II Chroniques": "٢ أخبار الأيام",
      "Esdras": "عزرا",
      "Néhémie": "نحميا",
      "Esther": "أستير",
      "Job": "أيوب",
      "Psaumes": "المزامير",
      "Proverbes": "الأمثال",
      "Ecclésiaste": "الجامعة",
      "Cantique des Cantiques": "نشيد الأنشاد",
      "Ésaïe": "إشعياء",
      "Jérémie": "إرميا",
      "Lamentations": "مراثي",
      "Ézéchiel": "حزقيال",
      "Daniel": "دانيال",
      "Osée": "هوشع",
      "Joël": "يوئيل",
      "Amos": "عاموس",
      "Abdias": "عوبديا",
      "Jonas": "يونان",
      "Michée": "ميخا",
      "Nahum": "ناحوم",
      "Habacuc": "حبقوق",
      "Sophonie": "صفنيا",
      "Aggée": "حجي",
      "Zacharie": "زكريا",
      "Malachie": "ملاخي",
      "Matthieu": "متى",
      "Marc": "مرقس",
      "Luc": "لوقا",
      "Jean": "يوحنا",
      "Actes": "أعمال الرسل",
      "Romains": "رومية",
      "I Corinthiens": "١ كورنثوس",
      "II Corinthiens": "٢ كورنثوس",
      "Galates": "غلاطية",
      "Éphésiens": "أفسس",
      "Philippiens": "فيلبي",
      "Colossiens": "كولوسي",
      "I Thessaloniciens": "١ تسالونيكي",
      "II Thessaloniciens": "٢ تسالونيكي",
      "I Timothée": "١ تيموثاوس",
      "II Timothée": "٢ تيموثاوس",
      "Tite": "تيطس",
      "Philémon": "فليمون",
      "Hébreux": "العبرانيين",
      "Jacques": "يعقوب",
      "I Pierre": "١ بطرس",
      "II Pierre": "٢ بطرس",
      "I Jean": "١ يوحنا",
      "II Jean": "٢ يوحنا",
      "III Jean": "٣ يوحنا",
      "Jude": "يهوذا",
      "Apocalypse": "الرؤيا"
    },
    "pt": {
      "Nouveau Testament": "Novo Testamento",
      "Ancien Testament": "Antigo Testamento",
      "Livres": "Livros",
      "Genèse": "Gênesis",
      "Exode": "Êxodo",
      "Lévitique": "Levítico",
      "Nombres": "Números",
      "Deutéronome": "Deuteronômio",
      "Josué": "Josué",
      "Juges": "Juízes",
      "Ruth": "Rute",
      "I Samuel": "I Samuel",
      "II Samuel": "II Samuel",
      "I Rois": "I Reis",
      "II Rois": "II Reis",
      "I Chroniques": "I Crônicas",
      "II Chroniques": "II Crônicas",
      "Esdras": "Esdras",
      "Néhémie": "Neemias",
      "Esther": "Ester",
      "Job": "Jó",
      "Psaumes": "Salmos",
      "Proverbes": "Provérbios",
      "Ecclésiaste": "Eclesiastes",
      "Cantique des Cantiques": "Cântico dos Cânticos",
      "Ésaïe": "Isaías",
      "Jérémie": "Jeremias",
      "Lamentations": "Lamentações",
      "Ézéchiel": "Ezequiel",
      "Daniel": "Daniel",
      "Osée": "Oséias",
      "Joël": "Joel",
      "Amos": "Amós",
      "Abdias": "Obadias",
      "Jonas": "Jonas",
      "Michée": "Miquéias",
      "Nahum": "Naum",
      "Habacuc": "Habacuque",
      "Sophonie": "Sophonias",
      "Aggée": "Ageu",
      "Zacharie": "Zacarias",
      "Malachie": "Malaquias",
      "Matthieu": "Matthieu",
      "Marc": "Marcos",
      "Luc": "Lucas",
      "Jean": "João",
      "Actes des Apôtres": "Actes",
      "Romains": "Romanos",
      "I Corinthiens": "I Coríntios",
      "II Corinthiens": "II Coríntios",
      "Galates": "Gálatas",
      "Éphésiens": "Efésios",
      "Philippiens": "Filipenses",
      "Colossiens": "Colossenses",
      "I Thessaloniciens": "I Tessalonicenses",
      "II Thessaloniciens": "II Tessalonicenses",
      "I Timothée": "I Timóteo",
      "II Timothée": "II Timóteo",
      "Tite": "Tito",
      "Philémon": "Filemom",
      "Hébreux": "Hebreus",
      "Jacques": "Tiago",
      "I Pierre": "I Pedro",
      "II Pierre": "II Pedro",
      "I Jean": "I João",
      "II Jean": "II João",
      "III Jean": "III João",
      "Jude": "Judas",
      "Apocalypse": "Apocalipse"
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
                                getTranslatedBookTitle(element.title, "en") ==
                                bookTitle)
                            .chapiters
                            .length, (index) {
                      Chapiter chapter = books
                          .firstWhere((element) =>
                              getTranslatedBookTitle(element.title, "en") ==
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
