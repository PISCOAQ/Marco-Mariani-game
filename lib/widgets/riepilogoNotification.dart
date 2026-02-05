import 'package:flutter/material.dart';

class RiepilogoNotification extends StatelessWidget {
  final bool superato;
  final int monete;
  final VoidCallback onContinue; 

  const RiepilogoNotification({
    super.key,
    required this.superato,
    required this.monete,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // Testi semplificati: non facciamo più riferimento a cammini che "proseguono" 
    // in modo diverso, ma solo al risultato ottenuto.
    final String titolo = superato ? "COMPLETATO! 🏆" : "OTTIMO LAVORO! ✨";

    return Container(
      color: Colors.black54, 
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: superato ? Colors.amber : Colors.blue, 
              width: 6
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(titolo, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              // Visualizzazione monete raccolte
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 40),
                  Text(" +$monete", style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                ],
              ),
              
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: superato ? Colors.orange.shade700 : Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                ),
                onPressed: onContinue,
                child: const Text(
                  "AVANTI TUTTA!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}