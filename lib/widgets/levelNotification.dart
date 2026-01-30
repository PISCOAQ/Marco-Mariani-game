import 'package:flutter/material.dart';

class LevelNotification extends StatelessWidget {
  final dynamic game;
  const LevelNotification({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.elasticOut,
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value.clamp(0, 1),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  // Sfondo scuro premium con bordo verde neon
                  color: const Color(0xFF1A1A2E).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.green, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icona Bussola Esplorazione
                    const Icon(
                      Icons.explore_rounded,
                      size: 90,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    
                    const Text(
                      "MAPPA ESPANSA",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(color: Colors.green, thickness: 2, indent: 50, endIndent: 50),
                    ),
                    
                    const Text(
                      "LIVELLO SBLOCCATO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Container dei dettagli sblocco - OTTIMIZZATO PER IL CENTRAGGIO
                    Container(
                      width: double.infinity, // Prende tutta la larghezza disponibile
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Centra la riga orizzontalmente
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.lock_open_rounded, color: Colors.green, size: 24),
                          SizedBox(width: 12),
                          Text(
                            "Nuovi passaggi sbloccati",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    const Text(
                      "L'esplorazione continua...",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}