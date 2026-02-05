import 'package:gioco_demo/class/logic/valutazione_quiz/esito_pagina.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';

EsitoPagina calcolaSituazioniSociali(SituazioniSociali pagina, List<String> risposte) {
  List<bool> esiti = [];
  
  for (int i = 0; i < pagina.lista_domande.length; i++) {
    var domanda = pagina.lista_domande[i]; 
    String rispUtente = (risposte.length > i ? risposte[i] : "").trim();
    
    int indexSelezionato = -1;

    // PROVA 1: Vediamo se rispUtente è già un numero (es. "0", "1")
    int? parsedIndex = int.tryParse(rispUtente);
    
    if (parsedIndex != null) {
      // Se è un numero, quello è il nostro indice!
      indexSelezionato = parsedIndex;
    } else {
      // PROVA 2: Se è un testo (es. "A"), cerchiamo la sua posizione
      indexSelezionato = domanda.opzioni.indexWhere(
        (opt) => opt.trim().toLowerCase() == rispUtente.toLowerCase()
      );
    }

    bool corretta = false;
    if (indexSelezionato != -1 && domanda.correct_index != null) {
      corretta = domanda.correct_index!.contains(indexSelezionato);
    }

    esiti.add(corretta);
  }

  return EsitoPagina(
    esitiDomande: esiti,
    paginaSuperata: esiti.isNotEmpty && esiti.every((e) => e == true),
  );
}