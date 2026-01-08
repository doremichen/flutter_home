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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // select adapter
          _buildAdapterSelector(context, vm),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),

          // action panel
          _buildActionPanel(context, vm),

        ],
      ),
    );
  }

  Widget _buildAdapterSelector(BuildContext context, LogViewModel vm) {
    return Column(
      children: [
        // Title
        Text(
          '選擇資料來源 (Adapter)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AdapterType>(
              value: vm.selected,
              itemHeight: 64,
              isExpanded: true,
              onChanged: (t) => context.read<LogViewModel>().selectAdapter(t!),
              items: AdapterType.values.map(
                  (t) {
                    return DropdownMenuItem<AdapterType>(
                      value: t,
                      child: Text(
                        _adapterName(t),
                      ),
                    );
                  }
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionPanel(BuildContext context, LogViewModel vm) {
    return Wrap(
        spacing: 12,    // 水平間距
        runSpacing: 12, // 垂直間距
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // add new action
          FilledButton.icon(
            onPressed: () => context.read<LogViewModel>().addEvent(),
            icon: const Icon(Icons.add),
            label: const Text('新增事件'),
          ),
          // auto mode
          ChoiceChip(
            selected: vm.auto,
            onSelected: (_) => context.read<LogViewModel>().toggleAuto(),
            label: Text(vm.auto ? '自動中' : '手動執行'),
            avatar: Icon(
              vm.auto ? Icons.play_arrow : Icons.pause,
              size: 18,
              color: vm.auto ? Colors.white : Colors.grey,
            ),
            selectedColor: Colors.green,
            labelStyle: TextStyle(color: vm.auto ? Colors.white : Colors.black87),
          ),
          // clear log
          OutlinedButton.icon(
            onPressed: () => context.read<LogViewModel>().clear(),
            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
            label: const Text('清空', style: TextStyle(color: Colors.redAccent)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
          ),
        ],
    );

  }

  String _adapterName(AdapterType t) {
    switch (t) {
      case AdapterType.changeNotifier:
        return 'ChangeNotifier (省電模式)';
      case AdapterType.stream:
        return 'StreamController (即時串流)';
      case AdapterType.valueNotifier:
        return 'ValueNotifier (輕量監聽)';
    }
  }
}