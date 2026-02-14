import 'package:flutter/material.dart';
import 'package:gioco_demo/class/models/utente.dart';
import 'package:gioco_demo/screens/MapScreen.dart';
import 'package:gioco_demo/widgets/AvatarSelector.dart';
import 'package:gioco_demo/widgets/StartButton.dart';
import 'package:gioco_demo/widgets/codeSelector.dart'; 


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showAvatarSelector = false;
  int? selectedAvatar; // Stato per l'avatar selezionato
  bool showCodeInput = false;
  String userCode = ""; //qui viene salvato il CODICE GIOCATORE


  // LOGICA: Mostra l'overlay quando si preme Start
  void _onStartPressed() {
    setState(() {
      showCodeInput = true;
    });
  }


  // Aggiungi questa funzione dentro _HomeScreenState
  Map<String, String> _getAbitiDefault(int avatarId) {
    if (avatarId == 2) { // Esempio: Femmina
      return {
        'shirts': 'top_white',
        'pants': 'leggins_pink',
        'hair': 'bob_cut',
        'shoes': 'flat_brown',
      };
    } else { // Esempio: Maschio (id 1)
      return {
        'shirts': 'casual_red',
        'pants': 'jeans_blue',
        'hair': 'short_yellow',
        'shoes': 'boots_brown',
      };
    }
  }

  Utente? currentUser; 

  void _onCodeConfirmed(String code) {
    setState(() {
      userCode = code;
      showCodeInput = false;

      if (code == "GIOCATORE1") {
        // Recuperiamo gli abiti corretti per l'avatar 1 (Maschio)
        final abiti = _getAbitiDefault(1); 
        
        currentUser = Utente(
            tipoAvatar: 1,
            PosizioneX: 400,
            PosizioneY: 900,
            Monete: 200,
            Livello_Attuale: 5,
            lookIniziale: abiti,
            inventarioIniziale: abiti.map((k, v) => MapEntry(k, [v])),
        );
        _goToMap();
      } else {
        showAvatarSelector = true;
      }
    });
  }

  void _onConfirmPressed() {
    if (selectedAvatar != null) {
      // Generiamo gli abiti di default in base alla scelta dell'AvatarSelector
      final abiti = _getAbitiDefault(selectedAvatar!); 
      
      setState(() {
        currentUser = Utente(
          tipoAvatar: selectedAvatar!,
          PosizioneX: 400,
          PosizioneY: 900,
          Monete: 50,
          Livello_Attuale: 1,
          lookIniziale: abiti,
          inventarioIniziale: abiti.map((k, v) => MapEntry(k, [v])),
        );
      });
      _goToMap();
    }
  }

  // Funzione di supporto per non ripetere il codice di navigazione
  void _goToMap() {
    if (currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(
            utente: currentUser!, // Passo l'intero oggetto qui
          ),
        ),
      );
    }
  }



  // LOGICA: Gestisce la selezione dell'avatar
  void _onAvatarSelected(int index) {
    setState(() {
      selectedAvatar = index;
    });
  }
  

  void _onBack(){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Sfondo Immobile
          Positioned.fill(
            child: Image.asset(
              '/images/home.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Pulsante Start (Visibile solo se AvatarSelector NON è mostrato)
          if (!showCodeInput && !showAvatarSelector)
            Center(child: StartButton(onPressed: _onStartPressed)),

          // Inserimento Codice
          if (showCodeInput)
            CodeSelector(
              onConfirm: _onCodeConfirmed,
              onBack: () => setState(() => showCodeInput = false),
            ),

          // Overlay di Selezione Avatar (Visibile solo se showAvatarSelector è TRUE)
          if (showAvatarSelector)
            Avatarselector(
              selectedAvatar: selectedAvatar,
              onAvatarSelected: _onAvatarSelected,
              onConfirm: _onConfirmPressed,
              onBack: _onBack,
              // Nota: qui potresti voler aggiungere un pulsante 'Chiudi' per tornare alla Home
            ),
        ],
      ),
    );
  }
}