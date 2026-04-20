import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';

class SituazioniSocialiView extends StatelessWidget {
  final SituazioniSociali pagina;
  final List<String> risposteDate; // Qui avremo es: ["0", "1"] se ci sono due sezioni
  final ValueChanged<List<String>> onChanged;

  const SituazioniSocialiView({
    super.key,
    required this.pagina,
    required this.risposteDate,
    required this.onChanged,
  });

  void _selezionaRisposta(int sezioneIndex, int optIndex) {
    List<String> nuovaLista = List.from(risposteDate);
    // Assicuriamoci che la lista sia lunga quanto le domande
    while (nuovaLista.length < pagina.lista_domande.length) {
      nuovaLista.add("");
    }
    nuovaLista[sezioneIndex] = optIndex.toString();
    onChanged(nuovaLista);
  }

@override
Widget build(BuildContext context) {
  return Column(
    // Centriamo tutto il contenuto della colonna
    crossAxisAlignment: CrossAxisAlignment.center, 
    children: pagina.sezioni.asMap().entries.map((entry) {
      int sIdx = entry.key;
      SezioneSociale sezione = entry.value;
      String rispostaCorrente = risposteDate.length > sIdx ? risposteDate[sIdx] : "";

      return Padding(
        padding: const EdgeInsets.only(bottom: 60.0), 
        child: Column(
          children: [

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200), // Regola questo valore per la larghezza desiderata
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 18, color: Colors.black87, height: 1.6),
                    children: [
                      // Usiamo .replaceAll('\n', ' ') per ignorare gli invii del database
                      if (sezione.before != null) 
                        TextSpan(text: "${sezione.before!.replaceAll('\n', ' ').trim()} "),
                      TextSpan(
                        text: sezione.bold.replaceAll('\n', ' ').trim(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                      if (sezione.after != null) 
                        TextSpan(text: " ${sezione.after!.replaceAll('\n', ' ').trim()}"),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- BOTTONI ---
            Wrap(
              spacing: 15,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: sezione.domanda.opzioni.asMap().entries.map((optEntry) {
                int oIdx = optEntry.key;
                bool isSelected = rispostaCorrente == oIdx.toString();
                return _buildOptionBtn(optEntry.value, isSelected, () => _selezionaRisposta(sIdx, oIdx));
              }).toList(),
            ),
          ],
        ),
      );
    }).toList(),
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