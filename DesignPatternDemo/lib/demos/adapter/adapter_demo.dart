///
/// adapter_demo.dart
/// AdapterDemoPage
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            title: const Text('Adapter Pattern Demo'),
            actions: [
              IconButton(
                tooltip: 'Clear all',
                icon: const Icon(Icons.delete),
                onPressed: vm.clearAll,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // --- info
                _InfoBanner(
                  title: '此 Demo 的目的',
                  lines: const [
                    '展示 Adapter 模式如何將「舊系統/第三方 API（英制）」轉換成「新系統期望的介面與單位（公制）」。',
                    '選擇上方 Adapter（車速 mph→km/h / 溫度 °F→°C），使用按鈕讀取一次或批次讀取。',
                    '下方清單顯示每次量測的轉換結果與時間戳，便於驗證適配器是否正確工作。',
                  ],
                ),
                const SizedBox(height: 16,),

                // --- Adapter (ChoiceChip) ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        vm.adapters.length, (i) {
                        final isSelected = vm.selectedIndex == i;
                        return ChoiceChip(
                          label: Text(vm.adapters[i].label),
                          selected: isSelected,
                          onSelected: (_) => vm.selectAdapter(i),
                        );
                      }),
                  ),
                ),

                const SizedBox(height: 12),

                // --- adapter formula tip ----
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Formula: ${vm.current.formula}',
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: theme.colorScheme.outline),
                  ),
                ),

                const SizedBox(height: 12),

                // --- Buttons ----
                Row(
                  children: [
                    FilledButton(
                      onPressed: vm.readOnce,
                      child: const Text('Read once'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      onPressed: () => vm.readBatch(5),
                      child: const Text('Read batch ×5'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- title of list ---
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Measurements:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                // ---- result of list ---
                Expanded(
                  child: Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.results.length,
                      separatorBuilder: (_, __) => const Divider(height: 12),
                      itemBuilder: (_, index) {
                        final m = vm.results[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text('${m.kind} = ${m.value.toStringAsFixed(2)} ${m.unit}'),
                          subtitle: Text(m.at.toLocal().toString()),
                        );
                      },
                    ),
                  ),
                ),

                // --- log ---
                if (vm.logs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 120,
                    child: Card(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: vm.logs.length,
                        separatorBuilder: (_, __) => const Divider(height: 8),
                        itemBuilder: (_, i) => Text(vm.logs[i]),
                      ),
                    ),
                  ),
                ],

              ],
            ),
          ),
        );
      }
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
