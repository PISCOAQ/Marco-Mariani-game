import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gioco_demo/class/models/Levelmanager.dart';
import 'package:gioco_demo/class/models/PlayerState.dart';
import 'package:gioco_demo/class/models/gateComponent.dart';
import 'package:gioco_demo/game/chest.dart';
import 'package:gioco_demo/game/components/Interactive_object.dart';
import 'player.dart';
import 'wall.dart';

// Definizione callback
typedef ShowActivityCallback = void Function(String tipo);
typedef ShowChestCallback = void Function();
typedef LevelUnlockedCallback = void Function();


class MyGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late final PlayerState playerState = PlayerState();
  late TiledComponent mapComponent;

  final int avatarIndex;
  final ShowActivityCallback onShowPopup;
  final ShowChestCallback onShowChestPopup;

  final LevelUnlockedCallback onLevelUnlocked;

  final List<GateComponent> _activeGates = [];

  MyGame({
    required this.avatarIndex,
    required this.onShowPopup,
    required this.onShowChestPopup,
    required this.onLevelUnlocked,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1️. MAPPA
    mapComponent = await TiledComponent.load(
      'game_map.tmx',
      Vector2.all(32),
    );
    world.add(mapComponent);

    // 2. OGGETTI INTERATTIVI
    final objectLayer = mapComponent.tileMap.getLayer<ObjectGroup>('interactions');
    if (objectLayer != null) {
      for (final object in objectLayer.objects) {
        if (object.type == 'trigger_quiz') {
          world.add(InteractiveObject(
            object.x,
            object.y,
            object.width,
            object.height,
            () {
              onShowPopup('quiz');
              unlockLevel('2'); // Sblocca il muro con valore '2'
            },
            spritePath: 'quiz.png',
          ));
        } else if (object.type == 'trigger_esercitazione') {
          world.add(InteractiveObject(
            object.x,
            object.y,
            object.width,
            object.height,
            () => onShowPopup('esercitazione'),
            spritePath: 'training.png',
          ));
        } else if (object.type == 'chest') {
          world.add(Chest(
            position: Vector2(object.x, object.y),
            size: Vector2(object.width, object.height),
            onOpen: onShowChestPopup,
          ));
        }
      }
    }

    // 3️. PLAYER -> default clothes
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

    // 4. CARICAMENTO CANCELLI
    final gateLayer = mapComponent.tileMap.getLayer<ObjectGroup>('LevelBarriers');
    if (gateLayer != null) {
      for (final obj in gateLayer.objects) {
        final String levelId = obj.properties.getValue('valore')?.toString() ?? 'unknown';
        final gate = GateComponent(
          position: Vector2(obj.x, obj.y),
          size: Vector2(obj.width, obj.height),
          gateId: levelId,
        );
        _activeGates.add(gate);
        world.add(gate);
      }
    } 

    // 5. COLLISIONI
    final collisionLayer = mapComponent.tileMap.getLayer<ObjectGroup>('collisioni');
    if (collisionLayer != null) {
      for (final obj in collisionLayer.objects) {
        world.add(Wall(
          Vector2(obj.x, obj.y),
          Vector2(obj.width, obj.height),
        ));
      }
    }

    // 6. CAMERA
    camera.viewfinder.zoom = 2.0;
    camera.follow(player);

    //debugMode = true;
  }

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