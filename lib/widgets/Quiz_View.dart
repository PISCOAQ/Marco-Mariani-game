import 'package:flutter/material.dart';
import 'package:gioco_demo/class/logic/valutazione_quiz/mouse_tracker.dart';
import 'package:gioco_demo/class/logic/valutazione_quiz/tempo_reazione.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Quiz_Manager.dart';
import 'package:gioco_demo/class/models/Quiz_Results.dart';
import 'package:gioco_demo/widgets/eyes_task_view.dart';
import 'package:gioco_demo/widgets/passo_falso_view.dart';
import 'package:gioco_demo/widgets/situazioni_sociali_view.dart';
import 'package:gioco_demo/widgets/teoria_della_mente_view.dart';
import 'attribuzione_emozioni_view.dart';

class QuizView extends StatefulWidget {
  final dynamic quiz;
  final int tentativoQuiz;
  final Function(QuizResult esitoQuiz) onConsegna;
  final Function(bool isComplete)? onStatusChanged;
  final VoidCallback? onPageChanged; 

  const QuizView({
    super.key,
    required this.quiz,
    required this.tentativoQuiz,
    required this.onConsegna,
    this.onStatusChanged,
    this.onPageChanged, 
  });

  @override
  State<QuizView> createState() => QuizViewState();
}

class QuizViewState extends State<QuizView> {
  int _currentIndex = 0;

  final ReactionTimer _timer = ReactionTimer();
  final MouseTracker _mouseTracker = MouseTracker();

  final Map<int, List<Map<String, dynamic>>> _risposteQuiz = {};
  

  @override
  void initState() {
    super.initState();
    _timer.start(); // Start per la prima pagina
    _mouseTracker.start();

    // Inizializziamo la mappa con valori vuoti e tempo 0
    for (int i = 0; i < widget.quiz.pagine.length; i++) {
      _risposteQuiz[i] = List.generate(
        widget.quiz.pagine[i].lista_domande.length,
        (_) => {"risposta": "", "tempo_reazione": 0},
      );
    }
  }

  bool get isUltimaPagina => _currentIndex == widget.quiz.pagine.length - 1;
  bool get isPrimaPagina => _currentIndex == 0;

  void prossimaPagina() {
    if (isUltimaPagina) {
      _mostraConfermaConsegna(context);
    } else {
      setState(() {
        _currentIndex++;
      });
      _timer.start();
      _mouseTracker.start();
      _notificaStatoPagina();
      widget.onPageChanged?.call();
    }
  }

  void paginaPrecedente() {
    if (!isPrimaPagina) {
      setState(() {
        _currentIndex--;
      });
      _notificaStatoPagina();
      widget.onPageChanged?.call();
    }
  }

  void _notificaStatoPagina() {
    final risposteCorrenti = _risposteQuiz[_currentIndex] ?? [];
    // Controlliamo se tutte le risposte della pagina sono state date
    bool isComplete = risposteCorrenti.isNotEmpty && 
                     !risposteCorrenti.any((r) => r["risposta"] == "");
    
    widget.onStatusChanged?.call(isComplete);
  }

@override
Widget build(BuildContext context) {
  final pagina = widget.quiz.pagine[_currentIndex];

  return Column(
    children: [
      Text(
        widget.quiz.titolo,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
      Text("Pagina ${_currentIndex + 1} di ${widget.quiz.pagine.length}"),
      const SizedBox(height: 10),

      
      MouseRegion(
        onHover: (event) {
          _mouseTracker.recordMovement(event.localPosition);
        },
        child: Container(
          width: double.infinity, 
          height: 460, 
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: _buildPaginaWidget(pagina),
            ),
          ),
        ),
      ),
    ],
  );
}

  // 🔀 SWITCH DELLA UI IN BASE AL TIPO DI PAGINA
  Widget _buildPaginaWidget(Pagina pagina) {
    // Estraiamo solo i testi delle risposte per non rompere le tue View figlie
    final List<Map<String, dynamic>> datiPagina = _risposteQuiz[_currentIndex] ?? [];
    final List<String> risposteCorrenti = datiPagina.map((e) => e["risposta"].toString()).toList();

    void updateAnswers(List<String> nuovaLista) {
      // 1. Controlliamo se la risposta per questa pagina è già stata salvata definitivamente
      // Verifichiamo se il tempo di reazione è già diverso da 0
      final bool giaRisposto = _risposteQuiz[_currentIndex] != null && 
                              _risposteQuiz[_currentIndex]!.any((r) => r["tempo_reazione"] > 0);

      if (giaRisposto) {
        // Se ha già risposto la prima volta, aggiorniamo solo il TESTO della risposta
        // ma NON tocchiamo tempo e distanza.
        setState(() {
          for (int i = 0; i < nuovaLista.length; i++) {
            _risposteQuiz[_currentIndex]![i]["risposta"] = nuovaLista[i];
          }
        });
      } else {
        // 2. È LA PRIMA VOLTA: Registriamo tutto (Tempo + Distanza + Risposta)
        final int tempoOttenuto = _timer.stop();
        final double distanzaMouse = _mouseTracker.stop();

        setState(() {
          _risposteQuiz[_currentIndex] = nuovaLista.map((testo) => {
            "risposta": testo,
            "tempo_reazione": tempoOttenuto,
            "distanza_mouse": distanzaMouse,
          }).toList();
        });
      }

      _notificaStatoPagina();
    }

    if (pagina is AttribuzioneEmozioni) {
      return AttribuzioneEmozioniView(
        pagina: pagina,
        risposteDate: risposteCorrenti,
        onChanged: updateAnswers,
      );
    }

    if (pagina is EyesTask) {
      return EyesTaskView(
        pagina: pagina,
        risposteDate: risposteCorrenti,
        onChanged: updateAnswers,
      );
    }

    if (pagina is TeoriaDellaMente) {
      return TeoriaMenteView(
        pagina: pagina,
        risposteDate: risposteCorrenti,
        onChanged: updateAnswers,
      );
    }

    if (pagina is SituazioniSociali) {
      return SituazioniSocialiView(
        pagina: pagina,
        risposteDate: risposteCorrenti,
        onChanged: updateAnswers,      
      );
    }

    if (pagina is PassoFalso) {
      return PassoFalsoView(
        pagina: pagina,
        risposteDate: risposteCorrenti,
        onChanged: updateAnswers,
      );
    }
    return const Text("Tipo di domanda non supportato");
  }

  //DIALOG CONFERMA CONSEGNA
  void _mostraConfermaConsegna(BuildContext context) {
    // 1. Correzione controllo incompleto: 
    // Dobbiamo verificare se dentro le mappe c'è qualche "risposta" vuota
    bool incompleto = _risposteQuiz.values.any(
      (lista) => lista.any((mappa) => mappa["risposta"] == "")
    );

    if (incompleto) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Quiz incompleto"),
            content: const Text("Devi rispondere a tutte le domande prima di consegnare!"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                onPressed: () => Navigator.pop(context),
                child: const Text("HO CAPITO", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
      return; 
    }

    // 2. Se è completo, mostriamo il dialog di conferma reale
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Conferma Consegna"),
          content: const Text("Sei sicuro di voler consegnare il quiz? Non potrai più modificare le tue risposte."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ANNULLA", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                // Chiamiamo il manager passando direttamente la mappa con tempi e distanze
                QuizResult risultato = await QuizManager.valutaQuiz(
                  widget.quiz, 
                  _risposteQuiz, 
                );

                Navigator.pop(context); // Chiude il dialog
                FocusScope.of(context).unfocus(); // Chiude la tastiera
                
                // Invia il risultato finale
                widget.onConsegna(risultato);
              },
              child: const Text("CONSEGNA", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

/*
  Widget _buildNavArrow({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 30),
      color: onPressed == null ? Colors.grey[400] : Colors.blueGrey[700],
      onPressed: onPressed,
    );
  }*/
}

