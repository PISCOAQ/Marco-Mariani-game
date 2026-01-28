import 'package:flutter/material.dart';

class GameLoadingScreen extends StatelessWidget {
  final double progress;

  const GameLoadingScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A), // Colore di sfondo scuro e gaming
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icona animata o Logo
            const Icon(Icons.map_rounded, size: 100, color: Colors.green),
            const SizedBox(height: 30),
            
            // Testo di stato
            const Text(
              "Generazione Mondo...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 20),

            // Barra di caricamento
            SizedBox(
              width: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: Colors.white10,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Percentuale
            Text(
              "${(progress * 100).toInt()}%",
              style: const TextStyle(color: Colors.green, decoration: TextDecoration.none, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}