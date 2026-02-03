import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class EyesTaskView extends StatelessWidget {
  final EyesTask pagina; // Usiamo la classe specifica EyesTask
  final String? rispostaUtente;
  final ValueChanged<String> onChanged;

  const EyesTaskView({
    super.key,
    required this.pagina,
    required this.rispostaUtente,
    required this.onChanged,
  });

  @override
@override
Widget build(BuildContext context) {
  final Domanda domanda = pagina.lista_domande[0];

  return Column(
    children: [
      const SizedBox(height: 40),
      
      // L'immagine (che caricherà il placeholder se il path è "")
      _buildImmagine(pagina.imagePath),

      const SizedBox(height: 30),

      // Il testo della domanda (quello che abbiamo impostato di default nel loader)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          domanda.testo,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),

      const SizedBox(height: 30),

      // LE RISPOSTE (Bottoni invece di TextField)
      Wrap(
        spacing: 15,
        runSpacing: 15,
        alignment: WrapAlignment.center,
        children: domanda.opzioni.map((opt) {
          final bool isSelected = rispostaUtente == opt;
          return _buildOptionBtn(opt, isSelected, () => onChanged(opt));
        }).toList(),
      ),
    ],
  );
}
  // Widget helper per l'immagine
  Widget _buildImmagine(String path) {
    return Container(
      width: 450, // Leggermente più grande per vedere bene i dettagli
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[400]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: path.contains("placeholder") || path.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.visibility, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Immagine non disponibile", style: TextStyle(color: Colors.grey)),
                ],
              )
            : Image.asset(
                path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text("Errore caricamento immagine"));
                },
              ),
      ),
    );
  }
}


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