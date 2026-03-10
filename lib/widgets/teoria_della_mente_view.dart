import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/models/Domanda.dart';

class TeoriaMenteView extends StatelessWidget {
  final TeoriaDellaMente pagina;
  final List<String> risposteDate;
  final ValueChanged<List<String>> onChanged;

  const TeoriaMenteView({
    super.key,
    required this.pagina,
    required this.risposteDate,
    required this.onChanged,
  });

  void _updatePart(int index, String newValue) {
      List<String> nuovaLista = List.from(risposteDate);
      
      // Safety check: allunghiamo se necessario
      while (nuovaLista.length <= index) {
        nuovaLista.add("");
      }
      
      nuovaLista[index] = newValue;
      onChanged(nuovaLista);
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),

        // 1. SCENARIO
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            pagina.narrazione,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(height: 30),


        // 2. CICLO DINAMICO SULLE DOMANDE
        ...pagina.lista_domande.asMap().entries.map((entry) {
          int idx = entry.key;
          Domanda domandaSingola = entry.value;

          // Recuperiamo la risposta direttamente dall'indice della lista
          String rispostaCorrente = risposteDate.length > idx ? risposteDate[idx] : "";

          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: _buildSezione(
              domandaSingola.testo,
              domandaSingola.opzioni.isEmpty 
                ? _buildCampoAperto(idx, rispostaCorrente) // Se non ha opzioni, è aperta
                : _buildOpzioniChiuse(idx, domandaSingola.opzioni, rispostaCorrente),
            ),
          );
        }).toList(),
      ],
    );
  }

  // Widget per le domande a scelta multipla
Widget _buildOpzioniChiuse(int idx, List<String> opzioni, String selezionata) {
  // 1. Troviamo la lunghezza della parola più lunga in questa lista
  int maxLen = opzioni.fold(0, (max, e) => e.length > max ? e.length : max);

  // 2. Determiniamo la larghezza in base al contenuto:
  // Se le risposte sono brevi (tipo SI/NO), usiamo 140, altrimenti 220
  double btnWidth = maxLen <= 3 ? 140 : 220;
  // Anche l'altezza può essere leggermente ridotta per i SI/NO (es. 65 invece di 80)
  double btnHeight = maxLen <= 3 ? 65 : 80;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: opzioni.asMap().entries.map((entry) {
        int optIdx = entry.key;
        String optTesto = entry.value;
        return _buildBtn(
          optTesto, 
          selezionata == optIdx.toString(), 
          () => _updatePart(idx, optIdx.toString()),
          width: btnWidth,   // Passiamo la larghezza calcolata
          height: btnHeight, // Passiamo l'altezza calcolata
        );
      }).toList(),
    ),
  );
}

  // Widget per le domande a risposta aperta
  Widget _buildCampoAperto(int idx, String testo) {
    return SizedBox(
      width: 500,
      child: TextField(
        key: ValueKey("${pagina.narrazione}_$idx"),
        textAlign: TextAlign.center,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: testo,
            selection: TextSelection.collapsed(offset: testo.length),
          ),
        ),
        decoration: InputDecoration(
          hintText: "Scrivi qui...",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (val) => _updatePart(idx, val),
      ),
    );
  }

  Widget _buildSezione(String titolo, Widget child) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            titolo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

Widget _buildBtn(String testo, bool selected, VoidCallback onTap, {double width = 220, double height = 80}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      fixedSize: Size(width, height), // Ora le dimensioni sono dinamiche
      backgroundColor: selected ? Colors.blue[700] : Colors.white,
      foregroundColor: selected ? Colors.white : Colors.black87,
      elevation: selected ? 4 : 1,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      side: BorderSide(
        color: selected ? Colors.blue[900]! : Colors.grey[300]!,
        width: 2,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    onPressed: onTap,
    child: Text(
      testo.toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: width < 150 ? 16 : 14, // Se il tasto è piccolo, il font può essere un filo più grande
        height: 1.1,
      ),
    ),
  );
}
}