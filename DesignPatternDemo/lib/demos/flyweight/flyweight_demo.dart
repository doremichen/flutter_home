


import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import 'view_model/flyweight_view_model.dart';


class FlyweightDemoPage extends StatelessWidget {
  const FlyweightDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (_) => FlyweightViewModel(),
        child: const _FlyweightDemoBody(),
      );
  }
}

class _FlyweightDemoBody extends StatelessWidget {
  const _FlyweightDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<FlyweightViewModel>(
      builder: (context, vm, _) {
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
            title: const Text('Flyweight Pattern Demo'),
            actions: [
              IconButton(
                tooltip: 'Clear logs',
                icon: const Icon(Icons.delete),
                onPressed: vm.clearLogs,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoBanner(
                  title: '此 Demo 的目的',
                  lines: const [
                    '展示 Flyweight（享元）如何將「大型且不變的內在狀態」共享（例如圖像/樣式），僅為每個物件保存「外在狀態」（位置、尺寸），以大幅降低記憶體使用量。',
                    '選擇地圖物件類型與顏色，批次新增（×100/×1000）；開啟「隨機顏色」可增加共享元數量的變化。',
                    '統計卡會比較享元 vs 天真（不共享）模式的記憶體估算與節省比例，並顯示唯一共享 Sprite 數量與物件總數。',
                  ],
                ),
                const SizedBox(height: 16),
                /// --- 控制區：類型 + 顏色 + 隨機色 + 操作按鈕 ---
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(vm.types.length, (i) {
                          final selected = vm.selectedTypeIndex == i;
                          return ChoiceChip(
                            label: Text(vm.types[i]),
                            selected: selected,
                            onSelected: (_) => vm.selectType(i),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(width: 12),

                    SegmentedButton<int>(
                      segments: List.generate(
                        vm.colors.length,
                            (i) => ButtonSegment(value: i, label: Text(vm.colors[i])),
                      ),
                      selected: {vm.selectedColorIndex},
                      onSelectionChanged: (s) => vm.selectColor(s.first),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: SwitchListTile(
                        title: const Text('隨機顏色（增加共享元種類）'),
                        value: vm.randomColors,
                        onChanged: vm.toggleRandomizeColors,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () => vm.addBatch(100),
                      child: const Text('Add ×100'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      onPressed: () => vm.addBatch(1000),
                      child: const Text('Add ×1000'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: vm.clearAll,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear all'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Objects: ${vm.totalObjects} | Shared sprites: ${vm.uniqueFlyweights}',
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            const Icon(Icons.memory),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Flyweight：${vm.memoryWithFlyweightKB.toStringAsFixed(2)} KB',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Naive：${vm.memoryNaiveKB.toStringAsFixed(2)} KB',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Saving：-${vm.memorySavingKB.toStringAsFixed(2)} KB '
                                    '(${vm.memorySavingPct.toStringAsFixed(1)}%)',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Recent objects:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.objects.length > 50 ? 50 : vm.objects.length,
                      separatorBuilder: (_, __) => const Divider(height: 12),
                      itemBuilder: (_, i) {
                        final idx = vm.objects.length - 1 - i; // 從最新往回顯示
                        final o = vm.objects[idx];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text('${idx + 1}'),
                          ),
                          title: Text('${o.sprite.type} (${o.sprite.color})'),
                          subtitle: Text(o.toString()),
                          trailing: Text('${o.sprite.sizeKB}KB'),
                        );
                      },
                    ),
                  ),
                ),

                /// --- Logs（可選） ---
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