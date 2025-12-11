///
/// director.dart
/// MealDirector
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'meal_builder.dart';

class MealDirector {
  void constructLightCombo(MealBuilder builder) {
    builder.reset();
    builder.buildMain();
    builder.buildSide();
    builder.buildDrink();
  }

  void constructFullCourse(MealBuilder builder) {
    builder.reset();
    builder.buildMain();
    builder.buildSide();
    builder.buildDrink();
    builder.buildDessert();
  }
}