import 'package:flutter/material.dart';

///
/// singleton_demo.dart
/// AppLogger
/// SingletonDemoPage
///
/// Created by Adam Chen on 2025/12/10.
/// Copyright © 2025 Abb company. All rights reserved.
///
class AppLogger {
  // private constructor
  AppLogger._internal();
  // static instance
  static final AppLogger _instance = AppLogger._internal();
  // factory
  factory AppLogger() {
    return _instance;
  }

  // get
  static AppLogger get instance => _instance;

  // --- demo state and method
  final List<String> _messages = [];

  /// Logs a message with a timestamp.
  ///
  /// This method retrieves the current time in ISO 8601 format
  /// and appends the formatted log entry to the `_messages` list.
  /// Example: [2025-12-11T10:20:30.123Z] Some message
  void log(String msg) {
    // Get the current timestamp in ISO 8601 format (standard for logging)
    final time = DateTime.now().toIso8601String();

    // Add the timestamped message to the message list
    _messages.add('[$time] $msg');
  }

  List<String> get messages => List.unmodifiable(_messages);

  void clear() => _messages.clear();
}

/// A demo page that showcases the Singleton design pattern.
///
/// This widget represents a screen used to demonstrate how
/// the Singleton pattern works within the application.
class SingletonDemoPage extends StatefulWidget {
  /// Creates a new instance of [SingletonDemoPage].
  const SingletonDemoPage({super.key});

  @override
  State<SingletonDemoPage> createState() => _SingletonDemoPageState();
}

/// The state class for [SingletonDemoPage].
///
/// This class manages the UI and interactions for the Singleton demo page.
class _SingletonDemoPageState extends State<SingletonDemoPage> {
  // late initialization
  late final AppLogger _logger;
  List<String> _logs = [];


  @override
  void initState() {
    super.initState();
    // initialize logger
    _logger = AppLogger();
    _logs = _logger.messages;
  }

  void _addLog() {
    _logger.log('User tapped Log button (hash: ${_logger.hashCode})');
    // update ui
    setState(() {
      _logs = _logger.messages;
    });
  }

  void _clearLogs() {
    _logger.clear();
    setState(() {
      _logs = _logger.messages;
    });
  }

  void _refresh() {
    setState(() {
      _logs = _logger.messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hash = _logger.hashCode;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Singleton Demo'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            Text('Singleton instance hashCode: $hash',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),

            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _addLog,
                  icon: const Icon(Icons.add),
                  label: const Text('Log message'),
                ),
                ElevatedButton.icon(
                  onPressed: _clearLogs,
                  icon: const Icon(Icons.delete),
                  label: const Text('Clear logs'),
                ),
                OutlinedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),

            const Divider(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Messages:', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            // log list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _logs.length,
                separatorBuilder: (_, __) => const Divider(height: 12),
                itemBuilder: (_, index) => Text(_logs[index]),
              ),
            ),

          ],
        ),
    );

  }
}

