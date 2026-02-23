import 'package:flutter/material.dart';

class Utente {
  String codiceGioco;
  int tipoAvatar;  //1-Maschio , 2-Femmina
  int Livello_Attuale;
  double PosizioneX;
  double PosizioneY;
  Map<String, String> lookAttuale;  // Look attuale: {'shirts': 'red', 'pants': 'denim'}
  Map<String, List<String>> inventario;   // Inventario: {'shirts': ['red', 'blue'], 'pants': ['denim']}
  
  final ValueNotifier<int> moneteNotifier;


  Utente({
    required this.codiceGioco,
    required this.tipoAvatar,
    required this.Livello_Attuale,
    required this.PosizioneX,
    required this.PosizioneY,
    int Monete = 0,
    Map<String, List<String>>? inventarioIniziale,
    Map<String, String>? lookIniziale,
  }) : moneteNotifier = ValueNotifier<int>(Monete),
      lookAttuale = lookIniziale ?? {},
       inventario = inventarioIniziale ?? {};
       

  int get monete => moneteNotifier.value;
  set monete(int nuovoValore) => moneteNotifier.value = nuovoValore;

  // Funzione di utilità per il gioco e lo shop
  bool possiedeArticolo(String categoria, String colore) {
    return inventario[categoria]?.contains(colore) ?? false;
  }
}