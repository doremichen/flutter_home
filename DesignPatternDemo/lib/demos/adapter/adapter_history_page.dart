///
/// adapter_history_page.dart
/// AdapterHistoryPage
///
/// Created by Adam Chen on 2025/12/31
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/adapter_view_model.dart';

class AdapterHistoryPage extends StatelessWidget {

  const AdapterHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdapterViewModel>();
    return Scaffold(
        appBar: AppBar(
            title: const Text('適配器歷史紀錄'),
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
        body: vm.results.isEmpty
            ? const Center(child: Text('目前尚無轉換資料', style: TextStyle(color: Colors.grey)))
            : ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final m = vm.results[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: Text('${index + 1}', style: TextStyle(color: Colors.blue.shade800, fontSize: 12)),
                ),
                title: Text(
                  '${m.kind}: ${m.original_value.toStringAsFixed(2)} -> ${m.new_value.toStringAsFixed(2)} ${m.unit}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '時間: ${m.at.toLocal().toString().substring(11, 19)}',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: const Icon(Icons.check_circle, color: Colors.green, size: 16),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
          itemCount: vm.results.length,

        ),
    );
  }

}