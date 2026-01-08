///
/// log_list.dart
/// LogList
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:design_pattern_demo/demos/template/model/log_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/report_view_model.dart';

class LogList extends StatelessWidget {

  const LogList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportViewModel>();
    final lines = vm.lines;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (lines != null && lines.isNotEmpty)
              _buildSummary(context, lines),
            // const Divider(height: 1),
            // Expanded(
            //   child: _buildLogList(context, logs),
            // ),
          ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, List<String> lines) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 130), // limit height to 120
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.description_outlined, color: Colors.blue),
        title: const Text('報表摘要輸出', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          lines.take(4).join('\n'),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildLogList(BuildContext context, List<LogEvent> logs) {
    if (logs.isEmpty) {
      return const Center(child: Text('尚無日誌，請在上方執行模板'));
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: logs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final log = logs[index];
        return ListTile(
          dense: true,
          leading: const Icon(Icons.article_outlined, size: 20),
          title: Text(log.message, style: const TextStyle(fontSize: 13)),
          subtitle: Text(
            log.timestamp.toLocal().toString().split('.').first,
            style: const TextStyle(fontSize: 11),
          ),
        );
      },
    );
  }
}