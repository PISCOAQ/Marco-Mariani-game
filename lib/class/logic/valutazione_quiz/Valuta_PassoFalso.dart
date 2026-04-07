import 'package:gioco_demo/class/logic/valutazione_quiz/esito_pagina.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';

EsitoPagina calcolaPassoFalso(PassoFalso pagina, List<String> risposte) {
  List<bool> esiti = [];

  for (int i = 0; i < pagina.lista_domande.length; i++) {
    var domanda = pagina.lista_domande[i];
    String rispostaUtente = (risposte.length > i ? risposte[i] : "").trim();

    bool corretta = false;

    // Controllo basato su correct_index (indici 0, 1, 2...)
    if (domanda.correct_index != null && domanda.correct_index!.isNotEmpty) {
      // Le risposte salvate dalla UI sono solitamente stringhe dell'indice "0", "1"
      // Quindi confrontiamo la stringa passata con l'indice nel modello
      corretta = domanda.correct_index!.any((idx) => idx.toString() == rispostaUtente);
    } 
    // Fallback se invece usassi risposte testuali
    else if (domanda.risposte_corrette != null) {
      corretta = domanda.risposte_corrette!
          .map((r) => r.toString().trim().toLowerCase())
          .contains(rispostaUtente.toLowerCase());
    }

    esiti.add(corretta);
  }

  bool tuttoCorretto = esiti.isNotEmpty && esiti.every((e) => e == true);

  return EsitoPagina(
    esitiDomande: esiti,
    paginaSuperata: tuttoCorretto, 
  );
}