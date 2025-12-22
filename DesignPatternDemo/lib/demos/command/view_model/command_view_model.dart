///
/// command_view_model.dart
/// CommandViewModel
///
/// Created by Adam Chen on 2025/12/22.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import '../model/calculator.dart';
import '../pattern/command.dart';
import '../pattern/command_invoker.dart';

class CommandViewModel extends ChangeNotifier {
  // Calculator
  final Calculator _cal = Calculator(initialValue: 0);
  final CommandInvoker _invoker = CommandInvoker();

  // input value
  double value = 10.0;
  String? _lastToast;
  final List<String> logs = [];

  // set amount
  void setAmount(double v) {
    value = v;
    notifyListeners();
  }

  String? get lastToast => _lastToast;
  set lastToast(String? v) {
    _lastToast = v;
    notifyListeners();
  }

  double get cal_value => _cal.value;
  List<String> get history => _invoker.history;


  // --- basic command ---
  void add() => _exec(AddCommand(_cal, value));
  void sub() => _exec(SubtractCommand(_cal, value));
  void mul() => _exec(MultiplyCommand(_cal, value));
  void div() => _exec(DivideCommand(_cal, value));
  void setValue(double v) => _exec(SetValueCommand(_cal, v));

  // macro command
  void macroBoost() {
    _exec(MacroCommand('Boost (+$value then ×2)', [
      AddCommand(_cal, value),
      MultiplyCommand(_cal, 2),
    ]));
  }
  void macroDiscount() {
    _exec(MacroCommand('Discount (÷2 then -$value)', [
      DivideCommand(_cal, 2),
      SubtractCommand(_cal, value),
    ]));
  }

  // --- Undo / Redo ---
  void undo() {
    final ok = _invoker.undo();
    _lastToast = ok ? 'Undo' : 'Nothing to undo';
    notifyListeners();
  }
  void redo() {
    final ok = _invoker.redo();
    _lastToast = ok ? 'Redo' : 'Nothing to redo';
    notifyListeners();
  }

  void clearAll() {
    _cal.value = 0;
    _invoker.clearHistory();
    logs.clear();
    _lastToast = 'All cleared';
    notifyListeners();
  }

  // --- helper ---
  void _exec(Command cmd) {
    final ok = _invoker.execute(cmd);
    _lastToast = ok ? 'OK: ${cmd.label}' : 'ERROR: ${cmd.label}';
    logs.add('${ok ? "[OK]" : "[ERR]"} ${cmd.label} → value=${_cal.value.toStringAsFixed(2)}');
    notifyListeners();
  }

}