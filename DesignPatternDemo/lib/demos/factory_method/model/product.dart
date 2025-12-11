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
  String get name => 'Sport Car';

  @override
  int get wheels => 4;
  @override
  String describe() => '$name — $wheels wheels, high-performance, 2 seats';
}

class FamilyCar implements Vehicle {
  @override
  String get name => 'Family Car';
  @override
  int get wheels => 4;

  @override
  String describe() => '$name — $wheels wheels, comfort & safety, 5 seats';
}

class Truck implements Vehicle {
  @override
  String get name => 'Truck';
  @override
  int get wheels => 6;
  @override
  String describe() => '$name — $wheels wheels, heavy-duty cargo';
}