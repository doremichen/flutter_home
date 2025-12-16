
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import 'view_model/decorator_view_model.dart';

class DecoratorDemoPage extends StatelessWidget {

  const DecoratorDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DecoratorViewModel(),
      child: const _DecoratorDemoBody(),
    );
  }

}

class _DecoratorDemoBody extends StatelessWidget {
  const _DecoratorDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<DecoratorViewModel>(
      builder: (context, vm, _) {
        // SnackBar（避免在 build 期間觸發）
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
              title: const Text('Decorator Pattern Demo'),
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
                  _InfoBanner(
                    title: '此 Demo 的目的',
                    lines: const [
                      '展示 Decorator（裝飾者）如何以「包裝」方式，動態為物件添加功能與屬性，而不需改動原類別。',
                      '左側選擇基底飲品（Espresso/House/Dark），右側按鈕可逐一套用裝飾（Milk/Mocha/...）。',
                      '下方狀態卡與明細列會即時顯示目前的組成與總價，支援撤銷最後一個裝飾與清空所有裝飾。',
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- select + operator ----
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text('Espresso'),
                              selected: vm.selectedBase == BaseKind.espresso,
                              onSelected: (_) => vm.selectBase(BaseKind.espresso),
                            ),
                            ChoiceChip(
                              label: const Text('House Blend'),
                              selected: vm.selectedBase == BaseKind.house,
                              onSelected: (_) => vm.selectBase(BaseKind.house),
                            ),
                            ChoiceChip(
                              label: const Text('Dark Roast'),
                              selected: vm.selectedBase == BaseKind.dark,
                              onSelected: (_) => vm.selectBase(BaseKind.dark),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: vm.undoLast,
                              icon: const Icon(Icons.undo),
                              label: const Text('Undo last'),
                            ),
                            OutlinedButton.icon(
                              onPressed: vm.clearDecorators,
                              icon: const Icon(Icons.clear_all),
                              label: const Text('Clear decorators'),
                            ),
                          ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // --- decorator buttons ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonal(
                          onPressed: () => vm.applyDecorator(DecoratorKind.milk),
                          child: const Text('Add Milk (+10)'),
                        ),
                        FilledButton.tonal(
                          onPressed: () => vm.applyDecorator(DecoratorKind.mocha),
                          child: const Text('Add Mocha (+15)'),
                        ),
                        FilledButton.tonal(
                          onPressed: () => vm.applyDecorator(DecoratorKind.whip),
                          child: const Text('Add Whip (+12)'),
                        ),
                        FilledButton.tonal(
                          onPressed: () => vm.applyDecorator(DecoratorKind.soy),
                          child: const Text('Add Soy (+8)'),
                        ),
                        FilledButton.tonal(
                          onPressed: () => vm.applyDecorator(DecoratorKind.sugar),
                          child: const Text('Add Sugar (+2)'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- Status Card ---
                  Card(
                    child:Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.local_cafe, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Composition: ${vm.description}', style: theme.textTheme.bodyLarge),
                                const SizedBox(height: 6),
                                Text(
                                  'Total: \$${vm.totalCost.toStringAsFixed(2)}',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 24),

                  // --- breakdown ---
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Breakdown:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Card(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: vm.breakdown.length,
                        separatorBuilder: (_, __) => const Divider(height: 12),
                        itemBuilder: (_, i) {
                          final li = vm.breakdown[i];
                          return Row(
                            children: [
                              Expanded(child: Text(li.label)),
                              Text('\$${li.price.toStringAsFixed(2)}'),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

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
      },
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