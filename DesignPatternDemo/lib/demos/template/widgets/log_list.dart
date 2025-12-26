///
/// log_list.dart
/// LogList
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/report_view_model.dart';

class LogList extends StatelessWidget {

  const LogList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportViewModel>();
    final logs = vm.logs;
    final lines = vm.lines;

    return Card(
        margin: const EdgeInsets.all(12),
        child: SizedBox(
          height: 360,
          child: Column(
            children: [
              if (lines != null)
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('報表輸出（前 4 行）'),
                  subtitle: Text(lines.take(4).join('\n')),
                ),
              const Divider(height: 1),
              Expanded(
                child: logs.isEmpty
                    ? const Center(child: Text('尚無日誌，請在上方執行模板'))
                    : ListView.separated(
                  itemCount: logs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final log = logs[index];
                    return ListTile(
                      leading: const Icon(Icons.article_outlined),
                      title: Text(log.message),
                      subtitle: Text(log.timestamp.toLocal().toString()),
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