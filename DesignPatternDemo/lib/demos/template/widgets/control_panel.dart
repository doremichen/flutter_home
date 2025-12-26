///
/// control_panel.dart
/// ControlPanel
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/report_view_model.dart';

class ControlPanel extends StatelessWidget {

  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportViewModel>();

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('選擇模板：'),
                const SizedBox(width: 12),
                DropdownButton<TemplateType>(
                  value: vm.selectedType,
                  items: TemplateType.values
                      .map((t) => DropdownMenuItem(
                    value: t,
                    child: Text(switch (t) {
                      TemplateType.sales => 'Sales',
                      TemplateType.inventory => 'Inventory',
                      TemplateType.audit => 'Audit',
                      TemplateType.functionBased => 'Function（函式步驟）',
                    }),
                  ))
                      .toList(),
                  onChanged: (t) {
                    if (t != null) context.read<ReportViewModel>().selectTemplate(t);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shuffle),
                    label: const Text('產生資料'),
                    onPressed: () => context.read<ReportViewModel>().generateData(),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('執行模板'),
                    onPressed: () => context.read<ReportViewModel>().runTemplate(),
                  ),
                  FilterChip(
                    selected: vm.auto,
                    label: const Text('自動（每秒）'),
                    avatar: Icon(
                      vm.auto ? Icons.play_circle_fill : Icons.pause_circle_filled,
                      color: vm.auto ? Colors.green : Colors.grey,
                    ),
                    onSelected: (_) => context.read<ReportViewModel>().toggleAuto(),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('清空'),
                    onPressed: () => context.read<ReportViewModel>().clear(),
                  ),
                ],
            ),
          ],
        ),
      ),
    );
  }

}