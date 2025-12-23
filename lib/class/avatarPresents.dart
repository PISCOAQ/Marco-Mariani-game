import 'package:gioco_demo/class/avatarConfig.dart';

AvatarConfig defaultAvatarConfig(int avatarIndex) {
  return AvatarConfig(
    bodyPath: avatarIndex == 2
        ? '../avatars/FemaleAvatar_spritesheet.png'
        : '../avatars/MaleAvatar_spritesheet.png',

    shirts: {
      'red':   '../avatars/shirt_red.png',
      'blue':  '../avatars/shirt_blue.png',
      'grey':  '../avatars/shirt_grey.png',
      'black': '../avatars/shirt_black.png',
    },

    pants: {   // <- aggiunto obbligatorio
      'blue':  '../avatars/pants_blue.png',
      'black': '../avatars/pants_black.png',
    },

    rowBack: 8,
    rowLeft: 9,
    rowFront: 10,
    rowRight: 11,
    rowIdle: 10,

    stepTime: 0.1,
    idleStepTime: 1.0,
  );
}
