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
  double x = (json['PosizioneX'] ?? 0.0).toDouble();
  double y = (json['PosizioneY'] ?? 0.0).toDouble();

  if (x == 0.0 && y == 0.0) {
    x = 400.0;
    y = 900.0;
  }

  return Percorso(
    flowId: json['percorsoIdEsterno'],
    nomePercorso: json['nomePercorso'],
    Livello_Attuale: json['Livello_Attuale'] ?? 1,
    ctxId: json['ctxId'],
    PosizioneX: x,
    PosizioneY: y,
  );
}
}
