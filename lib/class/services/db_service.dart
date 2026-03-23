import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  
  // Questa funzione (getter) restituisce l'URL di base pulito.
  static String get baseUrl {
    // Recupera l'URL dal file .env o usa localhost come fallback
    String url = dotenv.env['API_URL'] ?? "http://localhost:3000";

    /* * NOTA DI CORREZIONE (DEPLOY ONLINE): 
     * Il sistema di deploy aggiunge automaticamente '/api' alla fine dell'URL, 
     * ma il server Node.js di Davide non è configurato per gestire il prefisso '/api' 
     * sulla rotta degli utenti. Questo controllo rimuove il suffisso '/api' se presente,
     * evitando l'errore 404 senza dover modificare il backend.
     */
    if (url.endsWith('/api')) {
      return url.substring(0, url.length - 4);
    }
    
    return url;
  }

  Future<Map<String, dynamic>> getDatiUtente(String codiceGioco) async {
    // baseUrl ora richiama automaticamente la logica di pulizia sopra
    final url = Uri.parse('$baseUrl/utente/$codiceGioco');
    
    try {
      print("Chiamata API (GET): $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null) throw Exception('Risposta vuota dal server');
        return data; 
      } else if (response.statusCode == 404) {
        throw Exception('Codice gioco non trovato');
      } else {
        throw Exception('Errore server: ${response.statusCode}');
      }
    } catch (e) {
      print("Errore API Service (Get): $e");
      rethrow;
    }
  }

  // Metodo per salvare i progressi
  Future<void> updateProgressi(String codiceGioco, Map<String, dynamic> progressi) async {
    // Anche qui l'URL sarà pulito automaticamente
    final url = Uri.parse('$baseUrl/utenti/$codiceGioco/progressi');
    
    try {
      print("Chiamata API (PATCH): $url");
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(progressi),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        print("Errore salvataggio: Status ${response.statusCode}");
      }
    } catch (e) {
      print("Errore salvataggio: $e");
    }
  }
}