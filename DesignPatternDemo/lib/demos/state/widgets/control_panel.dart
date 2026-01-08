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
              _buildEngineSelector(context, vm),

              const SizedBox(height: 12),
              // 操作按鈕
              _buildActionPanel(context, vm),

            ],
          ),
        ),
    );
  }

  Widget _buildEngineSelector(BuildContext context, PlayerViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        const Text(
          '選擇 State Engine',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        // Dropdown menu
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<EngineType>(
              value: vm.selectedType,
              itemHeight: 64,
              isExpanded: true,
              onChanged: (t) => context.read<PlayerViewModel>().selectEngine(t!),
              items: EngineType.values.map((t) {
                return DropdownMenuItem<EngineType>(
                  value: t,
                  child: Text(
                    _engineName(t),
                  ),
                );
              }).toList(),
            ),

          ),

        ),
      ],
    );
  }

  String _engineName(EngineType t) {
    switch (t) {
      case EngineType.classic:
        return 'Classic (傳統狀態模式)';
      case EngineType.enumBased:
        return 'Enum (枚舉驅動狀態)';
      case EngineType.sealed:
        return 'Sealed (密封類別狀態)';
    }
  }

  Widget _buildActionPanel(BuildContext context, PlayerViewModel vm) {
    return Wrap(
      spacing: 12,    // 水平間距
      runSpacing: 8, // 垂直間距
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
    );
  }

}