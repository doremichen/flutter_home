///
/// cor_demo.dart
/// CoRDemoPage
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import 'model/data.dart';
import 'view_model/cor_view_model.dart';

class CoRDemoPage extends StatelessWidget {
  const CoRDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CoRViewModel(),
      child: const _CoRDemoBody(),
    );
  }

}

class _CoRDemoBody extends StatefulWidget {
  const _CoRDemoBody();

  @override
  State<StatefulWidget> createState() => _CoRDemoBodyState();
}

class _CoRDemoBodyState extends State<_CoRDemoBody> {
  final _msgController = TextEditingController(text: '退款流程諮詢');

  @override
  void dispose() {
    // dispose
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoRViewModel>(
      builder: (context, vm, _) {
        // SnackBar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.takeLastToast();
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
          }
        });

        final theme = Theme.of(context);

        // 同步輸入框
        _msgController.value = _msgController.value.copyWith(text: vm.message);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Chain of Responsibility Demo'),
              actions: [
                IconButton(
                  tooltip: 'Clear logs',
                  icon: const Icon(Icons.delete),
                  onPressed: vm.clearLogs,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoBanner(
                      title: '此 Demo 的目的',
                      lines: const [
                        '展示 CoR（責任鏈）：請求依序通過多個處理者（Handler），每個節點可選擇「處理並早停」或「傳遞給下一個」。',
                        '範例鏈：Auth → Spam → Validation → Tier1 → Tier2 → Manager；可動態啟用/停用某些節點並觀察影響。',
                        '適用情境：驗證/分流/規則匹配/事件分派/編譯管線等，利於責任分離與擴充。',
                      ],
                    ),
                    const SizedBox(height: 16),
                    /// --- 控制區：類別/嚴重度/訊息/開關 ---
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text('類別：'),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SegmentedButton<Category>(
                                    segments: const [
                                      ButtonSegment(value: Category.billing, label: Text('Billing')),
                                      ButtonSegment(value: Category.tech, label: Text('Tech')),
                                      ButtonSegment(value: Category.sales, label: Text('Sales')),
                                    ],
                                    selected: {vm.category},
                                    onSelectionChanged: (s) => vm.setCategory(s.first),
                                  ),
                                ),
                                const Spacer(),
                                const Text('嚴重度：'),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SegmentedButton<Severity>(
                                    segments: const [
                                      ButtonSegment(value: Severity.low, label: Text('Low')),
                                      ButtonSegment(value: Severity.medium, label: Text('Medium')),
                                      ButtonSegment(value: Severity.high, label: Text('High')),
                                    ],
                                    selected: {vm.severity},
                                    onSelectionChanged: (s) => vm.setSeverity(s.first),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _msgController,
                                    decoration: const InputDecoration(
                                      labelText: '描述',
                                      hintText: '請簡述問題（避免垃圾字樣）',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: vm.setMessage,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('已認證'),
                                    Switch(
                                      value: vm.hasAuth,
                                      onChanged: vm.setHasAuth,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilterChip(
                                  label: const Text('Spam'),
                                  selected: vm.enableSpam,
                                  onSelected: (v) => vm.setEnableSpam(v),
                                ),
                                FilterChip(
                                  label: const Text('Validation'),
                                  selected: vm.enableValidation,
                                  onSelected: (v) => vm.setEnableValidation(v),
                                ),
                                FilterChip(
                                  label: const Text('Tier1'),
                                  selected: vm.enableTier1,
                                  onSelected: (v) => vm.setEnableTier1(v),
                                ),
                                FilterChip(
                                  label: const Text('Tier2'),
                                  selected: vm.enableTier2,
                                  onSelected: (v) => vm.setEnableTier2(v),
                                ),
                                FilterChip(
                                  label: const Text('Manager'),
                                  selected: vm.enableManager,
                                  onSelected: (v) => vm.setEnableManager(v),
                                ),
                              ],
                            ),
                            // button
                            Row(
                              children: [
                                FilledButton(onPressed: vm.runOnce, child: const Text('Run once')),
                                const SizedBox(width: 8),
                                FilledButton.tonal(onPressed: () => vm.runBatch(10), child: const Text('Run batch ×10')),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: vm.clearSummary,
                                  icon: const Icon(Icons.clear_all),
                                  label: const Text('Clear stats'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // --- result and summary ---
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '最後結果：${vm.lastResponse?.toString() ?? '(尚未執行)'}',
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(child: Text('Total: ${vm.total}')),
                                Expanded(child: Text('Auth: ${vm.handledByAuth} / Spam: ${vm.handledBySpam}')),
                                Expanded(child: Text('Validation: ${vm.handledByValidation} / Tier1: ${vm.handledByTier1}')),
                                Expanded(child: Text('Tier2: ${vm.handledByTier2} / Manager: ${vm.handledByManager}')),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '說明：某 Handler 回傳 Response 即早停；例如 Spam/Validation 拒絕，或 Tier1/Tier2/Manager 完成處理。',
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(height: 24),

                    // --- log ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 300, // 給予固定高度
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: vm.logs.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) => Text(
                            vm.logs[i],
                            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
