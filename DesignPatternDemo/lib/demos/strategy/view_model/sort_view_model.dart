///
/// sort_view_model.dart
/// SortViewModel
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../interface/sort_strategy.dart';
import '../model/log_event.dart';
import '../pattern/insertion_sort.dart';
import '../pattern/merge_sort.dart';
import '../pattern/quick_sort.dart';

enum StrategyType { quickSort, mergeSort, insertionSort }

class SortViewModel extends ChangeNotifier {
  SortStrategy? _strategy;
  StrategyType _selected = StrategyType.quickSort;

  // Ui state
  List<int> _input = [];
  List<int>? _output;
  List<LogEvent> _logs = [];
  String? lastToast;

  bool _auto = false;
  Timer? _timer;

  SortViewModel() {
    _switchStrategy(StrategyType.quickSort);
    generateData();
  }

  // getters
  StrategyType get selectedType => _selected;
  String? get strategyName => _strategy?.name;
  List<int> get input => List.unmodifiable(_input);
  List<int>? get output => _output == null ? null : List.unmodifiable(_output!);
  List<LogEvent> get logs => List.unmodifiable(_logs);
  bool get auto => _auto;

  void selectStrategy(StrategyType type) {
    if (type == _selected) {
      return;
    }
    _switchStrategy(type);
  }

  void runStrategy() {
    if (_strategy == null) {
      _appendLog('尚未選擇策略');
      notifyListeners();
      return;
    }
    if (_input.isEmpty) {
      _appendLog('無資料可排序，請先產生資料');
      notifyListeners();
      return;
    }
    final res = _strategy?.sort(_input);
    _output = res!.output;
    for (final line in res.logs) {
      _logs.add(LogEvent(line));
    }
    _appendLog('執行策略：${_strategy?.name}');
    lastToast = '執行策略：${_strategy?.name}';
    notifyListeners();
  }

  void clear() {
    _logs = [];
    _output = null;
    _appendLog('清空結果與日誌');
    lastToast = '清空結果與日誌';
    notifyListeners();
  }

  void toggleAuto() {
    _auto = !_auto;
    _timer?.cancel();

    if (_auto) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        // random generate data or run strategy
        final rnd = Random().nextBool();
        if (rnd) {
          generateData(count: 8 + Random().nextInt(8));
        } else {
          runStrategy();
        }
      });
    }

    lastToast = '自動模式：$_auto';
    notifyListeners();
  }

  // dispose
  @override
  void dispose() {
    _timer?.cancel();
    _strategy = null;
    super.dispose();
  }

  void _switchStrategy(StrategyType type) {
    // create new strategy and bind log to vm
    _strategy = switch (type) {
      StrategyType.quickSort => QuickSort(),
      StrategyType.mergeSort => MergeSort(),
      StrategyType.insertionSort => InsertionSort(),
    };
    _selected = type;
    _appendLog('切換策略：${_strategy?.name}');
    lastToast = '切換策略：${_strategy?.name}';
    notifyListeners();
    }

  void _appendLog(String s) {
    _logs.add(LogEvent(s));
  }

  void generateData({int count = 10, int maxValue = 99}) {
    final rnd = Random();
    _input = List<int>.generate(count, (_) => rnd.nextInt(maxValue + 1));
    _output = null;
    _appendLog('產生資料：$_input');
    notifyListeners();
  }





}