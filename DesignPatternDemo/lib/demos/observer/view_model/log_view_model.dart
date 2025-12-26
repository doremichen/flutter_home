///
/// log_view_model.dart
/// LogViewModel
///
/// Created by Adam Chen on 2025/12/24
/// Copyright © 2025 Abb company. All rights reserved
///
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart.';

import '../interface/observable_adapter.dart';
import '../model/log_event.dart';
import '../pattern/change_notifier.dart';
import '../pattern/stream.dart';
import '../pattern/value_notifier.dart';

enum AdapterType { changeNotifier, stream, valueNotifier }

class LogViewModel extends ChangeNotifier {
  AdapterType selected = AdapterType.changeNotifier;
  ObservableAdapter<List<LogEvent>>? _adapter;
  StreamSubscription<List<LogEvent>>? _subscription;

  List<LogEvent> events = [];
  bool auto = false;
  Timer? _timer;

  String? lastToast;

  LogViewModel() {
    _switchAdapter(AdapterType.changeNotifier);
  }

  void _switchAdapter(AdapterType type) {
    // initial
    _subscription?.cancel();
    _adapter?.dispose();

    switch (type) {
      case AdapterType.changeNotifier:
        _adapter = ChangeNotifierAdapter();
        break;
      case AdapterType.stream:
        _adapter = StreamAdapter();
        break;
      case AdapterType.valueNotifier:
        _adapter = ValueNotifierAdapter();
        break;
    }
    selected = type;
    _subscription = _adapter?.stream.listen((events) {
      this.events.clear();
      this.events.addAll(events);
      notifyListeners();
    });
    // initial synch
    _adapter?.add(this.events);
    lastToast = 'Adapter: $selected';
    notifyListeners();
  }

  void selectAdapter(AdapterType type) {
    if (type == selected) {
      return;
    }
    _switchAdapter(type);
  }

  void addEvent() {
    final msg = _randomMessage();
    final e = LogEvent(msg);
    events.add(e);
    _adapter?.add(events);
    lastToast = 'Event: $msg';
    notifyListeners();
  }

  void clear() {
    events.clear();
    _adapter?.clear();
    lastToast = 'Events cleared';
    notifyListeners();
  }

  void toggleAuto() {
    auto = !auto;
    _timer?.cancel();
    if (auto) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        addEvent();
      });
    }
    lastToast = 'Auto: $auto';
    notifyListeners();
  }

  _randomMessage() {
    const samples = [
      '資料更新',
      '新通知到達',
      '使用者點擊',
      '系統背景事件',
      '網路回應',
      '定時器觸發',
    ];
    final i = Random().nextInt(samples.length);
    return samples[i];
  }

  // dispose
  @override
  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();
    _adapter?.dispose();
    super.dispose();
  }

}