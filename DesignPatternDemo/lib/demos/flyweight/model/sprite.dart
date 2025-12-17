///
/// sprite.dart
/// Sprite
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
class Sprite {
  final String type;   // Tree/Rock/House/NPC
  final String color;  // Green/Brown/Gray/Red/Blue
  final int sizeKB;    // presentation size in KB

  Sprite({required this.type, required this.color, required this.sizeKB});

  String get key => '$type-$color';

  @override
  String toString() => 'Sprite($type, $color, ${sizeKB}KB)';

}
