import 'package:flutter/material.dart';

///
/// singleton_demo.dart
/// AppLogger
/// SingletonDemoPage
///
/// Created by Adam Chen on 2025/12/11.
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
  late final AppLogger _logger;
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _logger = AppLogger(); // Singleton instance
    _logs = _logger.messages;
  }

  void _addLog() {
    _logger.log('User tapped Log button (hash: ${_logger.hashCode})');
    setState(() => _logs = _logger.messages);
  }

  void _clearLogs() {
    _logger.clear();
    setState(() => _logs = _logger.messages);
  }

  void _refresh() {
    setState(() => _logs = _logger.messages);
  }

  @override
  Widget build(BuildContext context) {
    final hash = _logger.hashCode;
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Singleton Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// --- 新增：Demo 目的說明 ---
            _InfoBanner(
              title: '此 Demo 的目的',
              lines: const [
                '展示 Singleton 模式如何確保全域僅有一個實例，並在整個應用中共享狀態。',
                '此範例使用 AppLogger 作為 Singleton，所有操作（新增、清除、刷新）都作用於同一個實例。',
                '透過 hashCode 可驗證每次操作使用的都是同一個物件。',
              ],
            ),
            const SizedBox(height: 16),

            /// --- 顯示 Singleton hashCode ---
            Text(
              'Singleton instance hashCode: $hash',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            /// --- 控制按鈕 ---
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

            /// --- 標題 ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Messages:', style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            /// --- Log 清單 ---
            Expanded(
              child: Card(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _logs.length,
                  separatorBuilder: (_, __) => const Divider(height: 12),
                  itemBuilder: (_, index) => Text(_logs[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- Demo 說明卡元件（與其他頁一致） ---
class _InfoBanner extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _InfoBanner({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = theme.textTheme.bodyMedium;

    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (titleStyle != null) Text(title, style: titleStyle),
            const SizedBox(height: 8),
            ...lines.map(
                  (t) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(t, style: bodyStyle)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

