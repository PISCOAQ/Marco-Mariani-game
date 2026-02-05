import 'package:flutter/material.dart';
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

  void _onCodeConfirmed(String code) {
    setState(() {
      userCode = code;
      showCodeInput = false;
      showAvatarSelector = true; 
    });
  }

  // LOGICA: Gestisce la selezione dell'avatar
  void _onAvatarSelected(int index) {
    setState(() {
      selectedAvatar = index;
    });
  }
  
  // LOGICA: Conferma e naviga al gioco
  void _onConfirmPressed() {
    if (selectedAvatar != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(
            avatarIndex: selectedAvatar!,
          ),
        ),
      );
    }
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