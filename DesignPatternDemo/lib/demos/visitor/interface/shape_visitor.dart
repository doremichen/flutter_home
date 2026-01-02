///
/// shape_visitor.dart
/// ShapeVisitor
/// Created by Adam Chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/rectangle.dart';
import '../model/triangle.dart';

import '../model/circle.dart';

///
/// shape_visitor.dart
/// ShapeVisitor
///
/// Created by Adam Chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved
///
abstract class ShapeVisitor {
    final List<String> logs = [];
    final List<String> lines = [];
    String get name;

    void start();
    void end();

    // visitor shape
    void visitCircle(Circle circle);
    void visitRectangle(Rectangle rectangle);
    void visitTriangle(Triangle triangle);

}