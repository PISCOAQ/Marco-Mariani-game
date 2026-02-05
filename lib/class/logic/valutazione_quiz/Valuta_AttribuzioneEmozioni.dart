import 'package:gioco_demo/class/logic/valutazione_quiz/esito_pagina.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';

// Classe di supporto per trasportare i risultati al Manager


EsitoPagina calcolaAttribuzioneEmozioni(AttribuzioneEmozioni pagina, List<String> risposte) {
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

  return EsitoPagina(
    esitiDomande: esiti,
    // CRITERIO: In questo quiz basta che la risposta sia corretta
    paginaSuperata: esiti.isNotEmpty && esiti.every((e) => e == true),
  );
}