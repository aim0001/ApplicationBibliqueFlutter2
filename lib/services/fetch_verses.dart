import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:application_biblique/models/verse.dart';
import 'package:application_biblique/providers/main_provider.dart';

class FetchVerses {
  static Future<void> execute({
    required MainProvider mainProvider,
    required String languageCode,
  }) async {
     mainProvider.setLoading(true); // Démarre le chargement
    String fileName;

    // Détermine le fichier à utiliser en fonction de la langue sélectionnée
    switch (languageCode) {
      case 'en':
        fileName = 'assets/kjvEn.json';
        break;
      case 'es':
        fileName = 'assets/kjvEsp.json';
        break;
      case 'de':
        fileName = 'assets/kjvAllm.json';
        break;
      case 'ar':
        fileName = 'assets/kjvArb.json';
        break;
      case 'pt':
        fileName = 'assets/kjvPort.json';
        break;
      default:
        fileName = 'assets/kjv.json';
    }

    // Charge le contenu du fichier JSON sous forme de chaîne depuis le dossier Assets
    String jsonString = await rootBundle.loadString(fileName);

    // Décode la chaîne JSON en une liste d'objets dynamiques
    List<dynamic> jsonList = json.decode(jsonString);

    // Effacer les versets existants
    mainProvider.clearVerses(); 

    // Parcourez chaque objet JSON, puis convertissez-le en vers et ajoutez-le à la liste du fournisseur
    for (var json in jsonList) {
      // Créer un objet Verse à partir du JSON
      Verse verse = Verse.fromJson(json);
      mainProvider.addVerse(verse: verse);
    }

     mainProvider.setLoading(false); // Arrête le chargement
  }
}
