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


        } else if(d['tipo'] == 'attribuzione_emozioni'){
          listaDomande.add(AttribuzioneEmozioni(
            testo: d['testo'], 
            question: d['question'],
            risposteCorrette: List<String>.from(d['risposte_corrette'])
          ));


        } else if(d['tipo'] == 'teoria_mente'){
          listaDomande.add(TeoriaDellaMente(
            testo: d['testo'], 
            question1: d['question1'],
            opzioni1: List<String>.from(d['opzioni1']), 
            question2: d['question2'], //ritorna null se non è presente
            opzioni2: d['opzioni2'] != null ? List<String>.from(d['opzioni2']) : null, 
            question3: d['question3']
          ));


        }else if(d['tipo'] == 'passo_falso'){
          listaDomande.add(PassoFalso(
            testo: d['testo'], 
            question1: d['question1'],
            opzioni1: List<String>.from(d['opzioni1']), 
            question2: d['question2'],
            opzioni2: List<String>.from(d['opzioni2']), 
          ));
        }
      }
      return Quiz(id: data['id'], titolo: data['titolo'], domande: listaDomande);

    } else if(data['tipo_attivita'] == 'esercitazione'){
      return Esercitazione(id: data['id'], titolo: data['titolo'], descrizione: data['descrizione']);
    }
  }
}