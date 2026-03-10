import 'package:gioco_demo/class/logic/valutazione_quiz/esito_pagina.dart';
import 'package:gioco_demo/class/models/Attività.dart';

EsitoPagina calcolaTeoriaDellaMente(TeoriaDellaMente pagina, List<String> risposteUtente) {
  List<bool> esiti = [];

  for (int i = 0; i < pagina.lista_domande.length; i++) {
    final domanda = pagina.lista_domande[i];

    int rispostaIndex = -1;
    if (risposteUtente.length > i) {
      rispostaIndex = int.tryParse(risposteUtente[i]) ?? -1;
    }

    bool corretta = false;

    if (domanda.correct_index != null) {
      corretta = domanda.correct_index!.contains(rispostaIndex);
    }

    esiti.add(corretta);
  }

  bool tuttoCorretto = esiti.isNotEmpty && esiti.every((e) => e);

  return EsitoPagina(
    esitiDomande: esiti,
    paginaSuperata: tuttoCorretto,
  );
} 