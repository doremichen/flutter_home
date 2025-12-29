///
/// area_visitor.dart
/// AreaVisitor
///
/// Crested by Adam Chen on 2025/12/29
/// Copyright © 2025 abb company. All rights reserved.
import 'dart:math';

import 'package:design_pattern_demo/demos/visitor/model/circle.dart';
import 'package:design_pattern_demo/demos/visitor/model/rectangle.dart';
import 'package:design_pattern_demo/demos/visitor/model/triangle.dart';

import '../interface/shape_visitor.dart';

class AreaVisitor extends ShapeVisitor {

  @override
  void start() {
    logs.add('AreaVisitor.start()');
  }

  @override
  void end() {
    logs.add('AreaVisitor.end()');
  }

  @override
  void visitCircle(Circle circle) {
    final area = circle.radius * circle.radius * pi;
    final line = 'Circle(r=${circle.radius.toStringAsFixed(2)}) → area=${area.toStringAsFixed(2)}';
    lines.add(line);
    logs.add('圓形面積：$line');
  }

  @override
  void visitRectangle(Rectangle rectangle) {
    final area = rectangle.w * rectangle.h;
    final line = 'Rectangle(${rectangle.w.toStringAsFixed(2)}×${rectangle.h.toStringAsFixed(2)}) → area=${area.toStringAsFixed(2)}';
    lines.add(line);
    logs.add('長方形面積: $line');
  }

  @override
  void visitTriangle(Triangle triangle) {
    final area = triangle.sideA * triangle.sideB / 2;
    final line = 'Triangle(${triangle.sideA.toStringAsFixed(2)}×${triangle.sideB.toStringAsFixed(2)}) → area=${area.toStringAsFixed(2)}';
    lines.add(line);
    logs.add('三角形面積: $line');
  }

  @override
  String get name => 'AreaVisitor';

}