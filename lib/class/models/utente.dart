import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Percorso.dart';

class Utente {
  String codiceGioco;
  int? tipoAvatar;  //1-Maschio , 2-Femmina
  Map<String, String> lookAttuale;  // Look attuale: {'shirts': 'red', 'pants': 'denim'}
  Map<String, List<String>> inventario;   // Inventario: {'shirts': ['red', 'blue'], 'pants': ['denim']}
  List<Percorso> percorsiAssegnati;
  Percorso? percorsoAttivo;
  final ValueNotifier<int> moneteNotifier;


  Utente({
    required this.codiceGioco,
    required this.tipoAvatar,
    required this.percorsiAssegnati,
    this.percorsoAttivo,
    int Monete = 0,
    Map<String, List<String>>? inventarioIniziale,
    Map<String, String>? lookIniziale,
  }) : moneteNotifier = ValueNotifier<int>(Monete),
      lookAttuale = lookIniziale ?? {},
       inventario = inventarioIniziale ?? {};
  

  factory Utente.fromMap(
    String code,
    Map<String, dynamic> data,
    Map<int, Offset> positions,
  ) {
    final percorsi = (data['percorsiAssegnati'] as List)
        .map((p) => Percorso.fromMap(p))
        .toList();

    int monete = data['moneteNotifier'];
    if(monete == 0) monete = 50; //valore di default
    return Utente(
      codiceGioco: code,
      tipoAvatar: data['tipoAvatar'],
      Monete: monete,
      lookIniziale: Map<String, String>.from(data['lookAttuale'] ?? {}),
      inventarioIniziale: Map<String, List<String>>.from(
        (data['inventario'] ?? {}).map(
          (k, v) => MapEntry(k, List<String>.from(v)),
        ),
      ),
      percorsiAssegnati: percorsi,
      percorsoAttivo: null,
    );
  }

  int get monete => moneteNotifier.value;
  set monete(int nuovoValore) => moneteNotifier.value = nuovoValore;

  // Funzione di utilità per il gioco e lo shop
  bool possiedeArticolo(String categoria, String colore) {
    return inventario[categoria]?.contains(colore) ?? false;
  }
}