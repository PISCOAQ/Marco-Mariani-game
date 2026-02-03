import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class EyesTaskView extends StatelessWidget {
  final EyesTask pagina;
  // 1. Passiamo la lista delle risposte
  final List<String> risposteDate; 
  final ValueChanged<List<String>> onChanged;

  const EyesTaskView({
    super.key,
    required this.pagina,
    required this.risposteDate,
    required this.onChanged,
  });

  // Helper per aggiornare la risposta (indice 0 perché EyesTask ha una domanda per pagina)
  void _selezionaRisposta(int optIndex) {
    List<String> nuovaLista = List.from(risposteDate);
    if (nuovaLista.isEmpty) {
      nuovaLista.add(optIndex.toString());
    } else {
      nuovaLista[0] = optIndex.toString();
    }
    onChanged(nuovaLista);
  }

  @override
  Widget build(BuildContext context) {
    final Domanda domanda = pagina.lista_domande[0];
    // La risposta salvata per questa domanda (indice 0)
    final String rispostaCorrente = risposteDate.isNotEmpty ? risposteDate[0] : "";

    return Column(
      children: [
        const SizedBox(height: 40),
        
        _buildImmagine(pagina.imagePath),

        const SizedBox(height: 30),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            domanda.testo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),

        const SizedBox(height: 30),

        // LE RISPOSTE
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: domanda.opzioni.asMap().entries.map((entry) {
            int idx = entry.key;
            String testoOpzione = entry.value;

            // Il confronto ora avviene sull'indice (trasformato in stringa)
            final bool isSelected = rispostaCorrente == idx.toString();
            
            return _buildOptionBtn(testoOpzione, isSelected, () => _selezionaRisposta(idx));
          }).toList(),
        ),
      ],
    );
  }

  // --- I widget helper _buildImmagine e _buildOptionBtn rimangono quasi identici ---
  // Unica nota: _buildOptionBtn e _buildImmagine vanno messi dentro la classe o come metodi privati.
  
  Widget _buildImmagine(String path) {
    return Container(
      width: 450,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: path.isEmpty || path.contains("placeholder")
            ? const Center(child: Icon(Icons.visibility, size: 50, color: Colors.grey))
            : Image.asset(path, fit: BoxFit.cover),
      ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: isSelected ? Colors.blue[900]! : Colors.grey[300]!),
        ),
        onPressed: onTap,
        child: Text(testo, textAlign: TextAlign.center),
      ),
    );
  }
}