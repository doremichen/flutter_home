///
/// log_list.dart
/// LogList
///
/// Created by Adam Chen on 2025/12/24
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/log_event.dart';
import '../view_model/log_view_model.dart';

class LogList extends StatelessWidget {
  const LogList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LogViewModel>();
    final List<LogEvent> items = vm.events;
    return Card(
        margin: const EdgeInsets.all(12),
        child: SizedBox(
          height: 360,
          child: items.isEmpty
              ? const Center(child: Text('尚無事件，請在上方新增或啟用自動模式'))
              : ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final e = items[index];
              return ListTile(
                leading: const Icon(Icons.bolt_outlined),
                title: Text(e.message),
                subtitle: Text(e.timestamp.toLocal().toString()),
              );
            },
          ),
        ),
    );
  }
}