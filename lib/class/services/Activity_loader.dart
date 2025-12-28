import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gioco_demo/class/models/Domanda.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';


class ActivityLoader {
  static const String _path = '/data/data.json';

  static Future<dynamic> carica() async {
    final String response = await rootBundle.loadString(_path);
    final data = json.decode(response);

    if (data['tipo_attivita'] == 'quiz') {
      List<Domanda> listaDomande = [];

      for (var d in data['contenuto']) {
        // DECISIONE TIPO DOMANDA
        if (d['tipo'] == 'scelta_multipla') {
          listaDomande.add(DomandaSceltaMultipla(
            testo: d['testo'],
            opzioni: List<String>.from(d['opzioni']),
            rispostaCorrettaIndex: d['risposta_corretta'],
          ));
        }

        // In futuro: else if (d['tipo'] == 'immagine') ...

      }
      return Quiz(id: data['id'], titolo: data['titolo'], domande: listaDomande);

    } else if(data['tipo_attivita'] == 'esercitazione'){
      return Esercitazione(id: data['id'], titolo: data['titolo'], descrizione: data['descrizione']);

    }
  }
}