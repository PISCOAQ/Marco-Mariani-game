import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gioco_demo/class/models/Quiz_Results.dart';
import 'package:gioco_demo/class/models/utente.dart';
import 'package:gioco_demo/class/services/API_service.dart';
import 'package:gioco_demo/class/services/Activity_loader.dart';
import 'package:gioco_demo/class/models/Attivit%C3%A0.dart';
import 'package:gioco_demo/class/services/Polyglot_service.dart';
import 'package:gioco_demo/game/MyGame.dart';
import 'package:gioco_demo/game/input/virtualJoystick.dart';
import 'package:gioco_demo/widgets/ChestPage.dart';
import 'package:gioco_demo/widgets/End_GameNotification.dart';
import 'package:gioco_demo/widgets/GameNotification.dart';
import 'package:gioco_demo/widgets/Gameloading_screen.dart';
import 'package:gioco_demo/widgets/MoneyWidget.dart';
import 'package:gioco_demo/widgets/PageOverlay.dart';
import 'package:gioco_demo/widgets/infoPopUp.dart';
import 'package:gioco_demo/widgets/levelNotification.dart';
import 'package:gioco_demo/widgets/quizNotification.dart';
import 'package:gioco_demo/widgets/riepilogoNotification.dart';

class MapScreen extends StatefulWidget {
  final Utente utente;
  const MapScreen({super.key, required this.utente});
  

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MyGame _myGame; 
  late final ApiService _apiService;
  bool _isPageActive = false; 
  bool _isChestPage = false;
  String? _messaggioNotifica;
  dynamic _attivitaCaricata;
  bool _isGuideOpen = false;
  bool _mostraSentieri = true;
  bool _isEndGameActive = false;
  int? _levelInCorso;
  final Map<String, int> _tentativiQuiz = {};

  late final PolyglotService _polyglotService;

  bool _isResultPopupActive = false;
  QuizResult? _ultimoRisultato;

  final ValueNotifier<bool> _levelUpNotifier = ValueNotifier<bool>(false);


  // 1. Creiamo il FocusNode dedicato al gioco
  final FocusNode _gameFocusNode = FocusNode();

  double _loadingProgress = 0.0;
  bool _isLoadingVisible = true;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    
    // 1. Inizializziamo il servizio (i parametri sono già preimpostati nella classe)
    _polyglotService = PolyglotService();
    _inizializzaPolyglot();

    _myGame = MyGame(
      utente: widget.utente,
      onShowPopup: _showPopup, 
      onShowChestPopup: _showChestPage,
      onLevelUnlocked: () {
        _levelUpNotifier.value = true;
        Future.delayed(const Duration(seconds: 3), () {   //Durata levelNotification
          _levelUpNotifier.value = false;
        });
      },
      onProgress: (progress) {
        // Questo dice a Flutter: "Appena hai finito di disegnare, esegui questo"
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) { // Controllo di sicurezza: lo schermo è ancora attivo?
            setState(() {
              _loadingProgress = progress;
              if (progress >= 1.0) {
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (mounted) setState(() => _isLoadingVisible = false);
                });
              }
            });
          }
        });
        },
    );  
  }

  void _inizializzaPolyglot() async {
    final percorso = widget.utente.percorsoAttivo;
    if (percorso == null) return;

    String? idDaUsare;

    if (percorso.ctxId == null || percorso.ctxId!.isEmpty) {
      // 1. Chiedo a Polyglot un nuovo ID
      idDaUsare = await _polyglotService.firstCall(percorso.flowId);
      
      if (idDaUsare != null) {
        // 2. LO SALVO NEL DB SUBITO (Usando la tua funzione di ApiService)
        // Assicurati di avere un'istanza di ApiService disponibile (es. _apiService)
        await _apiService.updateCtxId(
          widget.utente.codiceGioco, 
          percorso.flowId, // o l'ID del percorso corretto
          idDaUsare,
        );
        
        // 3. Aggiorno anche l'oggetto in locale così l'app lo "vede" subito
        percorso.ctxId = idDaUsare;
      }
    } else {
      // Caso ripresa: l'ID c'è già nel DB
      idDaUsare = percorso.ctxId;
    }

    // 4. Avvio il quiz con l'ID (nuovo o vecchio)
    if (idDaUsare != null) {
      await _polyglotService.actualCall(idDaUsare);
    }
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

  void _toggleGuide() {
    setState(() {
      _isGuideOpen = !_isGuideOpen;
      _messaggioNotifica = null;
      if (_isGuideOpen) {
        _myGame.pauseEngine();
      } else {
        _myGame.resumeEngine();
        // Ridiamo il focus al gioco dopo la chiusura
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _gameFocusNode.requestFocus();
        });
      }
    });
  }

  void _showPopup(String tipo, int levelId) async {
    //final risultato = await ActivityLoader.carica(); funzione vecchia json in locale

    final jsonGrezzo = _polyglotService.lastRawResponse;

    if (jsonGrezzo == null) {
    _mostraMessaggioAvviso("Dati non ancora pronti o errore di rete.");
    return;
    }

    // Usiamo il tuo loader modificato per accettare la Map
    final risultato = ActivityLoader.fromPolyGloT(jsonGrezzo);

    if (_myGame.utente.percorsoAttivo!.Livello_Attuale > levelId) {
      _mostraMessaggioAvviso("Sfida già completata!");
      return;
    }
    
    if (risultato is Esercitazione && tipo == "quiz") {
        _mostraMessaggioAvviso("Fai l'esercitazione, poi torna qui!");
        return; 
    }
    if (risultato is Quiz && tipo == "esercitazione") {
      _mostraMessaggioAvviso("Esegui il quiz!");
      return;
    }

    if(risultato is Quiz) {
      _myGame.pauseEngine();

      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Quiznotification(
        onCancel: () {
          Navigator.pop(context); // Chiude il dialog
            _myGame.resetInput();// 1. Reset fisico e degli input
            // 2. Facciamo ripartire il motore
            _myGame.resumeEngine();// 2. Facciamo ripartire il motore
            // 3. IMPORTANTISSIMO: Ridiamo il focus alla tastiera
            _gameFocusNode.requestFocus();
        },
        onConfirm: () {
          Navigator.pop(context); // Chiude il dialog
          _effettuaApertura(risultato, levelId); // Apre il quiz vero e proprio
        },
      ),
    );
    }else {
      // Se è Esercitazione, apriamo senza conferma
      _effettuaApertura(risultato, levelId);
    }
  }

  
  void _effettuaApertura(dynamic risultato, int levelId) {
    setState(() {
      _levelInCorso = levelId;
      _messaggioNotifica = null;
      _attivitaCaricata = risultato;
      _isPageActive = true;
      _myGame.pauseEngine();

      //Incrementiamo il tentativo se è un quiz
      if (risultato is Quiz) {
        _tentativiQuiz[risultato.titolo] = (_tentativiQuiz[risultato.titolo] ?? 0) + 1;
      } 
    });
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

  void _closePage(dynamic esito) {
    setState(() {
      _isPageActive = false;
      _myGame.resetInput();
      _myGame.resumeEngine();

      if (esito is QuizResult) {
        _ultimoRisultato = esito;
        _isResultPopupActive = true;
        
        
        // 1. Diamo le monete (Logica esistente)
        _myGame.repository.aggiungiMonete(esito.moneteGuadagnate);

        // 2. Se il quiz è superato, sblocchiamo il livello sulla mappa
        if(esito.isQuizFinale != true){
          if (esito.superato && _levelInCorso != null) {
            int livelloDaSbloccare = _levelInCorso! + 1;
            _myGame.repository.aggiornaLivello(livelloDaSbloccare);
            _myGame.unlockLevel(livelloDaSbloccare.toString());
          }

          // Facciamo l'actualCall qui, così quando l'utente clicca sul prossimo livello, i dati nel Service sono già quelli nuovi.
          final ctxId = widget.utente.percorsoAttivo!.ctxId;
          if (ctxId != null) {
            _polyglotService.actualCall(ctxId).then((_) {
            });
          }
        }else{
          setState(() {
            _isEndGameActive = true;
            _myGame.pauseEngine();
            _apiService.updateStatoPercorso(
              widget.utente.codiceGioco, 
              _myGame.utente.percorsoAttivo!.flowId, 
              true
            );
            
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gameFocusNode.requestFocus();
    });
    _levelInCorso = null;
  }


  void _handleResultContinue() {
    setState(() {
      _isResultPopupActive = false;
      _ultimoRisultato = null;
    });
  }

  @override
Widget build(BuildContext context) {

  bool isTouchDevice = MediaQuery.of(context).size.shortestSide < 600;

  return Scaffold(
    body: Stack(
      children: [
        // 1. IL GIOCO (Sotto a tutto)
        GameWidget(
          game: _myGame,
          focusNode: _gameFocusNode,
          autofocus: true,
          overlayBuilderMap: {
            'LevelUp': (context, MyGame game) => LevelNotification(game: game),
          },
        ),

        if (isTouchDevice)
          Positioned(
            bottom: 30,
            right: 30,
            child: VirtualJoystick(
              onDirectionChanged: (dir) {
                _myGame.player.touchDirection = dir;
              },
            ),
          ),

        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min, // La riga occupa solo lo spazio necessario
              crossAxisAlignment: CrossAxisAlignment.center, // Allineamento verticale perfetto
              children: [
                // PRIMA IL PULSANTE GUIDA
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _toggleGuide,
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 45,
                      // Togliamo width: 45 per permettere al tasto di allargarsi in base al testo
                      padding: const EdgeInsets.symmetric(horizontal: 16), // Spazio interno laterale
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        // Cambiamo da BoxShape.circle a una forma rettangolare arrotondata
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Il contenitore stringe intorno al contenuto
                        children: [
                          Icon(
                            Icons.help_outline, 
                            color: Colors.white, 
                            size: 20
                          ),
                          SizedBox(width: 8), // Spazio tra icona e scritta
                          Text(
                            'AIUTO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5, // Un tocco di stile gaming
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12), // Spazio preciso tra pulsante e monete

                // POI IL WIDGET MONETE
                if (!_isLoadingVisible) 
                  Moneywidget(walletNotifier: _myGame.utente.moneteNotifier),
              ],
            ),
          ),
        ),

        if (_isGuideOpen)
          InfoPopup(
            sentieriAttivi: _mostraSentieri,
            onToggleSentieri: (nuovoStato) {
              setState(() {
                _mostraSentieri = nuovoStato;
              });
              // Comunichiamo al gioco di aggiornare la visibilità dei layer
              _myGame.aggiornaPercorsi(_myGame.utente.percorsoAttivo!.Livello_Attuale, mostrare: nuovoStato);
            },
            onExit: _toggleGuide,
          ), 

        // 3. Notifiche di sistema
        if (_messaggioNotifica != null)
          GameNotification(
            key: UniqueKey(),
            messaggio: _messaggioNotifica!,
          ),

        // 4. Overlay della Pagina Quiz/Esercitazione
        if (_isPageActive)
          PageOverlay(
            onExit: _closePage,
            attivita: _attivitaCaricata,
            tentativoAttuale: _tentativiQuiz[_attivitaCaricata.titolo] ?? 1,
            polyglotService: _polyglotService,
            codiceGioco: widget.utente.codiceGioco,
          ),
        
        if (_isResultPopupActive && _ultimoRisultato != null && _isEndGameActive != true)
          Container(
            color: Colors.black45, // Oscuriamo leggermente lo sfondo per focalizzare l'attenzione
            child: RiepilogoNotification(
              superato: _ultimoRisultato!.superato,
              monete: _ultimoRisultato!.moneteGuadagnate,
              onContinue: _handleResultContinue,
            ),
          ),

        // 5. Pagina dello Scrigno
        if (_isChestPage)
          ChestPage(
            game: _myGame,
            onExit: _CloseChestPage,
          ),
        

        if (_isEndGameActive)
        Container(
          color: Colors.black45,
          child: EndGamenotification(
            game: _myGame,
            onClose: () {
              _myGame.detach(); 

              // 2. Torniamo alla Home rimuovendo tutte le rotte precedenti
              // Sostituisci '/' con il nome della tua rotta home o con il widget della Home
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/', // La rotta definita nel MaterialApp
                (route) => false, // Questo rimuove TUTTE le pagine dallo stack
              );
            },
          ),
        ),

        // 6. L'ANIMAZIONE DI LIVELLO (DEVE ESSERE L'ULTIMA PER STARE SOPRA)
        ValueListenableBuilder<bool>(
          valueListenable: _levelUpNotifier,
          builder: (context, visible, child) {
            if (!visible) return const SizedBox.shrink();
            
            // Usiamo IgnorePointer così se l'utente clicca mentre c'è l'animazione, 
            // il click passa al quiz o al gioco sottostante
            return IgnorePointer(
              child: LevelNotification(game: _myGame),
            );
          },
        ),



        // 7. SCHERMATA DI CARICAMENTO (Sopra a tutto finché non finisce)
        IgnorePointer(
          ignoring: !_isLoadingVisible, // Lascia passare i click quando sparisce
          child: AnimatedOpacity(
            opacity: _isLoadingVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000), // Dissolvenza fluida
            curve: Curves.easeOut,
            child: GameLoadingScreen(progress: _loadingProgress),
          ),
        ),
      ],
    ),
  );
}
  
  
}