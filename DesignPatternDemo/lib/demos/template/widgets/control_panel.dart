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
    final theme = Theme.of(context);

    return Container(
      width: double.infinity, // assure the width is  same as screen width
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // select template type
          _buildSelectTemplateType(context, vm),

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

  Widget _buildSelectTemplateType(BuildContext context, ReportViewModel vm) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Text(
          '報告模板配置 (Template)',
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
            child: DropdownButton<TemplateType>(
              value: vm.selectedType,
              isExpanded: true,
              itemHeight: null,  // auto
              icon: const Icon(Icons.arrow_drop_down_circle_outlined, size: 20),
              onChanged: (type) => vm.selectTemplate(type!),
              items: TemplateType.values.map((type) {
                return DropdownMenuItem<TemplateType>(
                  value: type,
                  child: Text(
                    switch (type) {
                      TemplateType.sales => 'Sales Report (銷售分析)',
                      TemplateType.inventory => 'Inventory (庫存盤點)',
                      TemplateType.audit => 'Audit (年度稽核)',
                      TemplateType.functionBased => 'Function (函式回調步驟)',
                    }
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, ReportViewModel vm) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilledButton.icon(
          onPressed: () => vm.generateData(),
          icon: const Icon(Icons.shuffle, size: 18),
          label: const Text('產生資料'),
        ),
        ElevatedButton.icon(
          onPressed: () => vm.runTemplate(),
          icon: const Icon(Icons.play_arrow, size: 18),
          label: const Text('執行模板'),
        ),
        ChoiceChip(
          selected: vm.auto,
          onSelected: (_) => vm.toggleAuto(),
          label: Text(vm.auto ? '自動中' : '手動模式'),
          avatar: Icon(
            vm.auto ? Icons.play_circle_fill : Icons.pause_circle_filled,
            size: 18,
            color: vm.auto ? theme.colorScheme.onPrimary : theme.disabledColor,
          ),
          selectedColor: Colors.green,
          labelStyle: TextStyle(color: vm.auto ? Colors.white : null),
        ),
        OutlinedButton.icon(
          onPressed: () => vm.clear(),
          icon: const Icon(Icons.delete_sweep_outlined, size: 18),
          label: const Text('清空'),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
        ),
      ],
    );
  }

}