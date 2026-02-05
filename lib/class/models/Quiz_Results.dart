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

  Map<String, dynamic> toJson() {
      return {
        'idQuiz': idQuiz,
        'titoloQuiz': titoloQuiz,
        'superato': superato,
        'punteggio_totale': { 
          'corrette': corrette,
          'totali': totali,
        },
        'dettaglio_pagine': dettaglioPagine, 
      };
    }
}