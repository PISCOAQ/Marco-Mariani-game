import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class AttribuzioneEmozioniView extends StatelessWidget {
  final AttribuzioneEmozioni pagina;
  final List<String> risposteDate;
  final ValueChanged<List<String>> onChanged;

  const AttribuzioneEmozioniView({
    super.key,
    required this.pagina,
    required this.risposteDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    final Domanda domanda = pagina.lista_domande[0];

    // Recuperiamo la risposta specifica per questa domanda (indice 0)
    // Se la lista è vuota o l'indice non esiste (non dovrebbe accadere), usiamo stringa vuota
    final String testoRisposta = risposteDate.isNotEmpty ? risposteDate[0] : "";

    return SizedBox(
      // Forza la larghezza massima per permettere al Column interno di centrare
      width: double.infinity, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // DISTACCO DAL BORDO SUPERIORE (Immagine 2)
          const SizedBox(height: 100),

          // TESTO SCENARIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              pagina.narrazione,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // TESTO DOMANDA (Question)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              domanda.testo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),

          // SPAZIO PRIMA DELLA BARRA (Per centrarla verticalmente o quasi)
          const SizedBox(height: 150),

          // BARRA DI SCRITTURA (Larghezza 500)
          SizedBox(
            width: 500,
            child: TextField(
              key: ValueKey(domanda.testo),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: testoRisposta ?? "",
                  selection: TextSelection.collapsed(offset: testoRisposta.length),
                ),
              ),
              decoration: InputDecoration(
                hintText: "Scrivi l'emozione",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
              
              // 3. Quando il testo cambia, aggiorniamo solo il primo elemento della lista
              onChanged: (nuovoTesto) {
                List<String> aggiornata = List.from(risposteDate);
                if (aggiornata.isEmpty) {
                  aggiornata.add(nuovoTesto);
                } else {
                  aggiornata[0] = nuovoTesto;
                }
                onChanged(aggiornata);
              },
            ),
          ),

          const SizedBox(height: 15),

          Text(
            "Una parola è sufficiente",
            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}