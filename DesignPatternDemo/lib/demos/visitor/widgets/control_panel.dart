///
/// control_panel.dart
/// ControlPanel
///
/// Created by Adam Chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/shape_view_model.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShapeViewModel>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Text('選擇 Visitor：'),
                const SizedBox(width: 12),
                DropdownButton<VisitorType>(
                  value: vm.visitorType,
                  items: VisitorType.values
                      .map((t) => DropdownMenuItem(
                    value: t,
                    child: Text(switch (t) {
                      VisitorType.area => 'Area（面積）',
                      VisitorType.perimeter => 'Perimeter（週長）',
                    }),
                  ))
                      .toList(),
                  onChanged: (t) {
                    if (t != null) context.read<ShapeViewModel>().selectVisitor(t);
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
                  icon: const Icon(Icons.category),
                  label: const Text('產生圖形'),
                  onPressed: () => context.read<ShapeViewModel>().generateShapes(),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('執行 Visitor'),
                  onPressed: () => context.read<ShapeViewModel>().runVisitor(),
                ),
                FilterChip(
                  selected: vm.auto,
                  label: const Text('自動（每秒）'),
                  avatar: Icon(
                    vm.auto ? Icons.play_circle_fill : Icons.pause_circle_filled,
                    color: vm.auto ? Colors.green : Colors.grey,
                  ),
                  onSelected: (_) => context.read<ShapeViewModel>().toggleAuto(),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('清空'),
                  onPressed: () => context.read<ShapeViewModel>().clear(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}