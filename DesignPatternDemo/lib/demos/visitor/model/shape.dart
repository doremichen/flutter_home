///
/// shape.dart
/// Shape
///
/// Created by Adam Chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/shape_visitor.dart';

abstract class Shape {
  final String name;
  Shape(this.name);

  void accept(ShapeVisitor visitor);
}