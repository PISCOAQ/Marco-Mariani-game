import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:gioco_demo/game/chest.dart';

class Player extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef {
  Vector2 velocity = Vector2.zero();
  final double speed = 130;
  final Set<LogicalKeyboardKey> _keysPressed = {};
  late Vector2 lastDelta;

  late SpriteAnimation walkRightAnimation;
  late SpriteAnimation walkLeftAnimation;
  late SpriteAnimation walkBackAnimation;
  late SpriteAnimation walkAnimation;
  late SpriteAnimation idleAnimation; 

  final int avatarIndex;


  Player({required this.avatarIndex, required Vector2 position})
      : super(position: position, size: Vector2(64, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {

    String avatarPath;
    if (avatarIndex == 1) {
      avatarPath = '../avatars/MaleAvatar_spritesheet.png';
    } else if (avatarIndex == 2) {
      avatarPath = '../avatars/FemaleAvatar_spritesheet.png';
    } else {
      avatarPath = '../avatars/MaleAvatar_spritesheet.png';
    }

    final image = await gameRef.images.load(avatarPath);
    
    // crea instanza spritesheet
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(64, 64),
    );

   
    // count è il numero di frame totali nella riga
    walkBackAnimation = spriteSheet.createAnimation(row: 8, stepTime: 0.1, to: 9);
    walkLeftAnimation = spriteSheet.createAnimation(row: 9, stepTime: 0.1, to: 9);
    walkAnimation     = spriteSheet.createAnimation(row: 10, stepTime: 0.1, to: 9);
    walkRightAnimation = spriteSheet.createAnimation(row: 11, stepTime: 0.1, to: 9);

    idleAnimation = spriteSheet.createAnimation(row: 10, stepTime: 1.0, from: 0, to: 1);

    //animazione iniziale
    animation = idleAnimation;

    size = Vector2(64, 64);
    anchor = Anchor.center;

    //debugMode = true; -> mostra limiti del personaggio

    add(
    RectangleHitbox(
      // La dimensione della "base" del personaggio (piedi)
      // Per le collisioni dal basso
      size: Vector2(20, 10), 
      
      // La posizione relativa dentro il quadrato 64x64 -> centro dell'avatar
      // Per le collisioni dall'alto
      position: Vector2(22, 50), 
    ),
  );
  }


  void pressKey(LogicalKeyboardKey key, bool down) {
    if (down)
      _keysPressed.add(key);
    else
      _keysPressed.remove(key);
  }


  @override
  void update(double dt) {
    super.update(dt);
    // Più la Y è alta (più sei in basso), più la priorità aumenta
    priority = position.y.toInt();

    velocity.setZero();

    if (_keysPressed.contains(LogicalKeyboardKey.arrowUp)) velocity.y = -1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowDown)) velocity.y = 1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft)) velocity.x = -1;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowRight)) velocity.x = 1;

    if (velocity.length != 0 ) {
      velocity.normalize();
      lastDelta = velocity * speed * dt;
      position += lastDelta;


if (velocity.y < 0) {
      animation = walkBackAnimation; // Cammina verso l'ALTO
    } else if (velocity.y > 0) {
      animation = walkAnimation;     // Cammina verso il BASSO
    } else if (velocity.x < 0) {
      animation = walkLeftAnimation;  // Cammina verso SINISTRA
    } else if (velocity.x > 0) {
      animation = walkRightAnimation; // Cammina verso DESTRA
    }

      
    } else {
      lastDelta = Vector2.zero();
      animation = idleAnimation; // torna al frame fermo
    }
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    //Se colpiamo un forziere lo apriamo
    if (other is Chest) {
      other.open(); 
    }

    if (other is! Player) {
      position -= lastDelta;
    }
    super.onCollision(intersectionPoints, other);
  }
}
