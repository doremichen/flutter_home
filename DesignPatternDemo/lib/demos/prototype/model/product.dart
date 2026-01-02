///
/// product.dart
/// Prototype
/// Specs
/// Vehicle
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
abstract class Prototype<T> {
  T clone(); // deep copy
}

/// --- specs：vehicle ----------------------------------------
class Specs {
  String color;
  int seats;
  List<String> features;

  Specs({
    required this.color,
    required this.seats,
    List<String>? features,
  }) : features = features != null ? List<String>.from(features) : <String>[];

  /// deep copy: copy + features list
  Specs clone() => Specs(
    color: color,
    seats: seats,
    features: List<String>.from(features),
  );

  @override
  String toString() =>
      'Specs(color: $color, seats: $seats, features: ${features.join(", ")})';
}

/// --- Product：vehicle ---------------------------------------------------
class Vehicle implements Prototype<Vehicle> {
  String model; // example：Sport-2000 / Family-Comfort / Truck-Heavy
  String type;  // example：Sport / Family / Truck
  Specs specs;

  Vehicle({
    required this.model,
    required this.type,
    required this.specs,
  });

  /// deep copy
  @override
  Vehicle clone() => Vehicle(
    model: model,
    type: type,
    specs: specs.clone(),
  );

  /// customize
  Vehicle copyWith({
    String? model,
    String? type,
    Specs? specs,
  }) =>
      Vehicle(
        model: model ?? this.model,
        type: type ?? this.type,
        specs: specs ?? this.specs.clone(),
      );

  @override
  String toString() => 'Vehicle(model: $model, type: $type, $specs)';
}