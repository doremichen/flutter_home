///
/// rectangle.dart
/// Rectangle
///
/// Created by Adam chen on 2025/12/29
/// Copyright © 2025年 Adam chen. All rights reserved.
///
import '../interface/shape_visitor.dart';

import 'shape.dart';

class Rectangle extends Shape {
  final double w;
  final double h;

  Rectangle(this.w, this.h): super('Rectangle');

  @override
  void accept(ShapeVisitor visitor) {
    visitor.visitRectangle(this);
  }

}