import 'package:flutter/material.dart';

class EndGamenotification extends StatelessWidget {
  final dynamic game;
  final VoidCallback onClose;

  const EndGamenotification({
    super.key,
    this.game,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 1500),
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
                  color: const Color(0xFF1A1A2E).withOpacity(0.98),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.amber, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events_rounded,
                      size: 80,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "PERCORSO COMPLETATO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Colors.amber, thickness: 2, indent: 40, endIndent: 40),
                    ),
                    const Text(
                      "COMPLIMENTI!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber.withOpacity(0.2)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 24),
                          SizedBox(height: 8),
                          Text(
                            "Hai concluso con successo\ntutte le tappe del viaggio!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                                        
                    const Text(
                      "Sei stato formidabile!",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.amberAccent,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- PULSANTE MIGLIORATO ---
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onClose,
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min, // Questo lo rende stretto quanto serve!
                            children: [
                              Icon(Icons.home_rounded, color: Color(0xFF1A1A2E)),
                              SizedBox(width: 8),
                              Text(
                                "HOME",
                                style: TextStyle(
                                  color: Color(0xFF1A1A2E),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
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