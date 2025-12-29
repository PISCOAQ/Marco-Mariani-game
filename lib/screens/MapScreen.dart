import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gioco_demo/class/services/Activity_loader.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/game/MyGame.dart';
import 'package:gioco_demo/widgets/ChestPage.dart';
import 'package:gioco_demo/widgets/GameNotification.dart';
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
  String? _messaggioNotifica;

  dynamic _attivitaCaricata;

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
      _messaggioNotifica = null;
      _isChestPage = true;
      _myGame.pauseEngine();
    });
  }


  void _showPopup(String tipo) async {
    final risultato = await ActivityLoader.carica();

    if (risultato == null) return;

    // 1. CASO ESERCITAZIONE: Se il JSON mi dà un'esercitazione
    if (risultato is Esercitazione) {
      if (tipo == 'quiz') {
        _mostraMessaggioAvviso("Vai a fare l'esercitazione, poi torna qui!");
        return; 
      } else {
        setState(() {
          _messaggioNotifica = null; //pulizia messaggi
          _attivitaCaricata = risultato;
          _isPageActive = true;
          _myGame.pauseEngine();
        });
        return; 
      }
    }

    // 2. CASO QUIZ: Se il JSON mi dà un quiz
    if (risultato is Quiz) {
      if (tipo == 'esercitazione') {
        _mostraMessaggioAvviso("Vai a fare il quiz!");
        return; // Blocca tutto qui
      } else {
        // Sono sull'oggetto giusto (prof), apro il quiz
        setState(() {
          _messaggioNotifica = null;
          _attivitaCaricata = risultato;
          _isPageActive = true;
          _myGame.pauseEngine();
        });
        return; // Esco dalla funzione
      }
    }
  }

  void _mostraMessaggioAvviso(String testo) {
    setState(() {
      _messaggioNotifica = testo;
    });
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
      _myGame.resumeEngine(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( //Stack per sovrapporre il popup al gioco
        children: [
          GameWidget(game: _myGame),

          if (_messaggioNotifica != null)
          GameNotification(
            key: UniqueKey(), // Serve a far ripartire il timer se mandi due messaggi di fila
            messaggio: _messaggioNotifica!,
          ),

          Moneywidget(walletNotifier: _myGame.playerState.coins),

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