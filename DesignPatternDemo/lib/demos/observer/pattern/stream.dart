///
/// stream_adapter.dart
/// StreamAdapter
///
/// Created by Adam Chen on 2025/12/24
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'dart:async';

import '../interface/observable_adapter.dart';
import '../model/log_event.dart';

class StreamAdapter implements ObservableAdapter<List<LogEvent>> {
  final List<LogEvent> _events = [];
  final _controller = StreamController<List<LogEvent>>.broadcast();

  @override
  void add(List<LogEvent> value) {
    _events.clear();
    _events.addAll(value);
    _controller.add(List.unmodifiable(_events));
  }

  void addItem(LogEvent event) {
    _events.add(event);
    _controller.add(List.unmodifiable(_events));
  }

  @override
  void clear() {
    _events.clear();
    _controller.add(List.unmodifiable(_events));
  }

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Stream<List<LogEvent>> get stream => _controller.stream;

}