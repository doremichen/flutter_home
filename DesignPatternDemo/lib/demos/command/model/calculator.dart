///
/// calculator.dart
/// Calculator
///
/// Created by Adam Chen on 2025/12/22.
/// Copyright © 2025 Abb company. All rights reserved.
///
class Calculator {
  double _value;
  Calculator({double initialValue = 0}): _value = initialValue;

  set value(double val) {
    _value = val;
  }

  double get value {
    double val = _value;
    return val;
  }

  @override
  String toString() => 'Calculator(value=${_value.toStringAsFixed(2)})';

}