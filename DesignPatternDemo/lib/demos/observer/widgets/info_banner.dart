///
/// info_banner.dart
/// InfoBanner
///
/// Created by Adam Chen on 2025/12/24
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/log_view_model.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  String _adapterName(AdapterType t) {
    switch (t) {
      case AdapterType.changeNotifier:
        return 'ChangeNotifier（轉播至 Stream）';
      case AdapterType.stream:
        return 'StreamController（原生 Stream）';
      case AdapterType.valueNotifier:
        return 'ValueNotifier（轉播至 Stream）';
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LogViewModel>();;
    return Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('觀察者 (Observer)'),
                  subtitle: Text('目前 Adapter：${_adapterName(vm.selected)}'),
                  leading: const Icon(Icons.info_outline),
                ),
                const SizedBox(height: 8),
                const Text(
                  '此範例以 MVVM 架構示範 Observer Pattern：'
                      '\n• Subject（Adapter）透過不同機制發出事件。'
                      '\n• ViewModel 訂閱 Subject 的 Stream，更新內部狀態。'
                      '\n• View 綁定 ViewModel（Provider），以 notifyListeners() 觸發 UI 重建。',
                ),
              ],
          ),
        ),
    );
  }

}