///
/// log_list.dart
/// LogList
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import '../model/log_event.dart';
import '../view_model/sort_view_model.dart';

class LogList extends StatelessWidget {

  const LogList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SortViewModel>();
    final List<LogEvent> items = vm.logs;

    return Card(
        margin: const EdgeInsets.all(12),
        child: SizedBox(
          height: 360,
          child: items.isEmpty
              ? const Center(child: Text('尚無日誌，請在上方產生資料並執行策略'))
              : ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final e = items[index];
              return ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(e.message),
                subtitle: Text(e.timestamp.toLocal().toString()),
              );
            },
          ),
        ),
    );
  }
}