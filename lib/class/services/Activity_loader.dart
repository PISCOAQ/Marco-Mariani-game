import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gioco_demo/class/models/Domanda.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';


class ActivityLoader {
  static const String _path = '/data/data.json';

  static Future<Quiz> carica() async {
    final String response = await rootBundle.loadString(_path);
    final Map<String, dynamic> data = json.decode(response);

    // Chiamiamo direttamente il costruttore del quiz
    return _costruisciQuiz(data);
  }

  static Quiz _costruisciQuiz(Map<String, dynamic> data) {
    final String type = data["type"] ?? "";
    final String id = data["_id"] ?? "";
    final String titolo = data["title"] ?? "Quiz";
    
    List<Pagina> listaPagine = [];

    switch (type) {
      case 'EmotionAttributionTestNode':
      
        final List<dynamic> questionsRaw = data['data']['questions'] ?? [];
        
        for (var q in questionsRaw) {
          // Creiamo la singola domanda tecnica
          Domanda quesitoTecnico = Domanda(
            testo: q['question'] ?? "",
            opzioni: [], 
            risposte_corrette: List<String>.from(q['correctAnswers'] ?? []),
            correct_index: null,
          );

          // Creiamo la Pagina (una per ogni elemento della lista questions)
          listaPagine.add(AttribuzioneEmozioni(
            narrazione: q['narration'] ?? "",
            lista_domande: [quesitoTecnico],
          ));
        }
        break;


      case 'EyesTaskTestNode':
        final List<dynamic> questionsRaw = data['data']['questions'] ?? [];
        for (var q in questionsRaw) {
          List<String> opzioni = List<String>.from(q['answers'] ?? []);
          int? cIndex = q['correctIndex'];

          // Creiamo una pagina per ogni domanda presente nel JSON
          listaPagine.add(EyesTask(
            imagePath: q['image'] ?? "", // Se manca, la View mostrerà il placeholder
            lista_domande: [
              Domanda(
                // SE q['question'] MANCA, USIAMO IL TESTO DI DEFAULT
                testo: q['question'] ?? "Quale emozione esprimono questi occhi?",
                opzioni: opzioni,
                correct_index: cIndex != null ? [cIndex] : null,
                risposte_corrette: null,
              )
            ],
          ));
        }
        break;


      case 'TeoriaDellaMenteNode':
        final List<dynamic> quizRaw = data['data']['quiz'] ?? [];
        
        for (var scenario in quizRaw) {
          List<Domanda> domandeDelloScenario = [];
          final List<dynamic> questionsRaw = scenario['questions'] ?? [];

          for (var q in questionsRaw) {
            List<String> opzioni = List<String>.from(q['answers'] ?? []);
            int? cIndex = q['correctIndex'];
            
            domandeDelloScenario.add(Domanda(
              testo: q['question'] ?? "",
              opzioni: opzioni,
              correct_index: cIndex != null ? [cIndex] : null,
            ));
          }

          listaPagine.add(TeoriaDellaMente(
            narrazione: scenario['narration'] ?? "",
            lista_domande: domandeDelloScenario,
          ));
        }
        break;
      

      case 'socialSituationsNode':
        final List<dynamic> items = data['data']['items'] ?? [];
        for (var item in items) {
          final List<dynamic> sections = item['sections'] ?? [];
          for (var s in sections) {
            listaPagine.add(SituazioniSociali(
              narrazione_before: s['before'],
              bold: s['bold'] ?? "",
              narrazione_after: s['after'],
              lista_domande: [
                Domanda(
                  testo: "Scegli l'opzione corretta:",
                  opzioni: List<String>.from(s['answers'] ?? []),
                  correct_index: List<int>.from(s['correctIndexes'] ?? []), // Logica indici (lista)
                  risposte_corrette: null,
                )
              ],
            ));
          }
        }
        break;


      case 'FauxPasNode':
        final List<dynamic> quizRaw = data['data']['quiz'] ?? [];
        for (var scenario in quizRaw) {
          List<Domanda> domandeDelloScenario = [];
          final List<dynamic> questionsRaw = scenario['questions'] ?? [];

          for (var q in questionsRaw) {
            List<String> opzioni = List<String>.from(q['answers'] ?? []);
            int? cIndex = q['correctIndex'];

            domandeDelloScenario.add(Domanda(
              testo: q['question'] ?? "",
              opzioni: opzioni,
              correct_index: cIndex != null ? [cIndex] : null,
            ));
          }
          listaPagine.add(PassoFalso(
            narrazione: scenario['narration'] ?? "",
            lista_domande: domandeDelloScenario,
          ));
        }
        break;
        
    }

    // Restituiamo l'oggetto Quiz completo
    return Quiz(
      id: id,
      titolo: titolo,
      pagine: listaPagine,
    );
  }
}