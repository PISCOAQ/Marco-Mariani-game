import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Domanda.dart';
import 'package:gioco_demo/class/models/Quiz_Manager.dart';
import 'package:gioco_demo/widgets/eyes_task_view.dart';
import 'package:gioco_demo/widgets/passo_falso_view.dart';
import 'package:gioco_demo/widgets/situazioni_sociali_view.dart';
import 'package:gioco_demo/widgets/teoria_della_mente_view.dart';
import 'domanda_scelta_multipla_view.dart';
import 'attribuzione_emozioni_view.dart';

class QuizView extends StatefulWidget {
  final dynamic quiz;
  final Function(bool superato) onConsegna;

  const QuizView({
    super.key,
    required this.quiz,
    required this.onConsegna,
  });

  @override
  State<QuizView> createState() => _QuizViewState();
  
}

class _QuizViewState extends State<QuizView> {
  int _currentIndex = 0;

  /// Risposte chiuse (scelta multipla)
  final Map<int, List<String>> _risposteQuiz = {};

  @override
  void initState() {
    super.initState();
    // Prepariamo i "cassetti" per le risposte
    for (int i = 0; i < widget.quiz.pagine.length; i++) {
      // Ogni pagina ha una lista di stringhe vuote lunga quanto le sue domande
      _risposteQuiz[i] = List.filled(widget.quiz.pagine[i].lista_domande.length, "");
    }
  }

  /// Risposte aperte (attribuzione emozioni)
  //final Map<int, String?> _risposteAperte = {};

  @override
  Widget build(BuildContext context) {
    final pagina = widget.quiz.pagine[_currentIndex];
    final bool isLast = _currentIndex == widget.quiz.pagine.length - 1;

    return Column(
      children: [
        Text(
          widget.quiz.titolo,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        Text("Pagina ${_currentIndex + 1} di ${widget.quiz.pagine.length}"),
        const SizedBox(height: 10),

        Expanded(
          child: Row(
            children: [
              _buildNavArrow(
                icon: Icons.arrow_back_ios_new,
                onPressed: _currentIndex > 0
                    ? () => setState(() => _currentIndex--)
                    : null,
              ),

              Expanded(
                child: Container(
                  // Rimuoviamo il padding verticale dal container per farlo gestire allo scroll
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: LayoutBuilder( // Usiamo LayoutBuilder per conoscere l'altezza disponibile
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            // Forza il contenuto ad essere alto almeno quanto il riquadro grigio
                            minHeight: constraints.maxHeight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              // MainAxisSize.max assicura che la colonna provi a espandersi
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildPaginaWidget(pagina),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              _buildNavArrow(
                icon: Icons.arrow_forward_ios,
                onPressed: !isLast
                    ? () => setState(() => _currentIndex++)
                    : null,
              ),
            ],
          ),
        ),


        const SizedBox(height: 15),

        // 2. Contenitore "parcheggio" con altezza bloccata
        SizedBox(
          height: 40, // Altezza fissa che contiene comodamente il pulsante
          width: double.infinity, // Occupa tutta la larghezza per centrare
          child: Center(
            child: isLast 
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => _mostraConfermaConsegna(context),
                  child: const Text(
                    "CONSEGNA QUIZ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : const SizedBox(), // Se non è l'ultimo, il box resta vuoto ma ALTO hight
          ),
        ),

      ],
    );
  }


  // 🔀 SWITCH DELLA UI IN BASE AL TIPO DI PAGINA
  Widget _buildPaginaWidget(Pagina pagina) {
    // Recuperiamo la lista di risposte per la pagina corrente. 
    // Se per qualche motivo è null, passiamo una lista vuota per evitare crash.
    final List<String> risposteCorrenti = _risposteQuiz[_currentIndex] ?? [];

    if (pagina is AttribuzioneEmozioni) {
      return AttribuzioneEmozioniView(
        pagina: pagina,
        risposteDate: risposteCorrenti, // Nuovo nome parametro
        onChanged: (nuovaLista) {
          // Questo impedisce al TextField di triggerare un build mentre Flutter sta già buildando
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _risposteQuiz[_currentIndex] = nuovaLista);
          });
        },
      );
    }

    if (pagina is EyesTask) {
      return EyesTaskView(
        pagina: pagina,
        risposteDate: risposteCorrenti,
        onChanged: (nuovaLista) {
          setState(() => _risposteQuiz[_currentIndex] = nuovaLista);
        },
      );
    }

    if (pagina is TeoriaDellaMente) {
      return TeoriaMenteView(
        pagina: pagina,
        risposteDate: risposteCorrenti,
        onChanged: (nuovaLista) {
          setState(() => _risposteQuiz[_currentIndex] = nuovaLista);
        },
      );
    }

    if (pagina is SituazioniSociali) {
      return SituazioniSocialiView(
        pagina: pagina,
        risposteDate: risposteCorrenti,
        onChanged: (nuovaLista) => setState(() => _risposteQuiz[_currentIndex] = nuovaLista),
      );
    }

    if (pagina is PassoFalso) {
      return PassoFalsoView(
        pagina: pagina,
        risposteDate: risposteCorrenti,
        onChanged: (nuovaLista) {
          setState(() => _risposteQuiz[_currentIndex] = nuovaLista);
        },
      );
    }
    return const Text("Tipo di domanda non supportato");
  }


  // 📤 DIALOG CONFERMA CONSEGNA
 void _mostraConfermaConsegna(BuildContext context) {
  final int totalePagine = widget.quiz.pagine.length;

  // LOGICA NUOVA: Controlliamo se c'è qualche stringa vuota nelle liste
  // .any((lista) => lista.contains("")) è il modo più veloce per farlo
  bool incompleto = _risposteQuiz.values.any((lista) => lista.contains(""));

  if (incompleto) {
    // --- IL TUO DIALOG ORIGINALE "INCOMPLETO" ---
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Quiz incompleto"),
          content: const Text("Devi rispondere a tutte le domande prima di consegnare!"), // Testo originale
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => Navigator.pop(context),
              child: const Text("HO CAPITO", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
    return;
  }

  // --- IL TUO DIALOG ORIGINALE "CONFERMA" ---
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
            onPressed: () {
              // 1. Chiamiamo il manager e otteniamo l'esito
              bool superato = QuizManager.valutaQuiz(widget.quiz, _risposteQuiz);
              
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
              
              // 2. Passiamo l'esito al callback (devi aggiornare la firma della funzione)
              widget.onConsegna(superato);
            },
            child: const Text("CONSEGNA", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}


  Widget _buildNavArrow({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 30),
      color: onPressed == null ? Colors.grey[400] : Colors.blueGrey[700],
      onPressed: onPressed,
    );
  }
}

