import 'package:flutter/material.dart';
import 'package:application_biblique/models/book.dart';
import 'package:application_biblique/models/verse.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MainProvider extends ChangeNotifier {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  List<Verse> verses = [];
  List<Book> books = [];
  Verse? currentVerse;
  List<Verse> selectedVerses = [];
  Book? _currentBook;

  bool _isLoading = false; // Indique si le chargement est en cours

  bool get isLoading => _isLoading;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  // Méthode pour ajouter un verset à la liste et notifier les auditeurs
  void addVerse({required Verse verse}) {
    verses.add(verse);
    notifyListeners();
  }

  // Method to set the current book
  void setCurrentBook(Book book) {
    _currentBook = book;
    notifyListeners();
  }

  Book? get currentBook => _currentBook; // Getter pour obtenir le livre actuel

  // Méthode pour ajouter un livre à la liste et notifier les auditeurs
  void addBook({required Book book}) {
    books.add(book);
    notifyListeners();
  }

  // Méthode pour mettre à jour le verset actuel et notifier les auditeurs
  void updateCurrentVerse({required Verse verse}) {
    currentVerse = verse;
    notifyListeners();
  }

  void scrollToIndex({required int index}) {
    itemScrollController.jumpTo(index: index);
  }

  // Méthode pour basculer l'état de sélection d'un verset et notifier les auditeurs
  void toggleVerse({required Verse verse}) {
    if (selectedVerses.contains(verse)) {
      selectedVerses.remove(verse);
    } else {
      selectedVerses.add(verse);
    }
    notifyListeners();
  }

  // Méthode pour obtenir les versets sélectionnés formatés pour le partage ou la copie
  String formattedSelectedVerses() {
    return selectedVerses.map((verse) {
      return '${verse.book} ${verse.chapter}:${verse.verse} - ${verse.text}';
    }).join('\n');
  }

  // Méthode pour sélectionner tous les versets et notifier les auditeurs
  void selectAllVerses() {
    selectedVerses = List<Verse>.from(verses);
    notifyListeners();
  }

  // Méthode pour désélectionner tous les versets et notifier les auditeurs
  void deselectAllVerses() {
    selectedVerses.clear();
    notifyListeners();
  }

  // Nouvelle méthode pour effacer les versets et notifier les auditeurs
  void clearVerses() {
    verses.clear();
    notifyListeners();
  }
}
