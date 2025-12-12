///
/// prototypeViewModel.dart
/// PrototypeViewModel
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import '../creator/prototype_registry.dart';
import '../model/product.dart';

class PrototypeViewModel extends ChangeNotifier {
    final PrototypeRegistry _registry;

    // Ui state
    int selectedIndex = 0;
    String nameSuffix = '';
    String color = '';
    int seats = 0;
    final List<String> customizationFeatures = [];

    // result/log
    final List<Vehicle> _created = [];
    final List<String> _logs = [];
    String? _lastToast;

    // Constructor
    PrototypeViewModel({PrototypeRegistry? registry})
        : _registry = registry ?? defaultVehicleRegistry() {
      _syncCustomizationWithCurrentTemplate();
    }

    List<String> get keys => _registry.keys;

    Vehicle get currentTemplate => _registry.template(keys[selectedIndex]);


    List<Vehicle> get created => _created;
    List<String> get logs => _logs;



    String? takeLastToast() {
      final toast = _lastToast;
      _lastToast = null;
      return toast;
    }

    void selectPrototype(int index) {
      selectedIndex = index;
      _log('select prototype：${keys[index]}');
      _syncCustomizationWithCurrentTemplate();
      notifyListeners();
    }

    void setNameSuffix(String v) {
      nameSuffix = v;
      notifyListeners();
    }

    void setColor(String v) {
      color = v;
      notifyListeners();
    }

    void setSeats(int v) {
      seats = v;
      notifyListeners();
    }

    void addFeature(String v) {
      // empty check
      if (v.trim().isEmpty) return;

      customizationFeatures.add(v.trim());
      _log('new customization feature：$v');
      notifyListeners();
    }

    void removeFeatureAt(int id) {
      // boundary check
      if (id < 0 || id >= customizationFeatures.length) return;

      customizationFeatures.removeAt(id);
      _log('remove customization feature：$id');
      notifyListeners();
    }


    void resetCustomization() {
      customizationFeatures.clear();
      _log('reset customization');
      notifyListeners();
    }

    void cloneWithCustomization() {
      final key = keys[selectedIndex];
      final base = _registry.createClone(key); // deep copy
      // new spec
      final specs = base.specs.clone()
        ..color = color
        ..seats = seats
        ..features.addAll(customizationFeatures);

      final suffixed = (nameSuffix.trim().isEmpty)
          ? base.model
          : '${base.model}-${nameSuffix.trim()}';

      // new vehicle
      final cloned = base.copyWith(
        model: suffixed,
        specs: specs,
      );

      _created.add(cloned);
      _log('clone form [$key] to：$cloned');
      _lastToast = 'Created: ${cloned.model} clone form [$key] to：$cloned';
      notifyListeners();
    }

    void clearAll() {
      _created.clear();
      _log('Clean all created clones');
      _lastToast = 'Cleared';
      notifyListeners();

    }

    // ---- helpers ---------------------------
    void _syncCustomizationWithCurrentTemplate() {
      final template = currentTemplate;
      color = template.specs.color;
      seats = template.specs.seats;
      customizationFeatures.clear();
      customizationFeatures.addAll(template.specs.features);

    }

    void _log(String s) {
      _logs.add(s);
    }


}