///
/// adapter_demo.dart
/// AdapterDemoPage
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'adapter_history_page.dart';
import 'view_model/adapter_view_model.dart';

class AdapterDemoPage extends StatelessWidget {

  const AdapterDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdapterViewModel(),
      child: const _AdapterDemoBody(),
    );
  }
  
}

class _AdapterDemoBody extends StatelessWidget {
  const _AdapterDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdapterViewModel>(
      builder: (context, vm, _) {
        // show toast
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.takeLastToast();
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
          }
        });

        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Adapter 模式 Demo'),
            actions: [
              // 右上角跳轉至結果清單頁面 (與 Prototype 邏輯一致)
              IconButton(
                icon: Badge(
                  label: Text('${vm.results.length}'),
                  child: const Icon(Icons.history),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdapterHistoryPage(vm: vm)),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // info
                  _buildInfoBanner(),

                  const SizedBox(height: 16),

                  // preview
                  _buildLivePreview(vm),

                  const Divider(height: 32, thickness: 1, color: Colors.black12),

                  // control panel
                  Expanded(
                    child: _buildControlPanel(vm),
                  ),
                  const SizedBox(height: 16),

                  // button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: vm.readOnce,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('讀取一次'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => vm.readBatch(5),
                          icon: const Icon(Icons.replay_5),
                          label: const Text('批次讀取 ×5'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.blue.shade600),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildInfoBanner() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 140),
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 8),
          child: _InfoBanner(
            title: '此 Demo 的目的',
            lines: const [
              '展示 Adapter 模式如何將「舊系統/第三方 API（英制）」轉換成「新系統期望的介面與單位（公制）」。',
              '選擇上方 Adapter（車速 mph→km/h / 溫度 °F→°C），使用按鈕讀取一次或批次讀取。',
              '右上方可點選歷史清單顯示每次量測的轉換結果與時間戳，便於驗證適配器是否正確工作。',            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLivePreview(AdapterViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.sync_alt, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.current.label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '公式: ${vm.current.formula}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(AdapterViewModel vm) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('1. 選擇適配器 (Adapter)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              vm.adapters.length, (i) {
              return ChoiceChip(
                  label: Text(vm.adapters[i].label),
                  selected: vm.selectedIndex == i,
                  onSelected: (_) => vm.selectAdapter(i),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _InfoBanner({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle =
    theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = theme.textTheme.bodyMedium;

    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (titleStyle != null) Text(title, style: titleStyle),
            const SizedBox(height: 8),
            ...lines.map(
                  (t) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(t, style: bodyStyle)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
