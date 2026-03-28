import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Percorso.dart';

class Utente {
  String codiceGioco;
  int? tipoAvatar;  //1-Maschio , 2-Femmina
  int Livello_Attuale;
  double PosizioneX;
  double PosizioneY;
  Map<String, String> lookAttuale;  // Look attuale: {'shirts': 'red', 'pants': 'denim'}
  Map<String, List<String>> inventario;   // Inventario: {'shirts': ['red', 'blue'], 'pants': ['denim']}
  List<Percorso> percorsiAssegnati;
  Percorso? percorsoAttivo;
  final ValueNotifier<int> moneteNotifier;


  Utente({
    required this.codiceGioco,
    required this.tipoAvatar,
    required this.Livello_Attuale,
    required this.PosizioneX,
    required this.PosizioneY,
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
    Map<int, Offset> spawnPoints,
  ) {
    // 1. Logica Livello: se 0 o null nel DB, portalo a 1
    int lv = (data['Livello_Attuale'] ?? 0);
    if (lv <= 0) lv = 1;

    // 2. Logica Posizione: se il DB dà 0 (utente nuovo), usa lo spawn point del livello
    Offset defaultPos = spawnPoints[lv] ?? spawnPoints[1]!;
    
    // Controlliamo se la posizione nel DB è valida, altrimenti usiamo lo spawn point
    double x = (data['PosizioneX'] ?? 0.0) == 0.0 ? defaultPos.dx : (data['PosizioneX'] as num).toDouble();
    double y = (data['PosizioneY'] ?? 0.0) == 0.0 ? defaultPos.dy : (data['PosizioneY'] as num).toDouble();

    // 3. Logica Percorsi
    final List<dynamic> percorsiJson = data['percorsiAssegnati'] ?? [];
    List<Percorso> listaPercorsi = percorsiJson.map((p) => Percorso(
          nomePercorso: p['nomePercorso'] ?? 'Percorso',
          flowId: p['percorsoIdEsterno'] ?? '',
          ctxId: p['ctxId'] ?? '',
        )).toList();

    return Utente(
      codiceGioco: code,
      tipoAvatar: data['tipoAvatar'], // Può essere null
      Livello_Attuale: lv,
      PosizioneX: x,    
      PosizioneY: y,       
      Monete: data['moneteNotifier'] ?? 50,
      percorsiAssegnati: listaPercorsi,
      lookIniziale: Map<String, String>.from(data['lookAttuale'] ?? {}),
      inventarioIniziale: (data['inventario'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), List<String>.from(value ?? [])),
      ),
    );
  }

  int get monete => moneteNotifier.value;
  set monete(int nuovoValore) => moneteNotifier.value = nuovoValore;

  // Funzione di utilità per il gioco e lo shop
  bool possiedeArticolo(String categoria, String colore) {
    return inventario[categoria]?.contains(colore) ?? false;
  }
}