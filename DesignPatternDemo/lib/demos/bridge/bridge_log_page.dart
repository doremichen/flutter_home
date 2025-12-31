///
/// bridge_log_page.dart
/// BridgeLogPage
///
/// Created by Adam Chen on 2025/12/31.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart.';

import 'view_model/bridge_view_model.dart';

class BridgeLogPage extends StatelessWidget{
  final BridgeViewModel vm;
  const BridgeLogPage({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('轉換歷史紀錄'),
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
            ? const Center(child: Text('目前尚無紀錄', style: TextStyle(color: Colors.grey)))
            : ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: vm.logs.length,
          separatorBuilder: (_, __) => const Divider(height: 8),
          itemBuilder: (_, i) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: Text('${i + 1}', style: TextStyle(color: Colors.blue.shade800, fontSize: 12)),
                ),
                title: Text(vm.logs[vm.logs.length - 1 - i], style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          },
        ),
      ),
    );

  }

}