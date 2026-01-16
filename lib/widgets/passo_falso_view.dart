import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class PassoFalsoView extends StatelessWidget {
  final PassoFalso domanda;
  final String? rispostaUtente; // Stringa nel formato "index1|index2"
  final ValueChanged<String> onChanged;

  const PassoFalsoView({
    super.key,
    required this.domanda,
    required this.rispostaUtente,
    required this.onChanged,
  });

  // Aggiorna solo una delle due parti della stringa
  void _updatePart(int questionIndex, int optionIndex) {
    // Se nullo, inizializziamo a "-1|-1" (nessuna selezione)
    List<String> parti = rispostaUtente?.split('|') ?? ["-1", "-1"];
    
    // Sicurezza: assicuriamoci di avere almeno 2 elementi
    if (parti.length < 2) parti = ["-1", "-1"];

    parti[questionIndex] = optionIndex.toString();
    onChanged(parti.join('|'));
  }

  @override
  Widget build(BuildContext context) {
    // Decodifichiamo la stringa per sapere quali bottoni colorare
    final List<String> parti = rispostaUtente?.split('|') ?? ["-1", "-1"];
    final int sel1 = int.tryParse(parti[0]) ?? -1;
    final int sel2 = parti.length > 1 ? (int.tryParse(parti[1]) ?? -1) : -1;

    return Column(
      children: [
        const SizedBox(height: 30),

        // 1. TESTO DELLO SCENARIO (Uguale a Teoria della Mente)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            domanda.testo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(height: 40),

        // 2. PRIMA DOMANDA (Dinamica)
        _buildSezione(
          domanda.question1,
          domanda.opzioni1,
          sel1,
          (idx) => _updatePart(0, idx),
        ),

        const SizedBox(height: 40),

        // 3. SECONDA DOMANDA (Dinamica - Sempre presente)
        _buildSezione(
          domanda.question2,
          domanda.opzioni2,
          sel2,
          (idx) => _updatePart(1, idx),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  // Crea il titolo della domanda e la fila/griglia di bottoni
  Widget _buildSezione(String titolo, List<String> opzioni, int scelto, Function(int) onTap) {
    return Column(
      children: [
        Text(
          titolo,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(opzioni.length, (i) {
            return _buildOptionBtn(opzioni[i], i == scelto, () => onTap(i));
          }),
        ),
      ],
    );
  }

  // Bottone stilizzato (Stesso stile delle altre view)
  Widget _buildOptionBtn(String testo, bool isSelected, VoidCallback onTap) {
    return SizedBox(
      width: 250, // Larghezza fissa per mantenere l'ordine
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue[700] : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          elevation: isSelected ? 2 : 0,
          side: BorderSide(color: isSelected ? Colors.blue[900]! : Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(testo, textAlign: TextAlign.center),
      ),
    );
  }
}