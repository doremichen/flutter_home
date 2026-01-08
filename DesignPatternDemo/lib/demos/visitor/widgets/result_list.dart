///
/// result_list.dart
/// ResultList
///
/// Created by Adam Chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/shape_view_model.dart';

class ResultList extends StatelessWidget {
  const ResultList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShapeViewModel>();
    final output = vm.outputLines;
    final logs = vm.logs;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          if (output != null && output.isNotEmpty)
            _buildSummary(context, output),
          // const Divider(height: 1),
          // Expanded(
          //   child: logs.isEmpty
          //       ? const Center(child: Text('尚無日誌，請在上方產生圖形並執行 Visitor'))
          //       : ListView.separated(
          //     itemCount: logs.length,
          //     separatorBuilder: (_, __) => const Divider(height: 1),
          //     itemBuilder: (context, index) {
          //       final e = logs[index];
          //       return ListTile(
          //         leading: const Icon(Icons.article_outlined),
          //         title: Text(e.message),
          //         subtitle: Text(e.timestamp.toLocal().toString()),
          //       );
          //     },
          //   ),
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
        title: const Text('Visitor輸出', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          lines.take(6).join('\n'),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        ),
      ),
    );
  }
}