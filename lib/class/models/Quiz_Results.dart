class QuizResult {
  final String idQuiz;
  final String titoloQuiz;
  final bool superato;
  final int corrette; // Totale assoluto
  final int totali;   // Totale assoluto
  final int moneteGuadagnate;
  final List<Map<String, dynamic>> dettaglioPagine;

  QuizResult({
      required this.idQuiz,
      required this.titoloQuiz,
      required this.superato,
      required this.corrette,
      required this.totali,
      required this.moneteGuadagnate,
      required this.dettaglioPagine,
    });

    // Aggiungiamo 'codice' come parametro alla funzione
    Map<String, dynamic> toJson(String codice) {
      int sommaTempi = 0;
      double sommaDistanza = 0;
      
      for (var pagina in dettaglioPagine) {
        sommaTempi += (pagina['tempo_reazione_ms'] as num? ?? 0).toInt();
        sommaDistanza += (pagina['distanza_mouse_px'] as num? ?? 0).toDouble();
      }

      double mediaReazione = dettaglioPagine.isNotEmpty ? sommaTempi / dettaglioPagine.length : 0;

      return {
        'codiceGioco': codice,      // <--- AGGIUNTO: Obbligatorio per il controller di Jacopo
        'testId': idQuiz,
        'nomeTest': titoloQuiz,
        'tipoTest': 'pre',          // Jacopo accetta solo 'pre' o 'post'
        'percorsoId': 'default',    
        'superato': superato,
        'tempoMedioReazione': mediaReazione.toInt(),
        'movimentoMouse': sommaDistanza.round(), 
        'domande': dettaglioPagine.map((p) => {
          'indice': p['pagina_index'],
          'correct': p['paginaSuperata'],
          'reactionTime': p['tempo_reazione_ms']
        }).toList(),
      };
    }
}