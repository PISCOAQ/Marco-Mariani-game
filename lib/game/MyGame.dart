import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gioco_demo/class/models/Levelmanager.dart';
import 'package:gioco_demo/class/models/PlayerState.dart';
import 'package:gioco_demo/class/models/SensorLevel.dart';
import 'package:gioco_demo/class/models/gateComponent.dart';
import 'package:gioco_demo/game/chest.dart';
import 'package:gioco_demo/game/components/Interactive_object.dart';
import 'player.dart';
import 'wall.dart';
import 'package:tiled/tiled.dart' as tiled;

// Definizione callback
typedef ShowActivityCallback = void Function(String tipo);
typedef ShowChestCallback = void Function();
typedef LevelUnlockedCallback = void Function();
typedef ProgressCallback = void Function(double progress);


class MyGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late final PlayerState playerState = PlayerState();
  late TiledComponent mapComponent;

  final int avatarIndex;
  final ShowActivityCallback onShowPopup;
  final ShowChestCallback onShowChestPopup;

  final LevelUnlockedCallback onLevelUnlocked;

  final List<GateComponent> _activeGates = [];

  final ProgressCallback onProgress;

  MyGame({
    required this.avatarIndex,
    required this.onShowPopup,
    required this.onShowChestPopup,
    required this.onLevelUnlocked,
    required this.onProgress
  });

@override
Future<void> onLoad() async {
  onProgress(0.1);
  await super.onLoad();
  /*
    // 1️. MAPPA
    mapComponent = await TiledComponent.load(
      'game_map_Copia.tmx', 
      Vector2.all(32),
    )..priority = 1;
    world.add(mapComponent);
  */

  // 1. Carica la mappa BASE (Terreno e Livello 3)
  mapComponent = await TiledComponent.load('game_map_Copia.tmx', Vector2.all(32));
  mapComponent.priority = 0; // Sta sul fondo
  world.add(mapComponent);
  onProgress(0.4);
  

  // 2. Carica la mappa PONTE (Solo il Livello 2)
  // Carichiamo lo stesso file, ma lo mettiamo in un altro componente
  final ponteComponent = await TiledComponent.load('game_map_Copia.tmx', Vector2.all(32));
  ponteComponent.priority = 15; // Il ponte sta "a metà" altezza
  world.add(ponteComponent);
  onProgress(0.5);

  // 3. LOGICA DEI FILTRI:
  // Nella mappa base, nascondiamo il ponte
  mapComponent.tileMap.getLayer<tiled.Layer>('livello_2')?.visible = false;
  onProgress(0.6);

  // Nella mappa ponte, nascondiamo TUTTO tranne il ponte
  for (var layer in ponteComponent.tileMap.renderableLayers) {
    if (layer.layer.name != 'livello_2') {
      layer.layer.visible = false;
    }
  }

  // 2. COLLISIONI (Muri)
  // Cerchiamo tutti i layer chiamati 'collisioni' ovunque siano
  for (final obj in _getObjects('collisioni')) {
    world.add(Wall(
      Vector2(obj.x, obj.y),
      Vector2(obj.width, obj.height),
    ));
  }

  // 3. OGGETTI INTERATTIVI (Interactions)
  for (final object in _getObjects('interactions')) {
    if (object.type == 'trigger_quiz') {
      world.add(InteractiveObject(
        object.x, object.y, object.width, object.height,
        () {
          onShowPopup('quiz');
          unlockLevel('2'); 
        },
        spritePath: 'quiz.png',
      )..priority = 30);
    } else if (object.type == 'trigger_esercitazione') {
      world.add(InteractiveObject(
        object.x, object.y, object.width, object.height,
        () => onShowPopup('esercitazione'),
        spritePath: 'training.png',
      )..priority = 30);
    } else if (object.type == 'chest') {
      world.add(Chest(
        position: Vector2(object.x, object.y),
        size: Vector2(object.width, object.height),
        onOpen: onShowChestPopup,
      ));
    }
  }
  onProgress(0.8);


  // 4. CANCELLI (LevelBarriers)
  // Questi possono stare sia fuori che dentro i gruppi ora
  for (final obj in _getObjects('LevelBarriers')) {
    final String levelId = obj.properties.getValue('valore')?.toString() ?? 'unknown';
    final gate = GateComponent(
      position: Vector2(obj.x, obj.y),
      size: Vector2(obj.width, obj.height),
      gateId: levelId,
    );
    _activeGates.add(gate);
    world.add(gate);
  }

  // 5️. PLAYER
  playerState.addClothesDefault('shirts', 'red');
  playerState.addClothesDefault('pants', 'blue');
  playerState.addClothesDefault('hair', 'black');
  playerState.addClothesDefault('shoes', 'brown');

  player = Player(
    avatarIndex: avatarIndex,
    position: Vector2(400, 900), 
    playerState: playerState,
  );
  world.add(player);
    onProgress(0.9);


  // 5b. CARICAMENTO SENSORI DI LIVELLO
  for (final obj in _getObjects('CurrentLevel')) {
    final int? piano = obj.properties.getValue<int>('current_level');
    if (piano != null) {
      world.add(FloorSensor(
        position: Vector2(obj.x, obj.y),
        size: Vector2(obj.width, obj.height),
        floorValue: piano,
      ));
    }
  }

  // 6. CAMERA
  camera.viewfinder.zoom = 2.0;
  camera.follow(player);

  await Future.delayed(const Duration(milliseconds: 300));
  onProgress(1.0);
}

// --- FUNZIONI DI SUPPORTO CORRETTE ---

List<tiled.TiledObject> _getObjects(String layerName) {
  final allObjects = <tiled.TiledObject>[];
  
  // Esplora tutti i layer della mappa
  for (final renderableLayer in mapComponent.tileMap.renderableLayers) {
    allObjects.addAll(_searchInLayer(renderableLayer.layer, layerName));
  }
  return allObjects;
}

Iterable<tiled.TiledObject> _searchInLayer(tiled.Layer layer, String name) {
  // 1. Se è un layer di oggetti e ha il nome giusto, restituisci gli oggetti
  if (layer is tiled.ObjectGroup && layer.name == name) {
    return layer.objects;
  }
  
  // 2. Se è un gruppo (usando tiled.Group come suggerito dal tuo IDE), scava dentro
  if (layer is tiled.Group) {
    return layer.layers.expand((subLayer) => _searchInLayer(subLayer, name));
  }
  
  return [];
}

  //debugMode = true;

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> pressedKeys) {
    if (event is KeyDownEvent) {
      player.pressKey(event.logicalKey, true);
    }
    if (event is KeyUpEvent) {
      player.pressKey(event.logicalKey, false);
    }
    return super.onKeyEvent(event, pressedKeys);
  }

  // Metodo unlockLevel ora correttamente dentro la classe MyGame
  void unlockLevel(String levelId) {
    print("Chiamato unlockLevel per: $levelId");
    if (LevelManager.unlock(levelId)) {
      print("Sblocco nel Manager riuscito!");
      
      _activeGates.removeWhere((gate) {
        if (gate.gateId == levelId) {
          gate.removeFromParent();
          return true;
        }
        return false;
      });

      print("Sto per chiamare onLevelUnlocked...");
      onLevelUnlocked();
    } else {
      print("Livello già sbloccato precedentemente.");
    }
  }
}



