///
/// iterator_demo.dart
/// IteratorDemoPage
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/genre.dart';
import 'view_model/iterator_view_model.dart';

class IteratorDemoPage extends StatelessWidget {
  const IteratorDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IteratorViewModel(),
      child: const _IteratorDemoBody(),
    );
  }
}

class _IteratorDemoBody extends StatelessWidget{
  const _IteratorDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<IteratorViewModel>(
      builder: (context, vm, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.lastToast;
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
            vm.lastToast = null;
          }
        });

        return Scaffold(
            appBar: AppBar(
              title: const Text('Iterator Pattern Demo'),
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
                children: [
                  /// ===== 可捲動的主要內容 =====
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// --- 說明卡 ---
                          _InfoBanner(
                            title: '此 Demo 的目的',
                            lines: const [
                              '展示 Iterator（疊代器）如何提供一致的遍歷介面。',
                              '支援 Forward / Reverse / Filter / Step 等迭代方式。',
                              '可觀察已產出數量與是否到尾端。',
                            ],
                          ),
                          const SizedBox(height: 16),

                          /// --- 控制卡 ---
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Iterator 選擇
                                  const Text('Iterator：'),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      SegmentedButton<IteratorKind>(
                                        segments: const [
                                          ButtonSegment(value: IteratorKind.forward, label: Text('Forward')),
                                          ButtonSegment(value: IteratorKind.reverse, label: Text('Reverse')),
                                          ButtonSegment(value: IteratorKind.filterGenre, label: Text('Filter')),
                                          ButtonSegment(value: IteratorKind.step, label: Text('Step')),
                                        ],
                                        selected: {vm.iteratorKind},
                                        onSelectionChanged: (s) => vm.selectKind(s.first),
                                      ),
                                    ],
                                  ),

                                  /// Filter Genre
                                  if (vm.iteratorKind == IteratorKind.filterGenre) ...[
                                    const SizedBox(height: 12),
                                    const Text('Genre：'),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        SegmentedButton<Genre>(
                                          segments: const [
                                            ButtonSegment(value: Genre.rock, label: Text('Rock')),
                                            ButtonSegment(value: Genre.pop, label: Text('Pop')),
                                            ButtonSegment(value: Genre.jazz, label: Text('Jazz')),
                                            ButtonSegment(value: Genre.classical, label: Text('Classical')),
                                          ],
                                          selected: {vm.filterGenre},
                                          onSelectionChanged: (s) => vm.selectGenre(s.first),
                                        ),
                                      ],
                                    ),
                                  ],

                                  /// Step Slider
                                  if (vm.iteratorKind == IteratorKind.step) ...[
                                    const SizedBox(height: 12),
                                    Text('Step：${vm.step}'),
                                    Slider(
                                      value: vm.step.toDouble(),
                                      min: 1,
                                      max: 8,
                                      divisions: 7,
                                      onChanged: (v) => vm.setStep(v.round()),
                                    ),
                                  ],

                                  const SizedBox(height: 12),

                                  /// 操作按鈕
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      FilledButton(onPressed: vm.nextOne, child: const Text('Next')),
                                      FilledButton.tonal(
                                        onPressed: () => vm.nextBatch(5),
                                        child: const Text('Next ×5'),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: vm.reset,
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Reset'),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: vm.shufflePlaylist,
                                        icon: const Icon(Icons.shuffle),
                                        label: const Text('Shuffle'),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: vm.addSampleSong,
                                        icon: const Icon(Icons.library_add),
                                        label: const Text('Add sample'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// --- 結果卡 ---
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '已產出：${vm.yieldedCount} / ${vm.playList.songsLength}'
                                        ' | ${vm.reachedEnd ? "End" : "..."}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Yielded songs:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 160,
                                    child: ListView.separated(
                                      itemCount: vm.yielded.length,
                                      separatorBuilder: (_, __) => const Divider(height: 8),
                                      itemBuilder: (_, i) {
                                        final s = vm.yielded[i];
                                        return ListTile(
                                          leading: CircleAvatar(child: Text('${i + 1}')),
                                          title: Text(s.title),
                                          subtitle: Text(
                                            '${s.artist} • ${s.genre.label} • ${s.durationSec}s',
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// ===== Logs（固定高度區塊）=====
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Logs:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 160,
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