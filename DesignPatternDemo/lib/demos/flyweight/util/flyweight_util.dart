///
/// flyweight_util.dart
/// FlyweightUtil
///
/// Created by Adam Chen on 2026/01/02.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'dart:ui';

import 'package:flutter/material.dart';

class FlyweightUtil {
  static Color parseColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red': return Colors.red;
      case 'green': return Colors.green;
      case 'blue': return Colors.blue;
      case 'yellow': return Colors.amber;
      case 'black': return Colors.black;
      default: return Colors.grey;
    }
  }
}