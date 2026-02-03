class Domanda {
  final String testo;
  final List<String> opzioni;
  final List<String>? risposte_corrette; //Per attribuzioneEmozioni lista di risposte corrette
  final List<int>? correct_index; //Per gli altri test lista degli index corretti

  Domanda({required this.testo, 
    required this.opzioni, 
    this.risposte_corrette,  //Opzionale
    this.correct_index       //Opzionale
  });
}
