import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';

class QuizManager {
  static bool valutaQuiz(dynamic quiz, Map<int, List<String>> risposteUtente) {
    int risposteCorretteTotali = 0;
    int domandeTotali = 0;

    print("--- INIZIO VALUTAZIONE QUIZ: ${quiz.titolo} ---");

    // Cicliamo le pagine del quiz
    for (int i = 0; i < quiz.pagine.length; i++) {
      var pagina = quiz.pagine[i];
      List<String> risposteDellaPagina = risposteUtente[i] ?? [];
      
      int corretteInPagina = 0;

      // 1. DISTINGUIAMO IL TIPO DI PAGINA
      if (pagina is AttribuzioneEmozioni || pagina is EyesTask) {
        // Supponiamo che questi usino il confronto per INDICI
        corretteInPagina = _valutaPerTesto(pagina, risposteDellaPagina);
      } else {
        // Altri quiz semplici usano il confronto per TESTO
        corretteInPagina = _valutaPerIndici(pagina, risposteDellaPagina);
      }

      domandeTotali += (pagina.lista_domande.length as int);
      risposteCorretteTotali += corretteInPagina;

      print("Pagina ${i + 1}: $corretteInPagina corrette su ${pagina.lista_domande.length}");
    }

    // 2. RISULTATO FINALE SU TERMINALE
    print("---------------------------------------");
    print("RISULTATO FINALE:");
    print("Totale: $risposteCorretteTotali / $domandeTotali");
    
    // Semplice soglia fissa al 60% per ora
    bool superato = risposteCorretteTotali >= (domandeTotali * 0.6);    //Superamento quiz 60%
    print("ESITO: ${superato ? "SUPERATO ✅" : "NON SUPERATO ❌"}");
    print("---------------------------------------");
    return superato;
  }

  // LOGICA PER SCELTA MULTIPLA (Confronto Indici)
  static int _valutaPerIndici(dynamic pagina, List<String> risposte) {
    int contatore = 0;
    for (int i = 0; i < pagina.lista_domande.length; i++) {
      var domanda = pagina.lista_domande[i];
      // Trasformiamo la stringa dell'utente in numero (l'indice scelto)
      int? sceltaUtente = int.tryParse(risposte.length > i ? risposte[i] : "");
      
      if (domanda.correct_index != null && domanda.correct_index.contains(sceltaUtente)) {
        contatore++;
      }
    }
    return contatore;
  }

  // LOGICA PER RISPOSTA APERTA (Confronto Testuale)
  static int _valutaPerTesto(dynamic pagina, List<String> risposte) {
    int contatore = 0;
    for (int i = 0; i < pagina.lista_domande.length; i++) {
      var domanda = pagina.lista_domande[i];
      String rispostaUtente = (risposte.length > i ? risposte[i] : "").trim().toLowerCase();
      
      // Verifichiamo se la risposta è in lista (se presente)
      if (domanda.risposte_corrette != null) {
        bool corretta = domanda.risposte_corrette
            .map((r) => r.toString().trim().toLowerCase())
            .contains(rispostaUtente);
        if (corretta) contatore++;
      }
    }
    return contatore;
  }
}