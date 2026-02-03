import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/widgets/Quiz_View.dart';

class PageOverlay extends StatelessWidget {
  final Function(bool superato) onExit;
  final dynamic attivita; // Riceve l'oggetto Quiz o Esercitazione

  const PageOverlay({super.key, required this.onExit, required this.attivita});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Rende lo sfondo semiOscurato
        Container(color: Colors.black.withOpacity(0.6)),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.95),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          margin: const EdgeInsets.all(40.0),
          child: Stack(
            children: [
              // CONTENUTO DINAMICO
              Padding(
                padding: const EdgeInsets.all(24),
                child: _buildContent(),
              ),
              
              if(attivita is Esercitazione) //La possibilità di uscita è possibile sono in esercitazione
                // Icona chiusura (X)
                Positioned(
                  top: 10, right: 10,
                  child: GestureDetector(
                    // CORREZIONE: Aggiungi () => per renderla una funzione richiamabile al click
                    onTap: () => onExit(false), 
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 15,
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (attivita is Quiz) {
      // 2. Passiamo l'esito ricevuto da QuizView verso onExit
      return QuizView(
        quiz: attivita, 
        onConsegna: (esito) => onExit(esito), 
      );
    } else if (attivita is Esercitazione) {
      // Per le esercitazioni, potresti decidere che chiuderle equivale a superarle
      // o gestire una logica diversa. Per ora facciamo tornare true al click.
      return Center(
        child: Column(
          children: [
            Text("Esercitazione: ${attivita.titolo}"),
            ElevatedButton(onPressed: () => onExit(true), child: const Text("Fine"))
          ],
        )
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

}