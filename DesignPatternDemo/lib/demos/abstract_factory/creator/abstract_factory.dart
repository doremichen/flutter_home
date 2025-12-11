///
/// abstractory_factory.dart
/// VehiclePartsFactory
/// SportPartsFactory
/// FamilyPartsFactory
/// TruckPartsFactory
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../model/product.dart';

abstract class VehiclePartsFactory {
  String get label; // for UI
  Engine createEngine();
  Tire createTire();
}

/// =======================
/// Concrete Factories
/// =======================
class SportPartsFactory implements VehiclePartsFactory {
  @override
  String get label => 'Sport Family';
  @override
  Engine createEngine() => SportEngine();
  @override
  Tire createTire() => SportTire();
}

class FamilyPartsFactory implements VehiclePartsFactory {
  @override
  String get label => 'Family Family';
  @override
  Engine createEngine() => FamilyEngine();
  @override
  Tire createTire() => FamilyTire();
}

class TruckPartsFactory implements VehiclePartsFactory {
  @override
  String get label => 'Truck Family';
  @override
  Engine createEngine() => TruckEngine();
  @override
  Tire createTire() => TruckTire();
}


