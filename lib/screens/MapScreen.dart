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

  // 1. Creiamo il FocusNode dedicato al gioco
  final FocusNode _gameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _myGame = MyGame(
      avatarIndex: widget.avatarIndex,
      onShowPopup: _showPopup, 
      onShowChestPopup: _showChestPage,
    );
  }

  @override
  void dispose() {
    // 2. Liberiamo la memoria
    _gameFocusNode.dispose();
    super.dispose();
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

    if (risultato is Esercitazione) {
      if (tipo == 'quiz') {
        _mostraMessaggioAvviso("Fai l'esercitazione, poi torna qui!");
        return; 
      } else {
        setState(() {
          _messaggioNotifica = null;
          _attivitaCaricata = risultato;
          _isPageActive = true;
          _myGame.pauseEngine();
        });
        return; 
      }
    }

    if (risultato is Quiz) {
      if (tipo == 'esercitazione') {
        _mostraMessaggioAvviso("Esegui il quiz!");
        return;
      } else {
        setState(() {
          _messaggioNotifica = null;
          _attivitaCaricata = risultato;
          _isPageActive = true;
          _myGame.pauseEngine();
        });
        return;
      }
    }
  }

  void _mostraMessaggioAvviso(String testo) {
    setState(() {
      _messaggioNotifica = testo;
    });
  }

  // 3. Funzioni di chiusura: riprendiamo il focus
  void _CloseChestPage(){
    setState(() {
      _isChestPage = false;
      _myGame.resumeEngine();
    });
    _gameFocusNode.requestFocus(); // Torna al gioco
  }

  void _closePage() {
    setState(() {
      _isPageActive = false;
      _myGame.resumeEngine(); 
    });
    
    // Usiamo addPostFrameCallback per essere sicuri che la UI sia chiusa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gameFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 4. GameWidget con focusNode assegnato
          GameWidget(
            game: _myGame,
            focusNode: _gameFocusNode,
            autofocus: true, 
          ),

          if (_messaggioNotifica != null)
            GameNotification(
              key: UniqueKey(),
              messaggio: _messaggioNotifica!,
            ),

          Moneywidget(walletNotifier: _myGame.playerState.coins),

          if (_isPageActive)
            PageOverlay( 
              onExit: _closePage,
              attivita: _attivitaCaricata, 
            ),

          if (_isChestPage)
            ChestPage(
              game: _myGame,
              onExit: _CloseChestPage,
            ),
        ],
      ),
    );
  }
}