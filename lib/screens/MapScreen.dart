import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gioco_demo/class/services/Activity_loader.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/game/MyGame.dart';
import 'package:gioco_demo/widgets/ChestPage.dart';
import 'package:gioco_demo/widgets/MoneyWidget.dart';
import 'package:gioco_demo/widgets/PageOverlay.dart';

class MapScreen extends StatefulWidget {
  final int avatarIndex;

  const MapScreen({super.key, required this.avatarIndex});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MyGame _myGame; 
  bool _isPageActive = false; 
  bool _isChestPage = false;

  dynamic _attivitaCaricata;

  //Variabile delle monete
  final ValueNotifier<int> wallet = ValueNotifier<int>(500);

  @override
  void initState() {
    super.initState();
    _myGame = MyGame(
      avatarIndex: widget.avatarIndex,
      onShowPopup: _showPopup, 
      onShowChestPopup: _showChestPage,
    );
  }

  void _showChestPage(){
    setState(() {
      _isChestPage = true;
      _myGame.pauseEngine();
    });
  }
/* metodo precedente che non gestisce esercitazioni
void _showPopup() async {  
  // Mettiamo subito in pausa e attiviamo l'overlay
  setState(() {
    _isPageActive = true;
    _myGame.pauseEngine();
  });

  // Carichiamo i dati "nel mentre"
    final risultato = await ActivityLoader.carica();
    setState(() {
      _attivitaCaricata = risultato;
    });
}*/


// tipoRichiesto sarà 'quiz' oppure 'esercitazione' a seconda dell'oggetto toccato
void _showPopup() async {
  final risultato = await ActivityLoader.carica();
  print("DEBUG $risultato");
  if (risultato == null){
    print("DEBUG: caricamento fallito");
    return;
  } 

  // Se il loader carica un'esercitazione, mostriamo il messaggio e NON apriamo la pagina
  if (risultato is Esercitazione) {
    _mostraMessaggioAvviso("Vai ad esercitarti prima!");
    return; 
  }

  setState(() {
    _attivitaCaricata = risultato;
    _isPageActive = true;
    _myGame.pauseEngine();
  });
}

void _mostraMessaggioAvviso(String testo) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  // Calcoliamo il margine laterale per farla larga circa 250 pixel
  // (Larghezza Schermo - Larghezza Desiderata) / 2
  final double sideMargin = (screenWidth - 250) / 2;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            testo,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange[900],
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      margin: EdgeInsets.only(
        bottom: screenHeight - 75, // Spinge in alto
        left: sideMargin,           // Stringe da sinistra
        right: sideMargin,          // Stringe da destra
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

  void _CloseChestPage(){
    setState(() {
      _isChestPage = false;
      _myGame.resumeEngine();
    });
  }

  // Funzione chiamata dal pulsante 'X' del popup per chiuderlo
  void _closePage() {
    setState(() {
      _isPageActive = false;
      // Riprendi il gioco per permettere all'avatar di muoversi
      _myGame.resumeEngine(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( //Stack per sovrapporre il popup al gioco
        children: [
          GameWidget(game: _myGame),

          Moneywidget(walletNotifier: wallet),

          //Il Widget Overlay (visibile solo se _isQuizActive è true)
          if (_isPageActive)
            PageOverlay( 
              onExit: _closePage,
              // Passiamo l'oggetto caricato così PageOverlay sa cosa mostrare
              attivita: _attivitaCaricata, 
            ),

          if (_isChestPage)
          ChestPage( // Un widget diverso o lo stesso con dati diversi
            game: _myGame,
            onExit: _CloseChestPage,
          ),
        ],
      ),
    );
  }
}