import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Domanda.dart';
import 'domanda_scelta_multipla_view.dart';
import 'attribuzione_emozioni_view.dart';

class QuizView extends StatefulWidget {
  final dynamic quiz;
  final VoidCallback onConsegna;

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
  final Map<int, dynamic> _risposteQuiz = {};

  /// Risposte aperte (attribuzione emozioni)
  //final Map<int, String?> _risposteAperte = {};

  @override
  Widget build(BuildContext context) {
    final domanda = widget.quiz.domande[_currentIndex];
    final bool isLast = _currentIndex == widget.quiz.domande.length - 1;

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
        Text("Domanda ${_currentIndex + 1} di ${widget.quiz.domande.length}"),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            domanda.testo,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ⬇️ QUI AVVIENE LA MAGIA
                      _buildDomandaWidget(domanda),
                    ],
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
        if (isLast)
          ElevatedButton(
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
        else
          const SizedBox(height: 50),
      ],
    );
  }


  // 🔀 SWITCH DELLA UI IN BASE AL TIPO DI DOMANDA
  Widget _buildDomandaWidget(Domanda domanda) {
    if (domanda is DomandaSceltaMultipla) {
      return DomandaSceltaMultiplaView(
        domanda: domanda,
        rispostaSelezionata: _risposteQuiz[_currentIndex],
        onRisposta: (index) {
          setState(() {
            _risposteQuiz[_currentIndex] = index;
          });
        },
      );
    }

    if (domanda is AttribuzioneEmozioni) {
      return AttribuzioneEmozioniView(
        domanda: domanda,
        rispostaUtente: _risposteQuiz[_currentIndex],
        onChanged: (value) {
          setState(() {
            _risposteQuiz[_currentIndex] = value;
          });
        },
      );
    }

    return const Text("Tipo di domanda non supportato");
  }


  // 📤 DIALOG CONFERMA CONSEGNA
// 📤 DIALOG CONFERMA CONSEGNA (Ripristinato identico all'originale)
  void _mostraConfermaConsegna(BuildContext context) {
    final int totaleDomande = widget.quiz.domande.length;
    final int risposteDate = _risposteQuiz.length;

    if(risposteDate < totaleDomande){
      // Avvisiamo l'utente che non ha risposto ad x domande
      showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Quiz incompleto"),
                content: Text("Hai risposto a $risposteDate domande su $totaleDomande. "
                    "Devi rispondere a tutte le domande prima di consegnare!"),
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

    //Se la condizione passa (NO return) mostra il dialog di consegna quiz
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Conferma Consegna"),
          content: const Text("Sei sicuro di voler consegnare il quiz? Non potrai più modificare le tue risposte."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Chiude solo il dialog
              child: const Text("ANNULLA", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pop(context); // Chiude il dialog
                
                // --- Logica tecnica per sbloccare l'avatar
                FocusScope.of(context).unfocus(); 
                widget.onConsegna(); // Chiude l'overlay tramite MapScreen
                
                //print delle risposte
                print("Quiz consegnato con risposte: $_risposteQuiz");
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

