
import '../model/circle.dart';

import '../model/rectangle.dart';

import '../model/triangle.dart';

import '../interface/shape_visitor.dart';

class PerimeterVisitor extends ShapeVisitor {

  @override
  String get name => 'PerimeterVisitor';

  @override
  void start() {
    logs.add('Start $name');
  }

  @override
  void end() {
    logs.add('End $name');
  }

  @override
  void visitCircle(Circle c) {
    final p = 2 * 3.141592653589793 * c.radius;
    final line = 'Circle(r=${c.radius.toStringAsFixed(2)}) → perimeter=${p.toStringAsFixed(2)}';
    lines.add(line);
    logs.add('圓形週長：$line');
  }

  @override
  void visitRectangle(Rectangle r) {
    final p = 2 * (r.w + r.h);
    final line = 'Rectangle(${r.w.toStringAsFixed(2)}×${r.h.toStringAsFixed(2)}) → perimeter=${p.toStringAsFixed(2)}';
    lines.add(line);
    logs.add('長方形週長：$line');
  }

  @override
  void visitTriangle(Triangle t) {
    final p = t.sideA + 2 * t.sideB;
    final line = 'Triangle(b=${t.sideA.toStringAsFixed(2)}, h=${t.sideB.toStringAsFixed(2)}) → perimeter≈${p.toStringAsFixed(2)}';
    lines.add(line);
    logs.add('三角形週長（近似）：$line');
  }

}