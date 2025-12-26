///
/// control_panel.dart
/// ControlPanel
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/player_view_model.dart';

class ControlPanel extends StatelessWidget {

  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerViewModel>();
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Engine 選擇
              Row(
                children: [
                  const Text('選擇 State Engine：'),
                  const SizedBox(width: 12),
                  DropdownButton<EngineType>(
                    value: vm.selectedType,
                    items: EngineType.values
                        .map(
                          (t) => DropdownMenuItem(
                        value: t,
                        child: Text(switch (t) {
                          EngineType.classic => 'Classic',
                          EngineType.enumBased => 'Enum',
                          EngineType.sealed => 'Sealed',
                        }),
                      ),
                    )
                        .toList(),
                    onChanged: (t) {
                      if (t != null) {
                        context.read<PlayerViewModel>().selectEngine(t);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 操作按鈕
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                    onPressed: () => context.read<PlayerViewModel>().play(),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                    onPressed: () => context.read<PlayerViewModel>().pause(),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                    onPressed: () => context.read<PlayerViewModel>().stop(),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset'),
                    onPressed: () => context.read<PlayerViewModel>().reset(),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    selected: vm.auto,
                    label: const Text('自動（每秒）'),
                    avatar: Icon(
                      vm.auto ? Icons.play_circle_fill : Icons.pause_circle_filled,
                      color: vm.auto ? Colors.green : Colors.grey,
                    ),
                    onSelected: (_) => context.read<PlayerViewModel>().toggleAuto(),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('清空日誌'),
                    onPressed: () => context.read<PlayerViewModel>().clearLogs(),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

}