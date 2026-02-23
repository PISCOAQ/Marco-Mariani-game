import 'package:gioco_demo/class/services/db_service.dart';
import '../models/utente.dart';

class UtenteRepository {
  final ApiService _apiService = ApiService();
  final Utente utente;

  UtenteRepository(this.utente);

  /// Metodo interno privato per centralizzare tutte le chiamate PATCH.
  /// Evita di ripetere la logica di gestione errori in ogni metodo.
  void _sync(Map<String, dynamic> dati) {
    _apiService.updateProgressi(utente.codiceGioco, dati)
      .then((_) => print("Sincronizzazione riuscita: $dati"))
      .catchError((e) => print("Errore durante la sincronizzazione: $e"));
  }

  // --- AGGIORNAMENTO LIVELLO ---
  void aggiornaLivello(int nuovoLivello) {
    if (nuovoLivello > utente.Livello_Attuale) {
      utente.Livello_Attuale = nuovoLivello;
      _sync({"Livello_Attuale": nuovoLivello});
    }
  }

  // --- AGGIORNAMENTO MONETE ---
  void aggiungiMonete(int quantita) {
    utente.moneteNotifier.value += quantita;
    _sync({"moneteNotifier": utente.moneteNotifier.value});
  }

  // --- AGGIORNAMENTO POSIZIONE ---
  void salvaPosizione(double x, double y) {
    utente.PosizioneX = x;
    utente.PosizioneY = y;
    _sync({
      "PosizioneX": x,
      "PosizioneY": y,
    });
  }

  // --- AGGIORNAMENTO INVENTARIO ---
  // Aggiunge un oggetto a una categoria specifica (es. categoria: 'shirts', oggetto: 'red_shirt')
  void aggiungiAInventario(String categoria, String nomeOggetto) {
    if (utente.inventario.containsKey(categoria)) {
      if (!utente.inventario[categoria]!.contains(nomeOggetto)) {
        utente.inventario[categoria]!.add(nomeOggetto);
        _sync({"inventario": utente.inventario});
      }
    } else {
      utente.inventario[categoria] = [nomeOggetto];
      _sync({"inventario": utente.inventario});
    }
  }

  // --- AGGIORNAMENTO LOOK (VESTITI) ---
  void aggiornaLook(Map<String, String> nuovoLook) {
    utente.lookAttuale = nuovoLook;
    _sync({"lookAttuale": nuovoLook});
  }
}