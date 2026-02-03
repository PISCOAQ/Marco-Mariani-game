/*import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class DomandaSceltaMultiplaView extends StatelessWidget {
  final DomandaSceltaMultipla domanda;
  final int? rispostaSelezionata;
  final ValueChanged<int> onRisposta;

  const DomandaSceltaMultiplaView({
    super.key,
    required this.domanda,
    required this.rispostaSelezionata,
    required this.onRisposta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            domanda.testo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),

        const SizedBox(height: 150),
        
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
    );
  }

  Widget _buildOption(String testo, int index) {
    final bool isSelected = rispostaSelezionata == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onRisposta(index),
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
}*/