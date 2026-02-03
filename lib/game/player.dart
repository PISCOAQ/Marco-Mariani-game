import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:gioco_demo/class/models/ClothingItem.dart';
import 'package:gioco_demo/class/models/PlayerState.dart';
import 'package:gioco_demo/class/models/SensorLevel.dart';
import 'package:gioco_demo/class/models/avatarConfig.dart';
import 'package:gioco_demo/class/services/Avatar_loader.dart';
import 'package:gioco_demo/game/chest.dart';

class Player extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef {
  Vector2 velocity = Vector2.zero();
  final double speed = 110;
  final Set<LogicalKeyboardKey> _keysPressed = {};
  late Vector2 lastDelta;

  int currentFloor = 1; // Di default iniziamo a terra

  final PlayerState playerState;

  late final AvatarConfig avatarConfig;

  // Animazioni Corpo
  late SpriteAnimation walkRightAnimation, walkLeftAnimation, walkBackAnimation, walkAnimation, idleAnimation, walk;

  final int avatarIndex;

  Map<String, String?> currentLayers = {
  'shirt': null,
  'pants': null,
  'hair': null,
  'shoes': null,
};


  // --- NUOVO: multi-layer generico ---
  final Map<String, SpriteAnimationComponent> layers = {};
  final Map<String, SpriteAnimation?> animations = {};
  final Map<String, String?> currentLayerColor = {};

  Player({required this.avatarIndex, required Vector2 position, required this.playerState})
      : super(position: position, size: Vector2(64, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // 1. CARICAMENTO CORPO
    avatarConfig = await loadAvatarFromJson('../data/avatar.json', avatarIndex);


    final image = await gameRef.images.load(avatarConfig.bodyPath);
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(64, 64));

    await _applyEquippedItems();

    walkBackAnimation = spriteSheet.createAnimation(row: avatarConfig.rowBack, stepTime: avatarConfig.stepTime, from: 1, to: 9);
    walkRightAnimation = spriteSheet.createAnimation(row: avatarConfig.rowRight, stepTime: avatarConfig.stepTime, to: 9);
    walkLeftAnimation = spriteSheet.createAnimation(row: avatarConfig.rowLeft, stepTime: avatarConfig.stepTime, to: 9);
    walkAnimation = spriteSheet.createAnimation(row: avatarConfig.rowFront, stepTime: avatarConfig.stepTime,from:1, to: 9);
    idleAnimation = spriteSheet.createAnimation(row: avatarConfig.rowIdle, stepTime: avatarConfig.idleStepTime, from: 0, to: 1);

    animation = idleAnimation;

    // 2. HITBOX
    add(RectangleHitbox(size: Vector2(20, 10), position: Vector2(22, 50)));

    priority = 2;
  }

  // funzione generica per aggiungere layer ---
  Future<void> loadLayer(String layerName, Map<String, ClothingItem> items, String? color) async {
    if (color == null) return;

    final item = items[color];
    if (item == null) return;

    final image = await gameRef.images.load(item.path);
    final sheet = SpriteSheet(image: image, srcSize: Vector2(64, 64));

    animations['${layerName}_back'] =
        sheet.createAnimation(row: avatarConfig.rowBack, stepTime: avatarConfig.stepTime, from:1, to: 9);
    animations['${layerName}_left'] =
        sheet.createAnimation(row: avatarConfig.rowLeft, stepTime: avatarConfig.stepTime, to: 9);
    animations['${layerName}_front'] =
        sheet.createAnimation(row: avatarConfig.rowFront, stepTime: avatarConfig.stepTime, from: 1, to: 9);
    animations['${layerName}_right'] =
        sheet.createAnimation(row: avatarConfig.rowRight, stepTime: avatarConfig.stepTime, to: 9);
    animations['${layerName}_idle'] =
        sheet.createAnimation(row: avatarConfig.rowIdle, stepTime: avatarConfig.idleStepTime, from: 0, to: 1);

    if (!layers.containsKey(layerName)) {
      final comp = SpriteAnimationComponent(size: size);
      layers[layerName] = comp;
      add(comp);
    }

    layers[layerName]!.animation = animations['${layerName}_idle'];
    currentLayerColor[layerName] = color;
  }

  Future<void> changeLayer(String layerName, Map<String, ClothingItem> assets, String color) async {
    currentLayerColor[layerName] = color;
    await loadLayer(layerName, assets, color);
  }


  @override
  void update(double dt) {
    super.update(dt);

    velocity.setZero();
    if (_keysPressed.contains(LogicalKeyboardKey.arrowUp)) velocity.y = -1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowDown)) velocity.y = 1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft)) velocity.x = -1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowRight)) velocity.x = 1;

    if (velocity.length != 0) {
      velocity.normalize();
      lastDelta = velocity * speed * dt;
      position += lastDelta;

      // --- LOGICA DIAGONALE: Priorità asse X ---
      // Se premo sinistra+su o sinistra+giù, vince 'left'
      // Se premo destra+su o destra+giù, vince 'right'
      
      String suffix;
      SpriteAnimation? bodyAnim;

      if (velocity.x < 0) {
        suffix = 'left';
        bodyAnim = walkLeftAnimation;
      } else if (velocity.x > 0) {
        suffix = 'right';
        bodyAnim = walkRightAnimation;
      } else if (velocity.y < 0) {
        suffix = 'back';
        bodyAnim = walkBackAnimation;
      } else {
        suffix = 'front';
        bodyAnim = walkAnimation;
      }

      // Aggiorna corpo principale
      animation = bodyAnim;
      animation!.stepTime = avatarConfig.stepTime;

      // Aggiorna tutti i layer vestiti
      for (final layerName in layers.keys) {
        layers[layerName]!.animation = animations['${layerName}_$suffix'];
        if (layers[layerName]!.animation != null) {
          layers[layerName]!.animation!.stepTime = avatarConfig.stepTime;
        }
      }

    } else {
      lastDelta = Vector2.zero();

      // Stato Idle: fermiamo l'avanzamento dei frame
      for (final layerName in layers.keys) {
        final anim = layers[layerName]!.animation;
        if (anim != null) anim.stepTime = double.infinity;
      }
      if (animation != null) animation!.stepTime = double.infinity;
    }
    
    priority = (currentFloor * 1000) + position.y.toInt();
    
    // Cerchiamo quello che si chiama livello_2
  if (currentFloor == 3 ) {
    // SEI SOTTO (Livello 3): 5 è più basso di 15 (ponte).
    priority = 5; 
  } else if (currentFloor == 2) {
    // SEI SOPRA (Livello 2): 25 è più alto di 15 (ponte).
    priority = 25;
  }else if (currentFloor == 4) {
    // SUL LIVELLO 4: Sei sopra a tutto
    priority = 5; 
  }

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Chest) other.open();
    //se l'oggetto è un FloorSensor, NON resettare la posizione.
    if (other is! Player && other is! FloorSensor) {
      position -= lastDelta; // Questo blocca il movimento
    }
    super.onCollision(intersectionPoints, other);
  }

  void pressKey(LogicalKeyboardKey key, bool down) {
    if (down)
      _keysPressed.add(key);
    else
      _keysPressed.remove(key);
  }

  Future<void> _applyEquippedItems() async {
    for (final entry in playerState.equippedItems.entries) {
      final category = entry.key;
      final color = entry.value;

      if (color == null) continue;

      switch (category) {
        case 'shirts':
          await changeLayer(category, avatarConfig.shirts, color);
          break;
        case 'pants':
          await changeLayer(category, avatarConfig.pants, color);
          break;
        case 'hair':
          await changeLayer(category, avatarConfig.hair, color);
          break;
        case 'shoes':
          await changeLayer(category, avatarConfig.shoes, color);
          break;
      }
    }
  }

  Future<void> applyState() async {
    await _applyEquippedItems();
  }

  void resetMovement() {
  _keysPressed.clear(); 
  velocity.setZero();
}

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
  super.onCollisionStart(intersectionPoints, other);

  if (other is FloorSensor) {
    currentFloor = other.floorValue;
    print("Passaggio al livello: $currentFloor");
  }
}


}
