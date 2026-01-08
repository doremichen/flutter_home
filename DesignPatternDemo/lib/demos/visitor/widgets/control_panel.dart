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
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // visitor type select
          _buildSelectVisitorType(context, vm),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          // action button
          _buildActionButton(context, vm),
        ],
      ),
    );
  }

  Widget _buildSelectVisitorType(BuildContext context, ShapeViewModel vm) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // title
        Text(
          'Visitor 計算模式',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // dropdown menu
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<VisitorType>(
              value: vm.visitorType,
              isExpanded: true, // 核心修正：防止水平溢出
              itemHeight: null, // 核心修正：讓長文字能自定義高度
              onChanged: (t) {
                if (t != null) context.read<ShapeViewModel>().selectVisitor(t);
              },
              items: VisitorType.values.map((t) {
                return DropdownMenuItem(
                  value: t,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      switch (t) {
                        VisitorType.area => 'Area (計算圖形總面積)',
                        VisitorType.perimeter => 'Perimeter (計算圖形總週長)',
                      },
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, ShapeViewModel vm) {
    final theme = Theme.of(context);
    return Wrap(
        spacing: 8,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FilledButton.icon(
            onPressed: () => vm.generateShapes(),
            icon: const Icon(Icons.category, size: 18),
            label: const Text('產生圖形'),
          ),
          ElevatedButton.icon(
            onPressed: () => vm.runVisitor(),
            icon: const Icon(Icons.play_arrow, size: 18),
            label: const Text('執行計算'),
          ),
          ChoiceChip(
            selected: vm.auto,
            onSelected: (_) => vm.toggleAuto(),
            label: Text(vm.auto ? '自動中' : '手動'),
            avatar: Icon(
              vm.auto ? Icons.play_circle_fill : Icons.pause_circle_filled,
              size: 18,
              color: vm.auto ? Colors.white : theme.disabledColor,
            ),
            selectedColor: Colors.green,
            labelStyle: TextStyle(color: vm.auto ? Colors.white : null),
          ),
          OutlinedButton.icon(
            onPressed: () => vm.clear(),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('清空'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
          ),
        ],
    );

  }
}