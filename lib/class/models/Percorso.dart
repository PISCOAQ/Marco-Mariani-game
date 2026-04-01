import 'package:flutter/material.dart';

class Percorso {
  final String nomePercorso;
  final String flowId;
  String? ctxId;
  int Livello_Attuale;
  double PosizioneX;
  double PosizioneY;

  Percorso({
    required this.nomePercorso,
    required this.flowId,
    required this.ctxId,
    required this.Livello_Attuale,
    required this.PosizioneX,
    required this.PosizioneY,
  });

   // Factory per creare Percorso dal DB
factory Percorso.fromMap(Map<String, dynamic> json) {
  return Percorso(
    flowId: json['percorsoIdEsterno'],
    nomePercorso: json['nomePercorso'],
    Livello_Attuale: json['Livello_Attuale'] ?? 0,
    PosizioneX: (json['PosizioneX'] ?? 0).toDouble(),
    PosizioneY: (json['PosizioneY'] ?? 0).toDouble(),
    ctxId: json['ctxId'],
  );
}
}
