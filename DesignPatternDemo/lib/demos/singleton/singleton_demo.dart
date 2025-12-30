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
      extendBody: false,
      body: SafeArea(
        // bottom: true 確保避開手機底部的導覽列
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// --- 上半部：標題與按鈕 (保持原樣) ---
                SingleChildScrollView(
                  child: _buildHeader(hash),
                ),

                const Divider(height: 32),
                /// --- 下半部：Log 清單 (加入底部緩衝區) ---
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _logs.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                      // 關鍵點：在清單底部增加內縮，確保最後一條 Log 不會貼死邊緣
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 40),
                      itemCount: _logs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) => _buildLogItem(_logs[index], index),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int hash) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        /// --- Demo 目的說明卡片 ---
        _InfoBanner(
          title: 'Singleton 模式展示',
          lines: const [
            '確保全域僅有一個實例，共享應用狀態。',
            '下方 hashCode 若相同，代表為同一個物件。',
          ],
        ),
        const SizedBox(height: 20),

        /// --- 狀態與 HashCode ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '活動日誌 (Logs)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'ID: $hash',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        /// --- 控制按鈕組 ---
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildActionButton(
              icon: Icons.add_circle_outline,
              label: '新增',
              onPressed: _addLog,
              color: Colors.blue,
            ),
            _buildActionButton(
              icon: Icons.delete_sweep_outlined,
              label: '清空',
              onPressed: _clearLogs,
              color: Colors.redAccent,
            ),
            _buildActionButton(
              icon: Icons.refresh_rounded,
              label: '重新整理',
              onPressed: _refresh,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ],
    );
  }

  // 輔助按鈕小組件
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // 輔助方法：Log 項目樣式優化
  Widget _buildLogItem(String message, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 索引編號
          Text(
            '#${index + 1}'.padRight(4),
            style: TextStyle(
              color: Colors.blue.shade300,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 8),
          // Log 內容
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 輔助方法：空狀態顯示
  Widget _buildEmptyState() {
    return const Center(
      child: Text('目前沒有任何日誌', style: TextStyle(color: Colors.grey)),
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

