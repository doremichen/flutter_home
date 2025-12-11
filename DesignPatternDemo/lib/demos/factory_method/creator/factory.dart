///
/// creator.dart
/// VehicleFactory
/// SportCarFactory
/// FamilyCarFactory
/// TruckFactory
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///

import 'package:design_pattern_demo/demos/factory_method/model/product.dart';
///
/// The VehicleFactory is interface for all factories.
///
abstract class VehicleFactory {
  String get label;
  Vehicle create();
}

class SportCarFactory implements VehicleFactory {
    @override
    String get label => 'Create Sport Car';
    @override
    Vehicle create() => SportCar();
}

class FamilyCarFactory implements VehicleFactory {
    @override
    String get label => 'Create Family Car';
    @override
    Vehicle create() => FamilyCar();
}

class TruckFactory implements VehicleFactory {
    @override
    String get label => 'Create Truck';
    @override
    Vehicle create() => Truck();
}