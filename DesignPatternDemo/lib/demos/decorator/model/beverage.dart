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
  String get name => '濃縮咖啡';

  @override
  double cost() => 60.0;

  @override
  String describe() => name;
}

class HouseBlend implements Beverage {
  @override
  String get name => '自家混合';

  @override
  double cost() => 50.0;

  @override
  String describe() => name;
}

class DarkRoast implements Beverage {
  @override
  String get name => '深烘焙';

  @override
  double cost() => 55.0;

  @override
  String describe() => name;
}