import 'package:flutter/material.dart';

class Quiznotification extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const Quiznotification({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        // Limita la larghezza massima per non farlo sembrare troppo vuoto
        constraints: const BoxConstraints(maxWidth: 400), 
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // Ombra più leggera per distaccarlo dalla mappa
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline, size: 40, color: Color(0xFF455A64)),
              const SizedBox(height: 10),
              const Text(
                "SEI SICURO?",
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black87
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Se inizi il quiz non potrai uscire finché non avrai risposto a tutte le domande.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              
              // Pulsanti vicini al centro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bottone Annulla
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: onCancel,
                      child: const Text("ANNULLA", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(width: 15), // Spazio ridotto tra i due bottoni
                  
                  // Bottone Inizia
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF388E3C), // Verde scuro come in foto
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: onConfirm,
                      child: const Text("INIZIA ORA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}