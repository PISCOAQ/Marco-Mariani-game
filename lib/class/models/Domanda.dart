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


class AttribuzioneEmozioni extends Domanda {
  final List<String> risposteCorrette;
  final String question;

  AttribuzioneEmozioni({
    required super.testo,
    required this.question,
    required this.risposteCorrette
  }) : super(tipo: 'attribuzione_emozioni');
}



class TeoriaDellaMente extends Domanda {
  final String question1;
  final List<String> opzioni1; 
  final String? question2;
  final List<String>? opzioni2; 
  final String question3;

  TeoriaDellaMente({
    required super.testo,
    required this.question1,
    required this.opzioni1,
    required this.question2,
    required this.opzioni2,
    required this.question3,
  }) : super(tipo: 'teoria_mente');
}


class PassoFalso extends Domanda {
  final String question1;
  final List<String> opzioni1; 
  final String question2;
  final List<String> opzioni2; 

  PassoFalso({
    required super.testo,
    required this.question1,
    required this.opzioni1,
    required this.question2,
    required this.opzioni2,
  }) : super(tipo: 'passo_falso');
}


//Altri tipi di domande(classi) -> vengono selezionati da Activity_loader