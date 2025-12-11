///
/// abstractory_factory_view_model.dart
/// AbstractFactoryViewModel
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import '../creator/abstract_factory.dart';

class AbstractFactoryViewModel extends ChangeNotifier {
    final List<VehiclePartsFactory> factories;
    int selectedIndex;
    final List<String> _createdSets = [];

    AbstractFactoryViewModel({required this.factories, this.selectedIndex = 0});

    List<String> get createdSets => List.unmodifiable(_createdSets);
    VehiclePartsFactory get selectedFactory => factories[selectedIndex];


    String? _lastToast;
    String? takeLastToast() {
      final m = _lastToast; _lastToast = null; return m;
    }

    void selectFactory(int id) {
      selectedIndex = id;
      notifyListeners();
    }

    void createMatchedSet() {
      final engine = selectedFactory.createEngine();
      final tire = selectedFactory.createTire();
      final line = '${selectedFactory.label}:\n  - ${engine.spec()}\n  - ${tire.spec()}';
      // add
      _createdSets.add(line);
      _lastToast = 'Created set for ${selectedFactory.label}';
      notifyListeners();
    }

    void clearAll() {
      _createdSets.clear();
      _lastToast = 'Cleared all sets';
      notifyListeners();
    }

}