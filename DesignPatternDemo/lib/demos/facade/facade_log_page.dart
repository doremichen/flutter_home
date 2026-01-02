///
/// facade_log_page.dart
/// FacadeLogPage
///
/// Created by Adam Chen on 2026/01/02
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';

import 'view_model/facade_view_model.dart';

class FacadeLogPage extends StatelessWidget {
  final FacadeViewModel vm;

  const FacadeLogPage({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facade 操作序列'),
        actions: [
          TextButton(
            onPressed: () {
              vm.clearLogs();
              Navigator.pop(context);
            },
            child: const Text('全部清空', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: vm.logs.isEmpty
        ? const Center(child: Text('沒有操作紀錄'))
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vm.logs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i + 1}.', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(child: Text(vm.logs[i], style: const TextStyle(fontSize: 13))),
              ],
            ),
        ),
      ),
    );

  }

}