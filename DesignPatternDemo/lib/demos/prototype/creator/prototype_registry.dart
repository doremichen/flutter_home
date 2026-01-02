///
/// prototype_registry.dart
/// PrototypeRegistry
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../model/product.dart';

class PrototypeRegistry {

  final Map<String, Vehicle> _templates;

  PrototypeRegistry(this._templates);

  List<String> get keys => _templates.keys.toList(growable: false);

  Vehicle template(String key) => _templates[key]!;

  Vehicle createClone(String key) => _templates[key]!.clone();
}

// define default template
PrototypeRegistry defaultVehicleRegistry() {
  return PrototypeRegistry({
    'Sport': Vehicle(
      model: 'Sport-2000',
      type: 'Sport',
      specs: Specs(color: 'Red', seats: 2, features: ['Turbo', 'Sport ABS']),
    ),
    'Family': Vehicle(
      model: 'Family-Comfort',
      type: 'Family',
      specs: Specs(color: 'Blue', seats: 5, features: ['Isofix', 'Eco Mode']),
    ),
    'Truck': Vehicle(
      model: 'Truck-Heavy',
      type: 'Truck',
      specs: Specs(color: 'White', seats: 3, features: ['Lift Assist', 'Tow']),
    ),
  });
}
