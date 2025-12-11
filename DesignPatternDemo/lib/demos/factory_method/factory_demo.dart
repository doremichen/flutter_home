///
/// factory_demo.dart
/// FactoryDemoPage
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creator/factory.dart';
import 'view_model/factory_view_model.dart';

class FactoryDemoPage extends StatelessWidget {
  const FactoryDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FactoryViewModel(),
      child: const _FactoryDemoBody(),
    );
  }
}

class _FactoryDemoBody extends StatelessWidget {
  const _FactoryDemoBody();

  @override
  Widget build(BuildContext context) {
    final factories = <VehicleFactory>[
      SportCarFactory(),
      FamilyCarFactory(),
      TruckFactory(),
    ];

    return Consumer<FactoryViewModel>(
      builder: (context, vm, _) {
        // show toast/snack bar after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.takeLastToast();
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
          }
        });

        Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Factory Method Demo'),
            actions: [
              IconButton(
                tooltip: 'Clear all',
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear all'),
                      content: const Text('Remove all created vehicles?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) vm.clearAll();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// --- 新增：Demo 目的說明（位於 AppBar 下方） ---
                _InfoBanner(
                  title: '此 Demo 的目的',
                  lines: const [
                    '示範 Factory Method 如何將「物件的建立邏輯」封裝在各個 Creator/ConcreteFactory 中，而呼叫端僅透過抽象工廠介面取得具體產品。',
                    '下方按鈕可建立不同車款（跑車/家庭轎車/卡車），每個工廠負責回傳各自的 Vehicle 實例。',
                    '右下方清單會顯示已建立的車輛與描述，便於比較不同工廠的差異與擴充性。',
                  ],
                ),
                const SizedBox(height: 16),

                /// --- 控制區：建立 Vehicle 的按鈕群 ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: factories
                        .map(
                          (f) => ElevatedButton.icon(
                        onPressed: () => vm.createVehicle(f),
                        icon: const Icon(Icons.factory),
                        label: Text(f.label),
                      ),
                    )
                        .toList(),
                  ),
                ),

                const Divider(height: 24),

                /// --- 清單標題 ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Created vehicles:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                /// --- 結果清單 ---
                Expanded(
                  child: Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.created.length,
                      separatorBuilder: (_, __) => const Divider(height: 12),
                      itemBuilder: (_, index) {
                        final v = vm.created[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(v.name),
                          subtitle: Text(v.describe()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// --- 小元件：頂部資訊 Banner（卡片樣式、與 Builder Demo 同格式） ---
class _InfoBanner extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _InfoBanner({
    required this.title,
    required this.lines,
  });

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
