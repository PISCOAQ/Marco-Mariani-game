import 'package:gioco_demo/class/logic/valutazione_quiz/esito_pagina.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';

EsitoPagina calcolaSituazioniSociali(SituazioniSociali pagina, List<String> risposte) {
  List<bool> esiti = [];
  int punteggioCanonicoTotale = 0; //Contatore punteggio per singola pagina
  
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
    int puntiDomanda = 0; //punteggio canonico per singola domanda
    if (indexSelezionato != -1 && domanda.correct_index != null) {
      //verifica correttezza standard
      corretta = domanda.correct_index!.contains(indexSelezionato);

      //Calcolo PUNTEGGIO CANONICO
      if (corretta){
        if(domanda.correct_index!.length == 1){
          puntiDomanda = 1;
        } else if(domanda.correct_index!.length == 3) {
          // Caso B, C, D: Assegna punti in base alla posizione nella lista delle soluzioni
          // Se l'utente ha scelto il primo dei corretti -> 1pt
          // Se il secondo -> 2pt, se il terzo -> 3pt
          int posizioneInSoluzioni = domanda.correct_index!.indexOf(indexSelezionato);  //ritorna la posizione 
          puntiDomanda = posizioneInSoluzioni + 1;
        }
      }
    }

    esiti.add(corretta);
    punteggioCanonicoTotale += puntiDomanda;
  }

  return EsitoPagina(
    esitiDomande: esiti,
    paginaSuperata: esiti.isNotEmpty && esiti.every((e) => e == true),
    punteggioCanonicoPagina: punteggioCanonicoTotale,
  );
}