///
/// decorator_log_page.dart
/// DecoratorLogPage
///
/// Created by Adam Chen on 2025/12/31
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import 'view_model/decorator_view_model.dart';

class DecoratorLogPage extends StatelessWidget {
  final DecoratorViewModel vm;

  const DecoratorLogPage({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('訂單明細與日誌'),
        actions: [
          TextButton(
            onPressed: () {
              vm.clearLogs;
              Navigator.pop(context);
            },
            child: const Text('全部清空', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('價格拆解 (Breakdown):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.breakdown.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    final item = vm.breakdown[i];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.label),
                        Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontFamily: 'monospace')),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text('操作紀錄 (Logs):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...vm.logs.reversed.map((log) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('• $log', style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}