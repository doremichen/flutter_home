///
/// log_event.dart
/// LogEvent
///
/// Created by Adam Chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved
///
class LogEvent {
  final DateTime timestamp;
  final String message;
  LogEvent(this.message) : timestamp = DateTime.now();
  @override
  String toString() => '[${timestamp.toIso8601String()}] $message';
}