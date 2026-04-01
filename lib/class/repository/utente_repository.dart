import 'package:gioco_demo/class/services/API_service.dart';
import '../models/utente.dart';
class UtenteRepository {
  final ApiService _apiService = ApiService();
  final Utente utente;

  UtenteRepository(this.utente);

  void _sync(Map<String, dynamic> dati) {
    // MODIFICA CRUCIALE: Aggiungiamo sempre il percorsoId al body
    // altrimenti il backend non trova l'utente e dà 404
    final Map<String, dynamic> bodyConPercorso = Map.from(dati);
    
    if (utente.percorsoAttivo != null) {
      bodyConPercorso["percorsoId"] = utente.percorsoAttivo!.flowId;
    }

    _apiService.updateProgressi(utente.codiceGioco, bodyConPercorso)
      .then((_) => print("Sincronizzazione riuscita: $bodyConPercorso"))
      .catchError((e) => print("Errore durante la sincronizzazione: $e"));
  }

  // --- AGGIORNAMENTO LIVELLO ---
  void aggiornaLivello(int nuovoLivello) {
    if (utente.percorsoAttivo == null) return;
    if (nuovoLivello > utente.percorsoAttivo!.Livello_Attuale) {
      utente.percorsoAttivo!.Livello_Attuale = nuovoLivello;
      
      // Inviamo i dati piatti come vuole il nuovo backend
      _sync({
        "Livello_Attuale": nuovoLivello,
      });
    }
  }

  // --- AGGIORNAMENTO MONETE ---
  void aggiungiMonete(int quantita) {
    // Usiamo .value perché il tuo modello usa ValueNotifier
    utente.moneteNotifier.value += quantita; 
    _sync({"moneteNotifier": utente.moneteNotifier.value});
  }

  // --- AGGIORNAMENTO INVENTARIO ---
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

  // --- AGGIORNAMENTO LOOK ---
  void aggiornaLook(Map<String, String> nuovoLook) {
    utente.lookAttuale = nuovoLook;
    _sync({"lookAttuale": nuovoLook});
  }
}