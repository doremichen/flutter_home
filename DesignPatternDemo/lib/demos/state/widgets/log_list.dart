///
/// log_list.dart
/// LogList
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/model/log_event.dart';
import '../view_model/player_view_model.dart';

class LogList extends StatelessWidget {

  const LogList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerViewModel>();
    final List<LogEvent> events = vm.logs;
    return Card(
        margin: const EdgeInsets.all(12),
        child: SizedBox(
          height: 360,
          child: events.isEmpty
              ? const Center(child: Text('尚無日誌，請在上方操作或啟用自動模式'))
              : ListView.separated(
                itemCount: events.length,
                separatorBuilder: (_, __) => const Divider(height: 12),
                itemBuilder: (_, index) {
                  final e = events[index];
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