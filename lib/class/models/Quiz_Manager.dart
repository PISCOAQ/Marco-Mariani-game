import 'dart:convert';
import 'dart:html' as html;
import 'package:gioco_demo/class/logic/valutazione_quiz/Valuta_AttribuzioneEmozioni.dart';
import 'package:gioco_demo/class/logic/valutazione_quiz/Valuta_EyesTask.dart';
import 'package:gioco_demo/class/logic/valutazione_quiz/Valuta_PassoFalso.dart';
import 'package:gioco_demo/class/logic/valutazione_quiz/Valuta_SituazioniSociali.dart';
import 'package:gioco_demo/class/logic/valutazione_quiz/Valuta_TeoriaMente.dart';
import 'package:gioco_demo/class/logic/valutazione_quiz/esito_pagina.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Quiz_Results.dart';


class QuizManager {
  
  static Future<QuizResult> valutaQuiz(dynamic quiz, Map<int, List<String>> risposteUtente) async {
    int corretteTotali = 0;
    int domandeTotali = 0;
    List<Map<String, dynamic>> dettaglioPagine = [];

    for (int i = 0; i < quiz.pagine.length; i++) {
      var pagina = quiz.pagine[i];
      List<String> risposteDellaPagina = risposteUtente[i] ?? [];
      
      EsitoPagina esito;

      // --- IL CENTRALINO (Routing della logica) ---
      if (pagina is AttribuzioneEmozioni) {
        esito = calcolaAttribuzioneEmozioni(pagina, risposteDellaPagina);
      } 
      else if (pagina is EyesTask) {
        esito = calcolaEyesTask(pagina, risposteDellaPagina);
      }
      else if (pagina is TeoriaDellaMente) {
        esito = calcolaTeoriaDellaMente(pagina, risposteDellaPagina);
      }
      else if (pagina is PassoFalso) {
        esito = calcolaPassoFalso(pagina, risposteDellaPagina);
      }
      else if (pagina is SituazioniSociali) {
        esito = calcolaSituazioniSociali(pagina, risposteDellaPagina);
      }
      else {
        // Fallback per quiz non ancora mappati
        esito = _valutaGenerica(pagina, risposteDellaPagina);
      }

      // Costruiamo il dettaglio pagina per il JSON
      dettaglioPagine.add({
        'pagina_index': i,
        'paginaSuperata': esito.paginaSuperata,
      });

      corretteTotali += esito.esitiDomande.where((e) => e).length;
      domandeTotali += esito.esitiDomande.length;
    }

    QuizResult risultato = QuizResult(
      idQuiz: quiz.id ?? "ID_MANCANTE",
      titoloQuiz: quiz.titolo,
      superato: corretteTotali >= (domandeTotali * 0.6),
      moneteGuadagnate: _calcolaMonete(corretteTotali, domandeTotali),
      corrette: corretteTotali,
      totali: domandeTotali,
      dettaglioPagine: dettaglioPagine,
    );

    _scaricaJsonWeb(risultato);
    return risultato;
  }

  static EsitoPagina _valutaGenerica(dynamic pagina, List<String> risposte) {
    List<bool> esiti = [];
    for (int i = 0; i < pagina.lista_domande.length; i++) {
      var domanda = pagina.lista_domande[i];
      String risp = (risposte.length > i ? risposte[i] : "").trim().toLowerCase();
      
      bool ok = false;
      if (domanda.risposte_corrette != null) {
        ok = domanda.risposte_corrette!.map((r) => r.toString().toLowerCase()).contains(risp);
      }
      esiti.add(ok);
    }
    return EsitoPagina(esitiDomande: esiti, paginaSuperata: esiti.every((e) => e));
  }

  static int _calcolaMonete(int corrette, int totali) {
    if (totali == 0) return 0;
    double valorePerDomanda = (totali <= 5) ? 10.0 : (totali <= 10) ? 7.0 : 5.0;
    return (corrette * valorePerDomanda).toInt();
  }

  static void _scaricaJsonWeb(QuizResult res) {
    try {
      // Creiamo una mappa temporanea per aggiungere l'ID utente solo nel JSON
      Map<String, dynamic> jsonOut = res.toJson();

      final encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(jsonOut);
      final blob = html.Blob([jsonString], 'application/json');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Risultato_${res.titoloQuiz.replaceAll(' ', '_')}.json")
        ..click();
      
      html.Url.revokeObjectUrl(url);
    } catch (e) { print("Errore download: $e"); }
  }
}