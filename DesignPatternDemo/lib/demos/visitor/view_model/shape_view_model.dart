///
/// shape_view_model
/// ShapeViewModel
///
/// Created vy Adam chen on 2025/12/29
/// Copyright © 2025 abb company. All rights reserved.
///
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart.';

import '../../observer/model/log_event.dart';
import '../model/circle.dart';
import '../model/rectangle.dart';
import '../model/shape.dart';
import '../interface/shape_visitor.dart';
import '../model/triangle.dart';
import '../pattern/area_vistior.dart';
import '../pattern/parimeter_visitor.dart';
import 'shape_visitor_runner.dart';

enum VisitorType { area, perimeter }

class ShapeViewModel extends ChangeNotifier {
  VisitorType _selectedVisitor = VisitorType.area;
  ShapeVisitor _visitor = AreaVisitor();

  final List<Shape> _shapes = [];
  List<String>? _outputLines;
  final List<LogEvent> _logs = [];
  String? lastToast;

  bool _auto = false;
  Timer? _timer;

  ShapesViewModel() {
    _setVisitor(VisitorType.area);
    generateShapes(); // 初始資料
  }

  // -- getter ---
  VisitorType get visitorType => _selectedVisitor;
  String get visitorName => _visitor.name ?? '';
  List<Shape> get shapes => List.unmodifiable(_shapes);
  List<String>? get outputLines => _outputLines;
  List<LogEvent> get logs => _logs;
  bool get auto => _auto;


  void _setVisitor(VisitorType type) {
    _selectedVisitor = type;
    switch (type) {
      case VisitorType.area:
        _visitor = AreaVisitor();
        break;
      case VisitorType.perimeter:
        _visitor = PerimeterVisitor();
        break;
    }

    _appendLog('切換 Visitor：${_visitor.name}');
    notifyListeners();
  }

  void selectVisitor(VisitorType type) {
    lastToast = 'selectVisitor: ${type.name}';
    if (_selectedVisitor == type) return;
    _setVisitor(type);
  }


  void _appendLog(String s) {
    _logs.add(LogEvent(s));
  }

  void generateShapes({int count = 6}) {
    _shapes.clear();
    final rnd = Random();
    for (int i = 0; i < count; i++) {
      final pick = rnd.nextInt(3);
      switch (pick) {
        case 0:
        // Circle r: 1..10
          _shapes.add(Circle(1 + rnd.nextDouble() * 9));
          break;
        case 1:
        // Rectangle w: 2..12, h: 2..12
          _shapes.add(Rectangle(2.0 + rnd.nextDouble() * 10.0,
              2.0 + rnd.nextDouble() * 10.0));
          break;
        case 2:
        // Triangle b: 2..12, h: 2..12
          _shapes.add(Triangle(2 + rnd.nextDouble() * 10, 2 + rnd.nextDouble() * 10));
          break;
      }
    }
    _outputLines = null;
    _appendLog('產生圖形 ${_shapes.length} 件');
    notifyListeners();
  }

  void runVisitor() {
    final (lines, logs) = ShapeVisitorRunner.run(_visitor, _shapes);
    _outputLines = lines;
    for (final s in logs) {
      _logs.add(LogEvent(s));
    }
    _appendLog('執行 Visitor：${_visitor.name}');
    lastToast = 'runVisitor: ${_visitor.name}';
    notifyListeners();
  }

  void clear() {
    _shapes.clear();
    _outputLines = null;
    _logs.clear();
    _appendLog('清空結果與日誌');
    lastToast = 'clear';
    notifyListeners();
  }

  void toggleAuto() {
    _auto = !_auto;
    _timer?.cancel();
    if (_auto) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final rnd = Random().nextBool();
        if (rnd) {
          generateShapes(count: 4 + Random().nextInt(5));
        } else {
          runVisitor();
        }
      });
    }
    lastToast = 'toggleAuto: $_auto';
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

}