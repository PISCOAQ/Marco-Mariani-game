import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Percorso.dart';

class PercorsoSelector extends StatelessWidget {
  final List<Percorso> listaPercorsi; 
  final Percorso? selectedPercorso;  
  final Function(Percorso) onPercorsoSelected;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  const PercorsoSelector({
    required this.listaPercorsi,
    this.selectedPercorso,
    required this.onPercorsoSelected,
    required this.onConfirm,
    required this.onBack,
    super.key,
  });

  Widget _buildPercorsoTile(BuildContext context, Percorso percorso) {
    final isSelected = selectedPercorso == percorso;

    return GestureDetector(
      onTap: () => onPercorsoSelected(percorso),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected
                ? Colors.yellowAccent.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            border: isSelected
                ? Border.all(color: Colors.yellowAccent, width: 4)
                : Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.yellowAccent.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              percorso.nomePercorso,
              textAlign: TextAlign.center,
              style: TextStyle(
                // Rimuoviamo il condizionale isSelected ? Colors.yellowAccent : Colors.white
                color: Colors.white, 
                fontSize: 22,
                // Manteniamo il grassetto extra se selezionato per dare comunque un feedback visivo
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 500),
        child: Stack(
          children: [
            // CONTENUTO
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Scegli il tuo percorso',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                
                // LISTA SCROLLABILE DEI PERCORSI
                Expanded(
                  child: ListView.builder(
                    itemCount: listaPercorsi.length,
                    itemBuilder: (context, index) {
                      return _buildPercorsoTile(context, listaPercorsi[index]);
                    },
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // PULSANTE CONFERMA (Identico ad AvatarSelector)
                ElevatedButton(
                  onPressed: selectedPercorso != null ? onConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 251, 119, 67),
                    disabledBackgroundColor: const Color.fromARGB(255, 251, 119, 67),
                    foregroundColor: Colors.brown[900],
                    disabledForegroundColor: Colors.white.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Conferma',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),

            // PULSANTE CHIUDI (X)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onBack,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}