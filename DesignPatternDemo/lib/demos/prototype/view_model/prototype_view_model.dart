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

  // UI State
  int selectedIndex = 0;
  String nameSuffix = '';
  String color = '';
  int seats = 0;
  final List<String> customizationFeatures = [];

  // Result / Logs
  final List<Vehicle> _created = [];
  final List<String> _logs = [];
  String? _lastToast;

  PrototypeViewModel({PrototypeRegistry? registry})
      : _registry = registry ?? defaultVehicleRegistry() {
    _syncCustomizationWithCurrentTemplate();
  }

  // --- Getters ---
  List<String> get keys => _registry.keys;

  // 核心修正：提供 View 使用的選中名稱
  String get selectedPrototypeName => keys.isNotEmpty ? keys[selectedIndex] : 'Unknown';

  Vehicle get currentTemplate => _registry.template(keys[selectedIndex]);

  List<Vehicle> get created => _created;
  List<String> get logs => _logs;

  // --- Logic ---

  void selectPrototype(int index) {
    if (index < 0 || index >= keys.length) return;
    selectedIndex = index;
    nameSuffix = ''; // 關鍵修正：換原型時清空後綴，避免名稱混亂
    _log('選擇原型：${keys[index]}');
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
    final cleanValue = v.trim();
    if (cleanValue.isEmpty) return;
    customizationFeatures.add(cleanValue);
    _log('新增自定義特徵：$cleanValue');
    notifyListeners();
  }

  void removeFeatureAt(int id) {
    if (id < 0 || id >= customizationFeatures.length) return;
    final removed = customizationFeatures.removeAt(id);
    _log('移除自定義特徵：$removed');
    notifyListeners();
  }

  void resetCustomization() {
    nameSuffix = ''; // 同步重置後綴
    selectedIndex = 0;
    _syncCustomizationWithCurrentTemplate(); // 回歸到當前原型的初始狀態
    _log('重置為原型預設值');
    _lastToast = '已重置為原型預設值';
    notifyListeners();
  }

  void cloneWithCustomization() {
    final key = keys[selectedIndex];

    // 1. 從註冊表獲取深拷貝的原型基礎
    final base = _registry.createClone(key);

    // 2. 建立全新的規格物件 (Deep Copy)
    // 這裡假設 base.specs.clone() 已經實作了深拷貝
    final specs = base.specs.clone()
      ..color = color
      ..seats = seats
      ..features.clear() // 先清空，再加入目前 UI 上的特徵清單
      ..features.addAll(List.from(customizationFeatures));

    // 3. 處理名稱後綴
    final finalModelName = (nameSuffix.trim().isEmpty)
        ? base.model
        : '${base.model}-${nameSuffix.trim()}';

    // 4. 產生最終克隆體
    final cloned = base.copyWith(
      model: finalModelName,
      specs: specs,
    );

    _created.add(cloned);
    _log('成功克隆 [$key] -> $finalModelName');
    _lastToast = '已建立克隆：$finalModelName';
    notifyListeners();
  }

  void clearAll() {
    _created.clear();
    _log('清空所有車庫紀錄');
    _lastToast = '車庫已清空';
    notifyListeners();
  }

  // --- Helpers ---

  void _syncCustomizationWithCurrentTemplate() {
    final template = currentTemplate;
    color = template.specs.color;
    seats = template.specs.seats;

    // 確保特徵清單是獨立的副本
    customizationFeatures.clear();
    customizationFeatures.addAll(List.from(template.specs.features));
  }

  void _log(String s) {
    _logs.add('[${DateTime.now().toString().substring(11, 19)}] $s');
  }

  String? takeLastToast() {
    final toast = _lastToast;
    _lastToast = null;
    return toast;
  }
}