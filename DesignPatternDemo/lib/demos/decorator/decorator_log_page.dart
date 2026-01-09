///
/// decorator_log_page.dart
/// DecoratorLogPage
///
/// Created by Adam Chen on 2025/12/31
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/decorator_view_model.dart';

class DecoratorLogPage extends StatelessWidget {

  const DecoratorLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DecoratorViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('價格和日誌'),
        actions: [
          TextButton(
            onPressed: () {
              vm.clearAll();
              Navigator.pop(context);
            },
            child: const Text('全部清空', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('價格拆解 (Breakdown):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                flex: 4, // 可以根據需求調整比例，例如 4:6
                child: _buildBreakdownList(vm),
              ),

              const SizedBox(height: 24),

              const Text('操作紀錄 (Logs):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                flex: 6,
                child: _buildLogList(vm),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownList(DecoratorViewModel vm) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: vm.breakdown.length,
        separatorBuilder: (_, __) => const Divider(height: 12),
        itemBuilder: (_, i) {
          final item = vm.breakdown[i];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(item.label, style: const TextStyle(fontSize: 13))),
              Text('\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogList(DecoratorViewModel vm) {
    final logs = vm.logs.reversed.toList(); // 取得最新的在上面

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: logs.isEmpty
      ? const Center(child: Text('沒有操作紀錄'))
      : ListView.builder(
        // 直接使用 ListView 處理滾動
        padding: const EdgeInsets.all(12),
        itemCount: logs.length,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    logs[i],
                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey, height: 1.4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}