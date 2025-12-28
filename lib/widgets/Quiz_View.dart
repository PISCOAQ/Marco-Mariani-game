import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  final dynamic quiz; 
  final VoidCallback onConsegna;
  const QuizView({super.key, required this.quiz, required this.onConsegna});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _currentIndex = 0; 
  
  // 1. MODIFICA: Mappa per ricordare le risposte (Indice Domanda : Indice Risposta)
  Map<int, int?> _risposteSalvate = {};

  @override
  Widget build(BuildContext context) {
    final domanda = widget.quiz.domande[_currentIndex];
    final bool isLast = _currentIndex == widget.quiz.domande.length - 1;

    return Column(
      children: [
        Text(
          widget.quiz.titolo,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
        Text("Domanda ${_currentIndex + 1} di ${widget.quiz.domande.length}"),
        const SizedBox(height: 10),

        Expanded(
          child: Row(
            children: [
              _buildNavArrow(
                icon: Icons.arrow_back_ios_new, 
                onPressed: _currentIndex > 0 ? () => setState(() => _currentIndex--) : null
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
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      Column(
                        children: [
                          Row(
                            children: [
                              _buildOption(domanda.opzioni[0], 0),
                              const SizedBox(width: 12),
                              _buildOption(domanda.opzioni[1], 1),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildOption(domanda.opzioni[2], 2),
                              const SizedBox(width: 12),
                              _buildOption(domanda.opzioni[3], 3),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              _buildNavArrow(
                icon: Icons.arrow_forward_ios, 
                onPressed: !isLast ? () => setState(() => _currentIndex++) : null
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            // 2. MODIFICA: Chiamata alla funzione di conferma
            onPressed: () => _mostraConfermaConsegna(context),
            child: const Text("CONSEGNA QUIZ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          )
        else
          const SizedBox(height: 50),
      ],
    );
  }

  // 3. FUNZIONE: Dialog di conferma
  void _mostraConfermaConsegna(BuildContext context) {
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
                widget.onConsegna();
                print("Quiz consegnato con risposte: $_risposteSalvate");
                // Qui potresti chiamare la funzione per chiudere l'overlay o calcolare il punteggio
              },
              child: const Text("CONSEGNA", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavArrow({required IconData icon, VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: IconButton(
        icon: Icon(icon, size: 30),
        color: onPressed == null ? Colors.grey[400] : Colors.blueGrey[700],
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildOption(String testo, int index) {
    // Controlla se questa opzione è quella salvata per la domanda attuale
    bool isSelected = _risposteSalvate[_currentIndex] == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            // Salva la risposta per l'indice corrente
            _risposteSalvate[_currentIndex] = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 70, 
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[700] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue[900]! : Colors.grey[400]!,
              width: isSelected ? 3 : 1,
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            testo,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
