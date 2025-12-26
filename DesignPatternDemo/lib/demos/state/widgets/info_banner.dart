///
/// info_banner.dart
/// InfoBanner
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import '../view_model/player_view_model.dart';

class InfoBanner extends StatelessWidget {

  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerViewModel>();
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
                title: const Text('State Pattern Demo'),
                subtitle: Text(
                  '目前 State Engine：${switch (vm.selectedType) {
                    EngineType.classic => 'Classic State',
                    EngineType.enumBased => 'Enum State',
                    EngineType.sealed => 'Sealed State',
                  }}\n目前狀態：${vm.stateLabel}',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '此範例以 MVVM 架構示範 State Pattern：'
                    '\n• ViewModel 擔任 Context，對 State Engine 下達行為（play/pause/stop/reset）。'
                    '\n• State Engine 依當前狀態決定轉換邏輯並回傳 log。'
                    '\n• View 綁定 ViewModel，顯示目前狀態與操作日誌（ListView）。',
              ),
            ],
          ),
        ),
    );

  }

}