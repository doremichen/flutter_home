///
/// circle.dart
/// Circle
///
/// Created by Adam Chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/shape_visitor.dart';

import 'shape.dart';

class Circle extends Shape {
  double radius;
  Circle(this.radius) : super('Circle');

  @override
  void accept(ShapeVisitor visitor) {
    // TODO: implement accept
  }

}