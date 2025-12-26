///
/// value_notifier_adapter.dart
/// ValueNotifierAdapter
///
/// Created by Adam Chen on 2025/12/24
/// Copyright © 2025 Abb company. All rights reserved
///
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../interface/observable_adapter.dart';
import '../model/log_event.dart';

class ValueNotifierAdapter implements ObservableAdapter<List<LogEvent>> {
  final _controller = StreamController<List<LogEvent>>.broadcast();
  final ValueNotifier<List<LogEvent>> _notifier = ValueNotifier<List<LogEvent>>([]);
  late final VoidCallback _listener;

  ValueNotifierAdapter() {
    _listener = () {
      _controller.add(List.unmodifiable(_notifier.value));
    };
    _notifier.addListener(_listener);
  }

  @override
  void add(List<LogEvent> value) {
    _notifier.value = List.unmodifiable(value);
  }

  void addItem(LogEvent event) {
    _notifier.value = List.unmodifiable([..._notifier.value, event]);
  }

  @override
  void clear() {
    _notifier.value = const [];
  }

  @override
  void dispose() {
    _notifier.removeListener(_listener);
    _controller.close();
  }

  @override
  Stream<List<LogEvent>> get stream => _controller.stream;


}