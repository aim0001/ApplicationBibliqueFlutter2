import 'package:application_biblique/services/fetch_books.dart';
import 'package:application_biblique/services/fetch_verses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:application_biblique/pages/books_page.dart';
import 'package:application_biblique/providers/main_provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:clipboard/clipboard.dart';
import 'dart:async';
import 'package:application_biblique/models/verse.dart';
import 'package:fuzzy/fuzzy.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String book = 'Livres';
  String formatText = '';
  bool _showShareButton = false;
  var languageList = ["fr", "en", "de", "es", "ar", "pt"];
  String _selectedLanguage = 'fr';
  Timer? _refreshTimer;
  Timer? _debounce; // Ajoutez cette ligne
  TextEditingController queryController = TextEditingController();

  String myQuery = "";

  List<Verse> versesList = [];
  bool _noResultsFound = false;
  bool _isInitialLoad = true;
  bool _isLoading = false;

  Map<String, Map<String, String>> languageNames = {
    "fr": {
      "fr": "Français",
      "en": "Anglais",
      "de": "Allemand",
      "es": "Espagnol",
      "ar": "Arabe",
      "pt": "Portugais"
    },
    "en": {
      "fr": "French",
      "en": "English",
      "de": "German",
      "es": "Spanish",
      "ar": "Arabic",
      "pt": "Portuguese"
    },
    "de": {
      "fr": "Französisch",
      "en": "Englisch",
      "de": "Deutsch",
      "es": "Spanisch",
      "ar": "Arabisch",
      "pt": "Portugiesisch"
    },
    "es": {
      "fr": "Francés",
      "en": "Inglés",
      "de": "Alemán",
      "es": "Español",
      "ar": "Árabe",
      "pt": "Portugués"
    },
    "ar": {
      "fr": "الفرنسية",
      "en": "الإنجليزية",
      "de": "الألمانية",
      "es": "الإسبانية",
      "ar": "العربية",
      "pt": "البرتغالية"
    },
    "pt": {
      "fr": "Francês",
      "en": "Inglês",
      "de": "Alemão",
      "es": "Espanhol",
      "ar": "Árabe",
      "pt": "Português"
    }
  };
  Future<void> _loadTranslatedContent(String languageCode) async {
    MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    // Déclarez un Future qui charge les données
    await Future.wait([
      FetchVerses.execute(
          mainProvider: mainProvider, languageCode: languageCode),
      FetchBooks.execute(mainProvider: mainProvider),
    ]);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    versesList = mainProvider.verses; // Mettre à jour la liste des versets
  }

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _debounce?.cancel(); // Annulez le Timer lors de la destruction
    super.dispose();
  }

  // Fonction pour formater le texte recherché avec les correspondances en surbrillance
  Text formatSearchText({
    required String input,
    required String query,
    required BuildContext context,
  }) {
    if (input.isEmpty || query.isEmpty) {
      return Text(input);
    }

    List<TextSpan> textSpans = [];
    RegExp regExp = RegExp(query, caseSensitive: false);
    Iterable<Match> matches = regExp.allMatches(input);

    int currentIndex = 0;
    for (Match match in matches) {
      textSpans.add(TextSpan(text: input.substring(currentIndex, match.start)));
      textSpans.add(
        TextSpan(
          text: input.substring(match.start, match.end),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.yellow,
          ),
        ),
      );
      currentIndex = match.end;
    }

    textSpans.add(TextSpan(text: input.substring(currentIndex)));

    return Text.rich(TextSpan(children: textSpans));
  }

  void _searchVerses(String query, List<Verse> verses) {
    setState(() {
      versesList = verses
          .where((element) =>
              element.text.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _noResultsFound = versesList.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        var verses = mainProvider.verses;
        final currentVerse = mainProvider.currentVerse;
        final isSelected = mainProvider.selectedVerses.isNotEmpty;

        if (versesList.isEmpty) {
          versesList.addAll(verses);
        }

        return Scaffold(
          appBar: AppBar(
            leading: isSelected
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      mainProvider.deselectAllVerses();
                    },
                  )
                : null,
            title: currentVerse == null || isSelected
                ? null
                : ListTile(
                    leading: const Icon(Icons.menu),
                    title: Text(
                      _selectedLanguage == 'fr' ? book : 'Books',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 134, 78, 14),
                      ),
                    ),
                    subtitle: Text(
                      _selectedLanguage == 'fr' ? currentVerse.book : 'Genesis',
                      style: const TextStyle(fontFamily: 'Arial', fontSize: 14),
                    ),
                    onTap: () {
                      Get.to(
                        () => BooksPage(
                          chapterIdx: currentVerse.chapter,
                          bookIdx: currentVerse.book,
                          selectedLanguage: _selectedLanguage,
                        ),
                        transition: Transition.leftToRight,
                      );
                    },
                  ),
            actions: [
              DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (newValue) async {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                    // Charge les livres et les versets traduits pour la nouvelle langue
                    await _loadTranslatedContent(newValue);
                  }
                },
                items:
                    languageList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                        "${languageNames[_selectedLanguage]?[value]} ($value)"), // Affiche la langue en texte
                  );
                }).toList(),
              ),
              if (isSelected)
                IconButton(
                  onPressed: () async {
                    final string = await mainProvider.formattedSelectedVerses();
                    await FlutterClipboard.copy(string).then(
                      (_) {
                        setState(() {
                          _showShareButton = true;
                        });
                      },
                    );
                  },
                  icon: const Icon(Icons.copy_rounded),
                ),
              // Uncomment this if needed
              // if (!isSelected)
              //   IconButton(
              //     onPressed: () async {
              //       Get.to(
              //         () => SearchPage(
              //             verses: verses, selectedLanguage: _selectedLanguage),
              //         transition: Transition.rightToLeft,
              //       );
              //     },
              //     icon: const Icon(Icons.search_rounded),
              //   ),
            ],
          ),
          body: mainProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : InteractiveViewer(
                  maxScale: 4.0,
                  minScale: 0.1,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CupertinoSearchTextField(
                              controller: queryController,
                              onChanged: (query) async {
                                //await Future.delayed(Duration(seconds: 3));
                                /* var queryTranslated =
                              await mainProvider.translateText(
                                  queryController.text == ""
                                      ? "  "
                                      : queryController.text,
                                  "en"); */
                                if (_debounce?.isActive ?? false)
                                  _debounce!.cancel();
                                _debounce =
                                    Timer(const Duration(milliseconds: 500),
                                        () async {
                                  if (query.isNotEmpty) {
                                    myQuery = query;
                                  } else {
                                    myQuery = "";
                                  }
                                  _searchVerses(myQuery, verses);
                                });
                              },
                              // onSuffixTap: () {
                              //   setState(() {
                              //     myQuery = "";
                              //     queryController.text = "";
                              //   });
                              // },
                            ),
                          ),
                          Expanded(
                            child: _noResultsFound
                                ? const Center(
                                    child: Text("Words not found",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(172, 70, 70, 70),
                                            fontSize: 20)))
                                : ScrollablePositionedList.builder(
                                    itemCount: versesList.length,
                                    itemBuilder: (context, index) {
                                      final verse = versesList[index];

                                      return ListTile(
                                        title: formatSearchText(
                                            input: verse.text,
                                            query: myQuery,
                                            context: context),
                                        subtitle: Container(
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  17, 255, 145, 0)),
                                          child: Text(
                                              '- - << ${verse.book} ${verse.chapter}:${verse.verse} >> - -',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 134, 78, 14),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ),
                                        onTap: () => mainProvider.toggleVerse(
                                            verse: verse),
                                        selected: mainProvider.selectedVerses
                                            .contains(verse),
                                      );
                                    },
                                    itemScrollController:
                                        mainProvider.itemScrollController,
                                    itemPositionsListener:
                                        mainProvider.itemPositionsListener,
                                  ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: _showShareButton,
                        child: AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          bottom: isSelected ? 16 : -56,
                          left: 16,
                          child: FloatingActionButton(
                            onPressed: () async {
                              final string =
                                  await mainProvider.formattedSelectedVerses();
                              await FlutterShare.share(
                                  title: 'Partager', text: string);
                            },
                            backgroundColor: Colors.white,
                            elevation: 3,
                            child: const Icon(Icons.share, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
