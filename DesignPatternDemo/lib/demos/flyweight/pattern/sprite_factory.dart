///
/// sprite_factory.dart
/// SpriteFactory
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../model/sprite.dart';

class SpriteFactory {
  // map<string, sprite>
  final Map<String, Sprite> _cache = {};

  // define default data
  static const Map<String, int> _typeDefaultKB = {
    'Tree': 80,
    'Rock': 30,
    'House': 120,
    'NPC': 60,
  };

  // create sprite or get from cache
  Sprite getSprite({required String type, required String color}) {
    final key = '$type-$color';
    final cached = _cache[key];
    if (cached != null) {
      return cached;
    }

    final baseKB = _typeDefaultKB[type] ?? 50;
    // create new
    final newSprite = Sprite(type: type, color: color, sizeKB: baseKB);
    // put into cache
    _cache[key] = newSprite;
    return newSprite;
  }

  int get sharedCount => _cache.length;

  // list
  List<Sprite> get sharedSprites => _cache.values.toList();

  // clear
  void clear() => _cache.clear();

}