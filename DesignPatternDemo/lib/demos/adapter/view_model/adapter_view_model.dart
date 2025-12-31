///
/// adapter.dart
/// AdapterDemoPage
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import '../model/legacy_sensors.dart';
import '../model/measurement.dart';
import '../model/target.dart';
import '../pattern/adapters.dart';

class AdapterItem {
  final String label;
  final String formula;
  final MeasurementReader reader;

  AdapterItem({required this.label, required this.formula, required this.reader});
}

class AdapterViewModel extends ChangeNotifier {
  final List<AdapterItem> adapters;
  int selectedIndex = 0;

  final List<Measurement> results = [];
  final List<String> logs = [];
  String? _lastToast;

  AdapterViewModel({List<AdapterItem>? adapters})
      : adapters = adapters ?? [
    AdapterItem(
      label: SpeedAdapter(LegacyMphSpeedSensor()).label,
      formula: SpeedAdapter(LegacyMphSpeedSensor()).formula,
      reader: SpeedAdapter(LegacyMphSpeedSensor()),
    ),
    AdapterItem(
      label: TemperatureAdapter(LegacyFahrenheitThermometer()).label,
      formula: TemperatureAdapter(LegacyFahrenheitThermometer()).formula,
      reader: TemperatureAdapter(LegacyFahrenheitThermometer()),
    ),
  ];

  AdapterItem get current => adapters[selectedIndex];

  String? takeLastToast() {
    final m = _lastToast;
    _lastToast = null;
    return m;
  }

  void selectAdapter(int index) {
    selectedIndex = index;
    _log('選擇 Adapter：${current.label}');
    notifyListeners();
  }

  void readOnce() {
    final m = current.reader.read();
    results.add(m);
    _log('讀取一次 → $m');
    _lastToast = '${m.kind} = ${m.new_value.toStringAsFixed(2)} ${m.unit}';
    notifyListeners();
  }

  void readBatch(int times) {
    for (var i = 0; i < times; i++) {
      results.add(current.reader.read());
    }
    _log('批次讀取 $times 次，Adapter = ${current.label}');
    _lastToast = 'Read $times';
    notifyListeners();
  }

  void clearAll() {
    results.clear();
    _log('清除所有量測結果');
    _lastToast = 'Cleared';
    notifyListeners();
  }

  void _log(String m) => logs.add(m);
}