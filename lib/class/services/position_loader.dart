import 'dart:convert';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

class PositionService {
  Map<String, dynamic> _positions = {};

  Future<void> loadFile() async {
    try {
      final String response = await rootBundle.loadString('data/avatar_positions.json');
      _positions = json.decode(response) as Map<String, dynamic>;
    } catch (_) {
      // Fallback silenzioso: se il file fallisce, inizializza una mappa vuota o di default
      _positions = {"1": {"x": 400.0, "y": 900.0}};
    }
  }

  double getCoord(int livello, String tipo) {
    String lv = livello.toString();

    // Recuperiamo il nodo del livello o il fallback 1
    // Forziamo il cast a Map per evitare l'errore JSArray
    final data = (_positions[lv] as Map<String, dynamic>?) ?? 
                 (_positions["1"] as Map<String, dynamic>?);

    if (data != null && data.containsKey(tipo)) {
      final valore = data[tipo];
      if (valore is num) {
        return valore.toDouble();
      }
    }

    // Se tutto fallisce, restituiamo un valore di sicurezza invece di crashare
    return 0.0;
  }
}