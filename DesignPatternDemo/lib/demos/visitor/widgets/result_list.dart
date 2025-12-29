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
      margin: const EdgeInsets.all(12),
      child: SizedBox(
        height: 360,
        child: Column(
          children: [
            if (output != null)
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Visitor 輸出（前 6 行）'),
                subtitle: Text(output.take(6).join('\n')),
              ),
            const Divider(height: 1),
            Expanded(
              child: logs.isEmpty
                  ? const Center(child: Text('尚無日誌，請在上方產生圖形並執行 Visitor'))
                  : ListView.separated(
                itemCount: logs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final e = logs[index];
                  return ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: Text(e.message),
                    subtitle: Text(e.timestamp.toLocal().toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}