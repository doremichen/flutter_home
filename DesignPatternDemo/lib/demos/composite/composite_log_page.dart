///
/// composite_log_page.dart
/// CompositeLogPage
///
/// Created by Adam Chen on 2025/12/31
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart.';

import 'view_model/composite_view_model.dart';

class CompositeLogPage extends StatelessWidget{
  final CompositeViewModel vm;
  const CompositeLogPage({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('操作紀錄'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              vm.clearLogs();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: vm.logs.isEmpty
            ? const Center(child: Text('查無日誌紀錄', style: TextStyle(color: Colors.grey)))
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: vm.logs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.history_edu, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 12),
                Expanded(child: Text(vm.logs[i], style: const TextStyle(fontSize: 13))),
              ],
            ),
          ),
        ),
      ),
    );
  }

}