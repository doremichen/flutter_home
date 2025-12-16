

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/bridge_view_model.dart';

class BridgeDemoPage extends StatelessWidget {

  const BridgeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
       return ChangeNotifierProvider(
         create: (_) => BridgeViewModel(),
         child: const _BridgeDemoBody(),
       );
  }

}

class _BridgeDemoBody extends StatelessWidget {
  const _BridgeDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<BridgeViewModel>(
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
                title: const Text('Bridge Pattern Demo'),
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
                    /// --- 說明卡（與其他 Demo 一致） ---
                    _InfoBanner(
                      title: '此 Demo 的目的',
                      lines: const [
                        '展示 bridge 模式：將「抽象（遙控器）」與「實作（裝置）」分離並以組合相連，使兩者可獨立演進。',
                        '左側選擇裝置（TV/Radio/SmartLight），右側選擇遙控器（Basic/Advanced）。操作按鈕會透過 bridge 呼叫裝置行為。',
                        '觀察狀態卡與下方 Log：更換遙控器不需改動裝置；新增裝置不需改動遙控器，達到低耦合可擴充的設計。',
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// --- 選擇列：裝置 + 遙控器 ---
                    Row(
                      children: [
                        // 裝置 ChoiceChip
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(vm.deviceLabels.length, (i) {
                              final isSelected = vm.selectedDeviceIndex == i;
                              return ChoiceChip(
                                label: Text(vm.deviceLabels[i]),
                                selected: isSelected,
                                onSelected: (_) => vm.selectDevice(i),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 遙控器 Segmented
                        SegmentedButton<RemoteKind>(
                          segments: const [
                            ButtonSegment(value: RemoteKind.basic, label: Text('Basic')),
                            ButtonSegment(value: RemoteKind.advanced, label: Text('Advanced')),
                          ],
                          selected: {vm.selectedRemote},
                          onSelectionChanged: (s) => vm.selectRemote(s.first),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// --- 狀態卡 ---
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              vm.deviceLabels[vm.selectedDeviceIndex] == 'SmartLight'
                                  ? Icons.lightbulb
                                  : (vm.deviceLabels[vm.selectedDeviceIndex] == 'Radio'
                                  ? Icons.radio
                                  : Icons.tv),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                vm.remote.currentStatus(),
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.tonal(
                              onPressed: vm.togglePower,
                              child: const Text('Power'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// --- 操作按鈕列 ---
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        FilledButton(onPressed: vm.volumeUp, child: const Text('Volume +')),
                        FilledButton(onPressed: vm.volumeDown, child: const Text('Volume -')),
                        FilledButton(onPressed: vm.next, child: const Text('Next')),
                        FilledButton(onPressed: vm.prev, child: const Text('Prev')),
                        if (vm.selectedRemote == RemoteKind.advanced) ...[
                          FilledButton.tonal(onPressed: vm.mute, child: const Text('Mute')),
                          FilledButton.tonal(onPressed: vm.randomize, child: const Text('Randomize')),
                          FilledButton.tonal(onPressed: vm.macroPowerPlay, child: const Text('Macro PowerPlay')),
                        ],
                      ],
                    ),

                    const Divider(height: 24),

                    /// --- Log 清單 ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Card(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: vm.logs.length,
                          separatorBuilder: (_, __) => const Divider(height: 12),
                          itemBuilder: (_, index) => Text(vm.logs[index]),
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

/// --- 頂部資訊卡（沿用既有樣式） ---
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