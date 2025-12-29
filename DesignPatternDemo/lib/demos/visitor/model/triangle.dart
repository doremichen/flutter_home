///
/// triangle.dart
/// Triangle
///
/// Created by Adam Chen on 2025/11/29
/// Copyright © 2025 abb company. All rights reserved.
///
import '../interface/shape_visitor.dart';

import 'shape.dart';

class Triangle extends Shape {
  final double sideA;
  final double sideB;

  Triangle(this.sideA, this.sideB): super('Triangle');

  @override
  void accept(ShapeVisitor visitor) {
    visitor.visitTriangle(this);
  }

}