import 'package:gioco_demo/class/logic/valutazione_quiz/esito_pagina.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';

EsitoPagina calcolaTeoriaDellaMente(TeoriaDellaMente pagina, List<String> risposte) {
  List<bool> esiti = [];

  for (int i = 0; i < pagina.lista_domande.length; i++) {
    var domanda = pagina.lista_domande[i];
    String rispostaUtente = (risposte.length > i ? risposte[i] : "").trim().toLowerCase();

    bool corretta = false;
    if (domanda.risposte_corrette != null) {
      corretta = domanda.risposte_corrette!
          .map((r) => r.toString().trim().toLowerCase())
          .contains(rispostaUtente);
    }
    esiti.add(corretta);
  }

  // REGOLA: La pagina è superata SOLO SE tutte le domande sono true
  // Se anche solo una è false, every() restituirà false.
  bool tuttoCorretto = esiti.isNotEmpty && esiti.every((e) => e == true);

  return EsitoPagina(
    esitiDomande: esiti,
    paginaSuperata: tuttoCorretto, 
  );
}