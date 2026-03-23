import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Se testi su PC/Web: localhost. Se testi su emulatore Android: 10.0.2.2
  static const String baseUrl = "http://localhost:3000";

  Future<Map<String, dynamic>> getDatiUtente(String codiceGioco) async {
    
    final url = Uri.parse('$baseUrl/utente/$codiceGioco');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Verifichiamo che i dati fondamentali ci siano
        if (data == null) throw Exception('Risposta vuota dal server');
        
        return data; 
      } else if (response.statusCode == 404) {
        throw Exception('Codice gioco non trovato');
      } else {
        throw Exception('Errore server: ${response.statusCode}');
      }
    } catch (e) {
      print("Errore API Service: $e");
      rethrow;
    }
  }

  // Metodo per salvare i progressi quando il bambino gioca
  Future<void> updateProgressi(String codiceGioco, Map<String, dynamic> progressi) async {
    final url = Uri.parse('$baseUrl/utenti/$codiceGioco/progressi');
    
    try {
      await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(progressi),
      );
    } catch (e) {
      print("Errore salvataggio: $e");
    }
  }
}