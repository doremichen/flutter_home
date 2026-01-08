///
/// template_history_page.dart
/// TemplateHistoryPage
///
/// Created by Adam Chen on 2026/01/08
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/report_view_model.dart';

class TemplateHistoryPage extends StatelessWidget {

  const TemplateHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('樣板模式歷史頁面'),
        actions: [
          TextButton(
            onPressed: () {
              vm.clear();
              Navigator.pop(context);
            },
            child: const Text('清空', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: _buildListLogs(context, vm),
              ),
            ],
          ),
        ),
      ),


    );
  }

  Widget _buildListLogs(BuildContext context, ReportViewModel vm) {
    if (vm.logs.isEmpty) {
      return const Center(
        child: Text('目前尚無歷史記錄', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        final logEvent = vm.logs[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: Text('${index + 1}', style: TextStyle(color: Colors.blue.shade800, fontSize: 12)),
            ),
            title: Text(
              '${logEvent.message}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '時間: ${logEvent.timestamp.toLocal().toString().substring(11, 19)}',
              style: const TextStyle(fontSize: 11),
            ),
            trailing: const Icon(Icons.check_circle, color: Colors.green, size: 16),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
      itemCount: vm.logs.length,

    );
  }

}