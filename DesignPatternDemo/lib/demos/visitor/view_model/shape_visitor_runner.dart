///
/// shape_visitor_run.dart
/// ShapeVisitorRunner
///
/// Created by Adam chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../interface/shape_visitor.dart';
import '../model/shape.dart';

class ShapeVisitorRunner {
  static (List<String> lines, List<String> logs) run(ShapeVisitor visitor, List<Shape> shapes) {
    visitor.start();
    for (final shape in shapes) {
      shape.accept(visitor);
    }
    visitor.end();
    final lines = visitor.lines;
    final logs = visitor.logs;
    return (lines, logs);
  }
}