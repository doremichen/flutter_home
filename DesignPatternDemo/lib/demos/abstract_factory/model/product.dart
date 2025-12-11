///
/// product.dart
/// Engine
/// Tire
/// SportEngine
/// SportTire
/// FamilyEngine
/// FamilyTire
/// TruckEngine
/// TruckTire
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///

abstract class Engine {
  String spec();
}

abstract class Tire {
  String spec();
}

class SportEngine implements Engine {
  @override
  String spec() => 'SportEngine: twin-turbo, high RPM';
}

class SportTire implements Tire {
  @override
  String spec() => 'SportTire: soft compound, high grip';
}

class FamilyEngine implements Engine {
  @override
  String spec() => 'FamilyEngine: fuel efficient, quiet';
}

class FamilyTire implements Tire {
  @override
  String spec() => 'FamilyTire: comfort-oriented, long-lasting';
}

class TruckEngine implements Engine {
  @override
  String spec() => 'TruckEngine: high torque, diesel';
}

class TruckTire implements Tire {
  @override
  String spec() => 'TruckTire: reinforced sidewall, heavy load';
}