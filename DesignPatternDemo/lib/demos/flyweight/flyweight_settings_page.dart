///
/// flyweight_settings_page.dart
/// FlyweightSettingsPage
///
/// Created by Adam Chen on 2026/01/02
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'util/flyweight_util.dart';
import 'view_model/flyweight_view_model.dart';

class FlyweightSettingsPage extends StatelessWidget {

  const FlyweightSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FlyweightViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增物件配置'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. 設定區域 (可捲動)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('1. 選擇物件類型', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildTypeSelector(vm),
                    const SizedBox(height: 24),
                    const Text('2. 指定顯示顏色', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildColorSelector(vm),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('隨機顏色'),
                      subtitle: const Text('開啟後將忽略上方手選顏色'),
                      value: vm.randomColors,
                      onChanged: (val) => vm.toggleRandomizeColors(val),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),

            // 2. 底部動作區域 (固定在底部)
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32), // 增加底部間距
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 第一排按鈕：取消與新增 100
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消返回'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: () {
                            vm.addBatch(100);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('確認新增 100 個'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 第二排按鈕：新增 1000
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: () {
                        vm.addBatch(1000);
                        Navigator.pop(context);
                      },
                      child: const Text('批次新增 1000 個並返回'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(FlyweightViewModel vm) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(vm.types.length, (i) {
        final typeName = vm.types[i];
        final isSelected = vm.selectedTypeIndex == i;
        return ChoiceChip(
          label: Text(typeName),
          selected: isSelected,
          selectedColor: Colors.blue.shade600,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (bool selected) {
            if (selected) {
              vm.selectType(i);
            }
          },
        );
      }),
    );
  }

  Widget _buildColorSelector(FlyweightViewModel vm) {
    final bool isEnabled = !vm.randomColors;
    return Opacity(
      opacity: isEnabled ? 1 : 0.5,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(vm.colors.length, (index) {
          final colorName = vm.colors[index];
          final isSelected = vm.selectedColorIndex == index && isEnabled;
          final Color displayColor = FlyweightUtil.parseColor(colorName);

          return ChoiceChip(
            label: Text(colorName),
            selected: isSelected,
            selectedColor: Colors.blue.shade100,
            onSelected: isEnabled
                ? (bool selected) {
                    if (selected)
                      vm.selectColor(index);
                  }
                : null, // 禁用點擊
          );
        }),

      ),
    );

  }


}