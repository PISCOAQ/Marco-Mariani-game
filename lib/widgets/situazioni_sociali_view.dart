import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';

class SituazioniSocialiView extends StatelessWidget {
  final SituazioniSociali pagina;
  final List<String> risposteDate; 
  final ValueChanged<List<String>> onChanged;

  const SituazioniSocialiView({
    super.key,
    required this.pagina,
    required this.risposteDate,
    required this.onChanged,
  });

  void _selezionaRisposta(int optIndex) {
    List<String> nuovaLista = List.from(risposteDate);
    // Essendo una pagina con una sola domanda, scriviamo all'indice 0
    if (nuovaLista.isEmpty) {
      nuovaLista.add(optIndex.toString());
    } else {
      nuovaLista[0] = optIndex.toString();
    }
    onChanged(nuovaLista);
  }

  @override
  Widget build(BuildContext context) {
    final domanda = pagina.lista_domande[0];
    // Recuperiamo la risposta salvata (se presente)
    final String rispostaCorrente = risposteDate.isNotEmpty ? risposteDate[0] : "";

    return Column(
      children: [
        const SizedBox(height: 40),
        
        // TESTO COMPOSTO
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
              children: [
                if (pagina.narrazione_before != null)
                  TextSpan(text: "${pagina.narrazione_before} "),
                TextSpan(
                  text: pagina.bold,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                if (pagina.narrazione_after != null)
                  TextSpan(text: " ${pagina.narrazione_after}"),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 50),

        // opzioni di risposta
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: domanda.opzioni.asMap().entries.map((entry) {
            int idx = entry.key;
            String testoOpt = entry.value;

            // Confrontiamo l'indice salvato con l'indice attuale del bottone
            final bool isSelected = rispostaCorrente == idx.toString();

            return _buildOptionBtn(
              testoOpt, 
              isSelected, 
              () => _selezionaRisposta(idx),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionBtn(String testo, bool isSelected, VoidCallback onTap) {
    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue[700] : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          side: BorderSide(color: isSelected ? Colors.blue[900]! : Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onTap,
        child: Text(testo, textAlign: TextAlign.center),
      ),
    );
  }
}