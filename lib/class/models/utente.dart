import 'package:flutter/material.dart';

class Utente {
  int Livello_Attuale;
  double PosizioneX;
  double PosizioneY;
  Map<String, List<String>> inventario;   // Inventario: {'shirts': ['red', 'blue'], 'pants': ['denim']}
  Map<String, String> lookAttuale;  // Look attuale: {'shirts': 'red', 'pants': 'denim'}
  
  final ValueNotifier<int> moneteNotifier;


  Utente({
    required this.Livello_Attuale,
    required this.PosizioneX,
    required this.PosizioneY,
    int Monete = 0,
    Map<String, List<String>>? inventarioIniziale,
    Map<String, String>? lookIniziale,
  }) : moneteNotifier = ValueNotifier<int>(Monete),
       inventario = inventarioIniziale ?? {},
       lookAttuale = lookIniziale ?? {};

  int get monete => moneteNotifier.value;
  set monete(int nuovoValore) => moneteNotifier.value = nuovoValore;

  // Funzione di utilità per il gioco e lo shop
  bool possiedeArticolo(String categoria, String colore) {
    return inventario[categoria]?.contains(colore) ?? false;
  }
}