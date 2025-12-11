///
/// factory_view_model.dart
/// FactoryViewModel
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///

import 'package:flutter/material.dart';

import '../creator/factory.dart';
import '../model/product.dart';

class FactoryViewModel extends ChangeNotifier {
    final List<Vehicle> _created = [];
    List<Vehicle> get created => List.unmodifiable(_created);

    String? _lastToast;
    String? takeLastToast() {
      final toast = _lastToast;
      _lastToast = null;
      return toast;
    }

    void createVehicle(VehicleFactory factory) {
      final v = factory.create();
      _created.add(v);
      _lastToast = 'Created: ${v.name}';
      notifyListeners();
    }

    void clearAll() {
      _created.clear();
      _lastToast = 'Cleared all vehicles';
      notifyListeners();
    }

}