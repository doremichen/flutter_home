///
/// color_parser.dart
/// ColorParser
///
/// Created by Adam Chen on 2025/12/30.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

extension ColorParser on String {
  /// 將字串轉換為 Flutter Color 物件
  Color toColor() {
    final s = toLowerCase();
    if (s.contains('red')) return Colors.red;
    if (s.contains('blue')) return Colors.blue;
    if (s.contains('green')) return Colors.green;
    if (s.contains('black')) return Colors.black;
    if (s.contains('white')) return Colors.grey.shade300;
    if (s.contains('yellow')) return Colors.yellow.shade700;

    // 預設為主題紫色
    return Colors.deepPurple.shade300;
  }
}

class ColorUtils {
  static Color parse(String? colorString) {
    final s = (colorString ?? '').toLowerCase();
    if (s.contains('red')) return Colors.red;
    if (s.contains('blue')) return Colors.blue;
    if (s.contains('green')) return Colors.green;
    if (s.contains('black')) return Colors.black;
    if (s.contains('white')) return Colors.grey.shade300;
    if (s.contains('yellow')) return Colors.yellow.shade700;
    return Colors.deepPurple.shade300;
  }
}