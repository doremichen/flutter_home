///
/// abstractory_factory_demo.dart
/// AbstractFactoryDemoPage
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:design_pattern_demo/demos/abstract_factory/view_model/absfactory_vm.dart';
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import 'creator/abstract_factory.dart';

class AbstractFactoryDemoPage extends StatelessWidget {
  const AbstractFactoryDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AbstractFactoryViewModel(
        factories: [
          SportPartsFactory(),
          FamilyPartsFactory(),
          TruckPartsFactory(),
        ],
      ),
      child: const _AbstractFactoryDemoBody(),
    );
  }
}

class _AbstractFactoryDemoBody extends StatelessWidget {
  const _AbstractFactoryDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<AbstractFactoryViewModel>(
      builder: (context, vm, _) {
        // Snackbar Toast（避免在 build 中直接觸發）
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
            title: const Text('Abstract Factory Demo'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Clear all',
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear all'),
                      content: const Text('Remove all created part sets?'),
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
                /// --- 新增：Demo 目的說明（與其他頁一致） ---
                _InfoBanner(
                  title: '此 Demo 的目的',
                  lines: const [
                    '展示 Abstract Factory 如何產生「一組相互匹配的產品族」，以維持風格與相容性的一致。',
                    '上方的 ChoiceChip 用來選擇不同零件工廠（跑車/家庭/卡車），建立時會一次產生同系列的零件組合。',
                    '下方清單列出已建立的零件套件，便於比較不同工廠的輸出差異與擴充性。',
                  ],
                ),
                const SizedBox(height: 16),

                /// --- 工廠選擇：ChoiceChip ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(vm.factories.length, (i) {
                      final isSelected = vm.selectedIndex == i;
                      return ChoiceChip(
                        label: Text(vm.factories[i].label),
                        selected: isSelected,
                        onSelected: (_) => vm.selectFactory(i),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 12),

                /// --- 建立成套零件 ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: vm.createMatchedSet,
                    icon: const Icon(Icons.build),
                    label: const Text('Create Matched Parts Set'),
                  ),
                ),

                const Divider(height: 24),

                /// --- 清單標題 ---
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Created sets:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                /// --- 結果清單（Card + ListView.separated） ---
                Expanded(
                  child: Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.createdSets.length,
                      itemBuilder: (_, i) => Text(vm.createdSets[i]),
                      separatorBuilder: (_, __) => const Divider(height: 12),
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

/// --- Demo 說明卡元件（與 Builder/Factory/Singleton 一致） ---
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