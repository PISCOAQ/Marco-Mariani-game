import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class PassoFalsoView extends StatelessWidget {
  final PassoFalso pagina;
  final List<String> risposteDate; 
  final ValueChanged<List<String>> onChanged;

  const PassoFalsoView({
    super.key,
    required this.pagina,
    required this.risposteDate,
    required this.onChanged,
  });

  // Molto più semplice: aggiorniamo l'indice della lista e via
  void _updatePart(int questionIndex, int optionIndex) {
    List<String> nuovaLista = List.from(risposteDate);
    
    // Se la lista non è ancora stata inizializzata per questa pagina, la prepariamo
    while (nuovaLista.length < pagina.lista_domande.length) {
      nuovaLista.add("");
    }

    nuovaLista[questionIndex] = optionIndex.toString();
    onChanged(nuovaLista);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),

        // 1. TESTO DELLO SCENARIO
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            pagina.narrazione,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(height: 40),

        // 2. CICLO DINAMICO SULLE DOMANDE
        ...pagina.lista_domande.asMap().entries.map((entry) {
          int idx = entry.key;
          Domanda domandaSingola = entry.value;
          
          // Recuperiamo la risposta direttamente dalla lista
          String rispostaCorrente = (risposteDate.length > idx) ? risposteDate[idx] : "";

          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: _buildSezione(
              domandaSingola.testo,
              domandaSingola.opzioni,
              rispostaCorrente,
              (optIdx) => _updatePart(idx, optIdx),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSezione(String titolo, List<String> opzioni, String scelto, Function(int) onTap) {
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
            // Confrontiamo la stringa salvata ("0", "1") con l'indice attuale del bottone
            return _buildOptionBtn(opzioni[i], i.toString() == scelto, () => onTap(i));
          }),
        ),
      ],
    );
  }

  Widget _buildOptionBtn(String testo, bool isSelected, VoidCallback onTap) {
    return SizedBox(
      width: 250,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue[700] : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          side: BorderSide(color: isSelected ? Colors.blue[900]! : Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(testo, textAlign: TextAlign.center),
      ),
    );
  }
}