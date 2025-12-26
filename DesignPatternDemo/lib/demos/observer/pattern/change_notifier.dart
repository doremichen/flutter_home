///
/// change_notifier_adapter.dart
/// ChangeNotifierAdapter
///
/// Created by Adam Chen on 2025/12/24
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../interface/observable_adapter.dart';
import '../model/log_event.dart';

class ChangeNotifierAdapter extends ChangeNotifier 
    implements ObservableAdapter<List<LogEvent>> {
  // log event list
  final List<LogEvent> _events = [];
  // stream controller
  final _controller = StreamController<List<LogEvent>>.broadcast();

  @override
  Stream<List<LogEvent>> get stream => _controller.stream;

  ChangeNotifierAdapter() {
    addListener(
      () {
        // Synchronize the current list to the stream when call notifyListeners
        _controller.add(List.unmodifiable(_events));
      }
    );
  }


  @override
  void add(List<LogEvent> value) {
    _events.clear();
    _events.addAll(value);
    notifyListeners();
  }

  void addItem(LogEvent event) {
    _events.add(event);
    notifyListeners();
  }

  @override
  void clear() {
    _events.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}