///
/// product.dart
/// Vehicle
/// SportCar
/// FamilyCar
/// Truck
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
///
/// The Vehicle is interface for all vehicles.
///
abstract class Vehicle {
  String get name;
  int get wheels;
  String describe();
}

class SportCar implements Vehicle {
  @override
  String get name => '跑車';

  @override
  int get wheels => 4;
  @override
  String describe() => '$name — $wheels 車輪、高性能、雙座';
}

class FamilyCar implements Vehicle {
  @override
  String get name => '房車';
  @override
  int get wheels => 4;

  @override
  String describe() => '$name — $wheels 車輪、舒適性和安全性、5個座位';
}

class Truck implements Vehicle {
  @override
  String get name => '卡車';
  @override
  int get wheels => 6;
  @override
  String describe() => '$name — $wheels 輪子，重型貨物';
}