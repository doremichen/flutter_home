///
/// info_banner.dart
/// InfoBanner
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/sort_view_model.dart';

class InfoBanner extends StatelessWidget {

  const InfoBanner({super.key});

  String _strategyLabel(StrategyType t) => switch (t) {
    StrategyType.quickSort => 'QuickSort',
    StrategyType.mergeSort => 'MergeSort',
    StrategyType.insertionSort => 'InsertionSort',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SortViewModel>();
    return Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.info_outline),
                title: const Text('策略模式 (Strategy)'),
                subtitle: Text(
                  '目前策略：${_strategyLabel(vm.selectedType)}'
                      '\n輸入長度：${vm.input.length}'
                      '\n輸出：${vm.output ?? '(尚未執行)'}',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '此範例以 MVVM 架構示範 Strategy Pattern：'
                    '\n• 將不同演算法（Quick/Merge/Insertion）封裝為 SortStrategy。'
                    '\n• ViewModel 負責持有目前策略、準備資料並執行策略。'
                    '\n• View 綁定 ViewModel，顯示狀態與日誌（ListView）。',
              ),
            ],
          ),
        ),
    );
  }
}