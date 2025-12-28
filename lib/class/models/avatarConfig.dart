class AvatarConfig {
  final String bodyPath;
  final Map<String, String> shirts;
  final Map<String, String> pants;
  final Map<String, String> shoes;
  final Map<String, String> hair;


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
    shirts: Map<String, String>.from(json['shirts']),
    pants: Map<String, String>.from(json['pants']), 
    hair: Map<String, String>.from(json['hair']),
    shoes: Map<String, String>.from(json['shoes']),

    rowBack: json['rows']['back'],
    rowLeft: json['rows']['left'],
    rowFront: json['rows']['front'],
    rowRight: json['rows']['right'],
    rowIdle: json['rows']['idle'],
    stepTime: json['timings']['walk'].toDouble(),
    idleStepTime: json['timings']['idle'].toDouble(),
  );
}


}
