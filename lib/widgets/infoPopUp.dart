import 'package:flutter/material.dart';

class InfoPopup extends StatelessWidget {
  final VoidCallback onExit;

  const InfoPopup({super.key, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Sfondo oscurato cliccabile per chiudere
          GestureDetector(
            onTap: onExit,
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // Più largo per le due colonne
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8, // Più alto e scorrevole
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E).withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12, width: 1),
                boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 30)],
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Header fisso
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          'GUIDA RAPIDA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                      ),

                      // Area centrale SCORREVOLE
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          child: Column(
                            children: [
                              _buildGuideRow(
                                '/images/frecce_tastiera.png',
                                'MOVIMENTO',
                                'Usa le frecce della tastiera per muoverti in alto, in basso, a destra e sinistra nella mappa.',
                              ),
                              _buildGuideRow(
                                '/images/statua_quiz.png',
                                'QUIZ',
                                'Avvicinati alla statua, qui puoi svolgere i quiz per guadagnare monete e sbloccare nuove aree della mappa. Ogni livello richiede una prova diversa!',
                              ),
                              _buildGuideRow(
                                '/images/colonna.png',
                                'ESERCITAZIONI',
                                'Non farti cogliere impreparato! Avvicinati alla statua per affinare le tue abilità e allenare la mente, in modo che i quiz saranno una passeggiata',
                              ),
                              _buildGuideRow(
                                '/images/chest_preview.png',
                                'GUARDAROBA',
                                'Avvicinati al forziere, dove in qualunque momento portai accedere allo shop per acquistare quello che vuoi!',
                              ),
                              _buildGuideRow(
                                '/images/cartello_preview.png',
                                'CARTELLI',
                                'Lungo il cammino troverai numerosi cartelli: quando iniziano a brillare, significa che è il momento di seguirli. La loro luce ti guiderà dritto verso il tuo prossimo obiettivo.',
                              ),
                              _buildGuideRow(
                                '/images/percorso_preview.png',
                                'SCIE DI LUCE',
                                'Il mondo è vasto e sei libero di esplorare ogni angolo, ma non sarai mai solo. Una scia luminosa apparirà sul terreno per suggerirti la rotta ideale: un piccolo aiuto per non smarrire la strada mentre insegui la vittoria.',
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Footer fisso con pulsante
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: onExit,
                          child: const Text(
                            'HO CAPITO',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Pulsante X in alto a destra
                  Positioned(
                    top: 15,
                    right: 15,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54, size: 30),
                      onPressed: onExit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Costruttore della riga a due colonne
  Widget _buildGuideRow(String imagePath, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40), // Spazio tra una riga e l'altra
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // COLONNA SINISTRA: Immagine/Anteprima
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.image_not_supported, color: Colors.white24, size: 40),
              ),
            ),
          ),
          
          const SizedBox(width: 30), // Spazio tra immagine e testo

          // COLONNA DESTRA: Testo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}