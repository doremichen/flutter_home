///
/// decorator_view_model.dart
/// DecoratorViewModel
///
/// Created by Adam Chen on 2025/12/16.
/// Copyright © 2025 Abb company. All rights reserved.
///

import '../model/beverage.dart';
import 'package:flutter/material.dart';

import '../pattern/decorators.dart';

// provide ui to show information
class LineItem {
  final String label;
  final double price;
  LineItem({required this.label, required this.price});
}

enum BaseKind { espresso, house, dark }
enum DecoratorKind { milk, mocha, whip, soy, sugar }

class DecoratorViewModel extends ChangeNotifier {

  BaseKind selectedBase = BaseKind.espresso;
  Beverage _current = Espresso();

  // applied
  final List<DecoratorKind> applied = [];
  final List<String> logs = [];
  String? _lastToast;

  // get last toast
  String? takeLastToast() {
    final m = _lastToast;
    _lastToast = null;
    return m;
  }

  // base kind select
  void selectBase(BaseKind kind) {
    if (selectedBase == kind) return;
    selectedBase = kind;
    _current = _createBeverage(kind);
    applied.clear();
    _log('選取：${_current.describe()}');
    _lastToast = 'Selected: ${_current.describe()}';
    notifyListeners();
  }

  // apply decorator
  void applyDecorator(DecoratorKind kind) {
    _current = _wrap(_current, kind);
    applied.add(kind);
    _log('套用裝飾：${_label(kind)} → ${_current.describe()}');
    _lastToast = 'Add ${_label(kind)}';
    notifyListeners();
  }

  // undo last decorator
  void undoLast() {
    if (applied.isEmpty) return;
    final removed = applied.removeLast();
    // apply decorator
    _current = switch (selectedBase) {
      BaseKind.espresso => Espresso(),
      BaseKind.house => HouseBlend(),
      BaseKind.dark => DarkRoast(),
    };

    for (final kind in applied) {
      _current = _wrap(_current, kind);
    }
    _log('取消套用：${_label(removed)} → ${_current.describe()}');
    _lastToast = 'Undo ${_label(removed)}';
    notifyListeners();
  }

  // clear all decorator
  void clearDecorators() {
    applied.clear();
    _current = switch (selectedBase) {
      BaseKind.espresso => Espresso(),
      BaseKind.house => HouseBlend(),
      BaseKind.dark => DarkRoast(),
    };
    _log('清除所有裝飾，保留基底：${_current.name}');
    _lastToast = 'Cleared';
    notifyListeners();
  }

  // calculate total price
  List<LineItem> get breakdown {
    final items = <LineItem>[];
    final basePrice = switch (selectedBase) {
      BaseKind.espresso => 60.0,
      BaseKind.house => 50.0,
      BaseKind.dark => 55.0,
    };
    items.add(LineItem(label: 'Base: ${_current.describe().split(' + ').first}', price: basePrice));

    for (final k in applied) {
      items.add(LineItem(label: '+ ${_label(k)}', price: _price(k)));
    }
    return items;

  }

  VoidCallback? get clearLogs => logs.isEmpty ? null : () => logs.clear();
  String get description => _current.describe();
  double get totalCost => _current.cost();

  // --- helper ---
  Beverage _createBeverage(BaseKind kind) {
    switch (kind) {
      case BaseKind.espresso:
        return Espresso();
      case BaseKind.house:
        return HouseBlend();
      case BaseKind.dark:
        return DarkRoast();
    }
  }

  void _log(String s) {
    logs.add(s);
  }

  Beverage _wrap(Beverage current, DecoratorKind kind) {
    switch (kind) {
      case DecoratorKind.milk:
        return MilkDecorator(current);
      case DecoratorKind.mocha:
        return MochaDecorator(current);
        case DecoratorKind.whip:
        return WhipDecorator(current);
      case DecoratorKind.soy:
        return SoyDecorator(current);
      case DecoratorKind.sugar:
        return SugarDecorator(current);
    }
  }

  _label(DecoratorKind kind) {
    return switch (kind){
      DecoratorKind.milk => 'Milk (+10)',
      DecoratorKind.mocha => 'Mocha (+15)',
      DecoratorKind.whip => 'Whip (+12)',
      DecoratorKind.soy => 'Soy (+8)',
      DecoratorKind.sugar => 'Sugar (+2)',
    };
  }

  double _price(DecoratorKind k) {
    return switch (k) {
      DecoratorKind.milk => 10.0,
      DecoratorKind.mocha => 15.0,
      DecoratorKind.whip => 12.0,
      DecoratorKind.soy => 8.0,
      DecoratorKind.sugar => 2.0,
    };
  }

}