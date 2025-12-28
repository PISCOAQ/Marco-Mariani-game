import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/widgets/Quiz_View.dart';

class PageOverlay extends StatelessWidget {
  final VoidCallback onExit;
  final dynamic attivita; // Riceve l'oggetto Quiz o Esercitazione

  const PageOverlay({super.key, required this.onExit, required this.attivita});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          
          // Icona chiusura (X)
          Positioned(
            top: 10, right: 10,
            child: GestureDetector(
              onTap: onExit,
              child: const CircleAvatar(
                backgroundColor: Colors.red,
                radius: 15,
                child: Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
      if (attivita is Quiz) {
        return QuizView(quiz: attivita, onConsegna: onExit); // Chiamiamo il widget specifico per i quiz
      } else if (attivita is Esercitazione) {
        return Center(child: Text("Esercitazione: ${attivita.titolo}"));
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    }
  }