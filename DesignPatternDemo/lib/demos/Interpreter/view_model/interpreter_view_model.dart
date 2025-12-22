///
/// interpreter_view_model.dart
/// InterpreterViewModel
///
/// Created by Adam Chen on 2025/12/22
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import '../model/tokens.dart';
import '../pattern/interpreter.dart';

class InterpreterViewModel extends ChangeNotifier {
  // interpreter
  final _interpreter = Interpreter();

  String program = '''
    // Example: 
    x = 3; y = 2 * x; 
    max(y, 10) + abs(-5) - 1;
    '''.trim();
  double? lastValue;
  Map<String, double> env = {};
  List<Token> tokens = [];
  String ast = '';

  List<String> logs = [];
  String? lastToast;

  void setProgram(String src) {
    program = src;
    notifyListeners();
  }
   void run() {
     final res = _interpreter.run(program);
     lastValue = res.lastValue;
     env = res.env;
     tokens = res.tokens;
     ast = res.astPretty;
     logs.add('Run at ${DateTime.now()}');

     if (res.errors.isNotEmpty) {
       lastToast = 'ERROR';
       logs.addAll(res.errors);
     } else {
       lastToast = 'OK';
     }
     notifyListeners();

   }

  void clearAll() {
    lastValue = null;
    env = {};
    tokens = [];
    ast = '';
    logs.clear();
    lastToast = 'Cleared';
    notifyListeners();
  }


}