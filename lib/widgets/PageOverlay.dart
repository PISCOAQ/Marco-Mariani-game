import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Quiz_Results.dart';
import 'package:gioco_demo/widgets/Quiz_View.dart';

class PageOverlay extends StatefulWidget {
  final Function(dynamic esitoQuiz) onExit;
  final dynamic attivita;
  final int tentativoAttuale;

  const PageOverlay({
    super.key,
    required this.onExit,
    required this.attivita,
    required this.tentativoAttuale,
  });

  @override
  State<PageOverlay> createState() => _ControlledPageOverlayState();
}

class _ControlledPageOverlayState extends State<PageOverlay> {
  final GlobalKey<QuizViewState> _quizKey = GlobalKey<QuizViewState>();
  bool _isPageComplete = false;

  void _updateCompletionStatus(bool complete) {
    if (_isPageComplete != complete) {
      setState(() => _isPageComplete = complete);
    }
  }

  // --- AGGIUNTO: Questa funzione forza il rebuild dell'Overlay ---
  void _forceRefresh() {
    setState(() {}); 
  }

@override
Widget build(BuildContext context) {
  return Stack(
    children: [
      Container(color: Colors.black.withOpacity(0.6)),
      Container(
        margin: const EdgeInsets.all(40.0), // Resta il margine bianco esterno
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.95),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              // AREA QUIZ: Padding orizzontale ridotto a 10 per far allargare il grigio
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _buildContent(),
              ),
              // FOOTER: Spazio per i pulsanti
              Expanded(
                child: Center(
                  child: _buildNavigationFooter(),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildNavigationFooter() {
  final bool isPrima = _quizKey.currentState?.isPrimaPagina ?? true;
  final bool isUltima = _quizKey.currentState?.isUltimaPagina ?? false;

  // Logica di abilitazione
  // Il tasto indietro è premibile SOLO se la pagina è completa E non è la prima
  bool canGoBack = _isPageComplete && !isPrima;
  // Il tasto avanti è premibile SOLO se la pagina è completa
  bool canGoForward = _isPageComplete;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 300),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TASTO INDIETRO (Sempre visibile)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            // Colore: BlueGrey se attivo, Grigio se disabilitato
            backgroundColor: canGoBack ? Colors.blueGrey : Colors.grey[400],
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: canGoBack ? 5 : 0,
          ),
          onPressed: canGoBack 
              ? () => _quizKey.currentState?.paginaPrecedente() 
              : null,
          child: const Text(
            "INDIETRO", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
          ),
        ),

        // TASTO AVANTI / CONSEGNA (Sempre visibile)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            // Colore: Verde se attivo, Grigio se disabilitato
            backgroundColor: canGoForward 
                ? (isUltima ? Colors.green[700] : Colors.green[600]) 
                : Colors.grey[400],
            padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: canGoForward ? 5 : 0,
          ),
          onPressed: canGoForward 
              ? () => _quizKey.currentState?.prossimaPagina() 
              : null,
          child: Text(
            isUltima ? "CONSEGNA" : "AVANTI",
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildContent() {
    if (widget.attivita is Quiz) {
      return QuizView(
        key: _quizKey,
        quiz: widget.attivita,
        tentativoQuiz: widget.tentativoAttuale,
        onStatusChanged: _updateCompletionStatus,
        onPageChanged: _forceRefresh, // <--- PASSIAMO IL REFRESH QUI
        onConsegna: (QuizResult esito) => widget.onExit(esito),
      );
    }
    return const SizedBox();
  }
}