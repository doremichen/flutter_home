///
/// control_panel.dart
/// ControlPanel
///
/// Created by Adam Chen on 2025/12/24
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/log_view_model.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LogViewModel>();
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Adapter
              Row(
                children: [
                  const Text('選擇 Adapter：'),
                  const SizedBox(width: 12),
                  DropdownButton<AdapterType>(
                    value: vm.selected,
                    items: AdapterType.values
                        .map(
                          (t) => DropdownMenuItem(
                        value: t,
                        child: Text(switch (t) {
                          AdapterType.changeNotifier => 'ChangeNotifier',
                          AdapterType.stream => 'StreamController',
                          AdapterType.valueNotifier => 'ValueNotifier',
                        }),
                      ),
                    ).toList(),
                    onChanged: (t) {
                      if (t != null) {
                        context.read<LogViewModel>().selectAdapter(t);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('新增事件'),
                    onPressed: () => context.read<LogViewModel>().addEvent(),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('清空'),
                    onPressed: () => context.read<LogViewModel>().clear(),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    selected: vm.auto,
                    label: const Text('自動（每秒）'),
                    avatar: Icon(
                      vm.auto ? Icons.play_arrow : Icons.pause,
                      color: vm.auto ? Colors.green : Colors.grey,
                    ),
                    onSelected: (_) => context.read<LogViewModel>().toggleAuto(),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}