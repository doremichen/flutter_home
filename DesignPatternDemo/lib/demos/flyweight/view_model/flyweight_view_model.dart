///
/// flyweight_view_model.dart
/// FlyweightViewModel
/// MapObject
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'dart:math';

import 'package:design_pattern_demo/demos/flyweight/pattern/sprite_factory.dart';
import 'package:flutter/material.dart.';

import '../model/sprite.dart';

class MapObject {
  final double x;      // Extrinsic
  final double y;      // Extrinsic
  final double size;   // Extrinsic
  final Sprite sprite; // Intrinsic (shared!!!)

  MapObject({required this.x, required this.y, required this.size, required this.sprite});

  @override
  String toString() => '[$x,$y] size=$size → ${sprite.key}';
}

class FlyweightViewModel extends ChangeNotifier {
    final SpriteFactory factory = SpriteFactory();
    final Random _random = Random();

    // UI selection item
    final List<String> types = const ['Tree', 'Rock', 'House', 'NPC'];
    final List<String> colors = const ['Green', 'Brown', 'Gray', 'Red', 'Blue'];

    int selectedTypeIndex = 0;
    int selectedColorIndex = 0;
    bool randomColors = false;

    // map objects information
    final List<MapObject> objects = [];

    // log
    final List<String> logs = [];
    String? _lastToast;

    static const int EXTRINSIC_BYTES_PER_OBJECT = 32;

    String? takeLastToast() {
      final t = _lastToast;
      _lastToast = null;
      return t;
    }

    // get type
    String get currentType => types[selectedTypeIndex];
    // get color
    String get currentColor => colors[selectedColorIndex];

    // --- setter ---
    void selectType(int index) {
      selectedTypeIndex = index;
      _log('選擇類型：${types[index]}');
      notifyListeners();
    }

    void selectColor(int index) {
      selectedColorIndex = index;
      _log('選擇顏色：${colors[index]}');
      notifyListeners();
    }


    void toggleRandomizeColors(bool v) {
      randomColors = v;
      _log('隨機顏色：$randomColors');
      notifyListeners();
    }

    // add object (flyweight)
    void addBatch(int count) {
      for (var i = 0; i < count; i++) {
        final type = currentType;
        final color = randomColors ? colors[_random.nextInt(colors.length)] : currentColor;
        final sprite = factory.getSprite(type: type, color: color); // 共享
        final obj = MapObject(
          x: _random.nextDouble() * 1000,
          y: _random.nextDouble() * 1000,
          size: 8 + _random.nextDouble() * 24,
          sprite: sprite,
        );
        objects.add(obj);
      }
      _log('新增物件 ×$count（type=$currentType, color=${randomColors ? 'Random' : currentColor}）');
      _lastToast = 'Added $count';
      notifyListeners();
    }

    void clearAll() {
      objects.clear();
      factory.clear();
      _log('清除所有物件');
      _lastToast = 'Cleared';
      notifyListeners();
    }

    // --- memory evaluation ---------
    double get memoryWithFlyweightKB {
      final sharedKB = factory.sharedSprites.fold<int>(0, (sum, s) => sum + s.sizeKB);
      final extrinsicKB = (objects.length * EXTRINSIC_BYTES_PER_OBJECT) / 1024.0;
      return sharedKB + extrinsicKB;
    }

    double get memoryNaiveKB {
      double sumKB = 0;
      for (final o in objects) {
        sumKB += o.sprite.sizeKB;
      }
      final extrinsicKB = (objects.length * EXTRINSIC_BYTES_PER_OBJECT) / 1024.0;
      return sumKB + extrinsicKB;
    }

    double get memorySavingKB => (memoryNaiveKB - memoryWithFlyweightKB).clamp(0, double.infinity);
    double get memorySavingPct => objects.isEmpty ? 0 : (memorySavingKB / memoryNaiveKB * 100.0);

    int get totalObjects => objects.length;
    int get uniqueFlyweights => factory.sharedCount;

    void _log(String s) => logs.add(s);


    void clearLogs() {
      logs.clear();
      _lastToast = 'Logs cleared';
      notifyListeners();
    }
}