///
/// beverage.dart
/// Beverage
///
/// Created by Adam Chen on 2025/12/16.
/// Copyright © 2025 Abb company. All rights reserved.
///

abstract class Beverage {
  String get name; // name
  double cost(); // cost
  String describe(); // description
}

// --- concrete beverage ---
class Espresso implements Beverage {
  @override
  String get name => 'Espresso';

  @override
  double cost() => 60.0;

  @override
  String describe() => name;
}

class HouseBlend implements Beverage {
  @override
  String get name => 'House Blend';

  @override
  double cost() => 50.0;

  @override
  String describe() => name;
}

class DarkRoast implements Beverage {
  @override
  String get name => 'Dark Roast';

  @override
  double cost() => 55.0;

  @override
  String describe() => name;
}