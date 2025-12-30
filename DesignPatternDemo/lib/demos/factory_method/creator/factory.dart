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
    String get label => '打造跑車';
    @override
    Vehicle create() => SportCar();
}

class FamilyCarFactory implements VehicleFactory {
    @override
    String get label => '創建家庭用車';
    @override
    Vehicle create() => FamilyCar();
}

class TruckFactory implements VehicleFactory {
    @override
    String get label => '創建卡車';
    @override
    Vehicle create() => Truck();
}