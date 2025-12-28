abstract class Domanda {
  final String testo;
  final String tipo; // "scelta_multipla", "immagine", "aperta", ecc.

  Domanda({required this.testo, required this.tipo});
}

// IL BLOCCO SPECIFICO: Domanda a 4 risposte
class DomandaSceltaMultipla extends Domanda {
  final List<String> opzioni;
  final int rispostaCorrettaIndex;

  DomandaSceltaMultipla({
    required super.testo,
    required this.opzioni,
    required this.rispostaCorrettaIndex,
  }) : super(tipo: 'scelta_multipla');
}

//Altri tipi di domande(classi) -> vengono selezionati da Activity_loader