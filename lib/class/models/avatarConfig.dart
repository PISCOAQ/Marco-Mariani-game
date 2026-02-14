import 'package:gioco_demo/class/models/ClothingItem.dart';

class AvatarConfig {
  final String bodyPath;
  final Map<String, ClothingItem> shirts;
  final Map<String, ClothingItem> pants;
  final Map<String, ClothingItem> shoes;
  final Map<String, ClothingItem> hair;

  // Righe dello spritesheet
  final int rowIdle;
  final int rowBack;
  final int rowLeft;
  final int rowFront;
  final int rowRight;

  final double stepTime;
  final double idleStepTime;

  AvatarConfig({
    required this.bodyPath,
    required this.shirts,
    required this.pants,
    required this.shoes,
    required this.hair,

    required this.rowBack,
    required this.rowLeft,
    required this.rowFront,
    required this.rowRight,
    required this.rowIdle,
    required this.stepTime,
    required this.idleStepTime,
  });

  factory AvatarConfig.fromJson(Map<String, dynamic> json) {
    return AvatarConfig(
      bodyPath: json['bodyPath'],

      shirts: _parseCategory('shirt', json['shirts']),
      pants: _parseCategory('pants', json['pants']),
      shoes: _parseCategory('shoes', json['shoes']),
      hair: _parseCategory('hair', json['hair']),

      rowBack: json['rows']['back'],
      rowLeft: json['rows']['left'],
      rowFront: json['rows']['front'],
      rowRight: json['rows']['right'],
      rowIdle: json['rows']['idle'],
      stepTime: json['timings']['walk'].toDouble(),
      idleStepTime: json['timings']['idle'].toDouble(),
      
    );
  }


static Map<String, ClothingItem> _parseCategory(String category, Map<String, dynamic> json) {
  return json.map((styleKey, data) { // styleKey al posto di color
    return MapEntry(
      styleKey,
      ClothingItem.fromJson(category, styleKey, data),
    );
  });
}



}
