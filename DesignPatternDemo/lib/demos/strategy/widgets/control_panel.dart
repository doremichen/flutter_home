///
/// control_panel.dart
/// ControlPanel
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/sort_view_model.dart';

class ControlPanel extends StatelessWidget {

  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SortViewModel>();
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Strategy 選擇
            Row(
              children: [
                const Text('選擇策略：'),
                const SizedBox(width: 12),
                DropdownButton<StrategyType>(
                  value: vm.selectedType,
                  items: StrategyType.values
                      .map(
                        (t) => DropdownMenuItem(
                      value: t,
                      child: Text(switch (t) {
                        StrategyType.quickSort => 'QuickSort',
                        StrategyType.mergeSort => 'MergeSort',
                        StrategyType.insertionSort => 'InsertionSort',
                      }),
                    ),
                  )
                      .toList(),
                  onChanged: (t) {
                    if (t != null) {
                      context.read<SortViewModel>().selectStrategy(t);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 操作按鈕
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.shuffle),
                  label: const Text('產生資料'),
                  onPressed: () => context.read<SortViewModel>().generateData(),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('執行策略'),
                  onPressed: () => context.read<SortViewModel>().runStrategy(),
                ),
                FilterChip(
                  selected: vm.auto,
                  label: const Text('自動（每秒）'),
                  avatar: Icon(
                    vm.auto ? Icons.play_circle_fill : Icons.pause_circle_filled,
                    color: vm.auto ? Colors.green : Colors.grey,
                  ),
                  onSelected: (_) => context.read<SortViewModel>().toggleAuto(),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('清空'),
                  onPressed: () => context.read<SortViewModel>().clear(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}