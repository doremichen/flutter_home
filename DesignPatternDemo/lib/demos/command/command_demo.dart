import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/command_view_model.dart';


class CommandDemoPage extends StatelessWidget {
  const CommandDemoPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommandViewModel(),
      child: const _CommandDemoBody(),
    );
  }
  
}

class _CommandDemoBody extends StatefulWidget {
  const _CommandDemoBody();

  @override
  State<StatefulWidget> createState() => _CommandDemoBodyState();

}

class _CommandDemoBodyState extends State<_CommandDemoBody> {
  // text editor controller
  final _amountController = TextEditingController(text: '10');
  final _setController = TextEditingController(text: '0');

  // dispose
  @override
  void dispose() {
    _amountController.dispose();
    _setController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<CommandViewModel>(
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

        final theme = Theme.of(context);

        // sync input
        _amountController.value = _amountController
            .value
            .copyWith(text: vm.value.toString());

        return Scaffold(
            appBar: AppBar(
              title: const Text('Command Pattern Demo'),
            ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Info Banner ---
                  _InfoBanner(
                    title: '此 Demo 的目的',
                    lines: const [
                      '展示 Command（命令）如何將「操作」封裝成物件，支援排程、紀錄、Undo/Redo 與宏命令。',
                      '輸入數值後，透過加/減/乘/除等命令更新 Calculator；可執行 Undo/Redo 回復狀態。',
                      '宏命令將多個命令視為一個，執行時依序呼叫，撤銷時反向回滾。',
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- Control region: input + basic + macro commands ---
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Input fields
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _amountController,
                                  decoration: const InputDecoration(
                                    labelText: 'Amount',
                                    hintText: '例如：10 / 2',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (t) {
                                    final v = double.tryParse(t) ?? vm.value;
                                    vm.setAmount(v);
                                  },
                                ),
                              ),

                              SizedBox(
                                width: 160,
                                child: TextField(
                                  controller: _setController,
                                  decoration: const InputDecoration(
                                    labelText: 'Set value',
                                    hintText: '例如：0 / 100',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),

                              FilledButton.tonal(
                                onPressed: () {
                                  final v = double.tryParse(_setController.text);
                                  if (v != null) {
                                    vm.setValue(v);
                                  }
                                },
                                child: const Text('Set value'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Basic commands
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              FilledButton(onPressed: vm.add, child: const Text('Add')),
                              FilledButton(onPressed: vm.sub, child: const Text('Subtract')),
                              FilledButton(onPressed: vm.mul, child: const Text('Multiply')),
                              FilledButton(onPressed: vm.div, child: const Text('Divide')),
                              OutlinedButton.icon(
                                onPressed: vm.undo,
                                icon: const Icon(Icons.undo),
                                label: const Text('Undo'),
                              ),
                              OutlinedButton.icon(
                                onPressed: vm.redo,
                                icon: const Icon(Icons.redo),
                                label: const Text('Redo'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Macro commands
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text('宏命令：'),
                              FilledButton.tonal(
                                onPressed: vm.macroBoost,
                                child: const Text('Boost（+amount → ×2）'),
                              ),
                              FilledButton.tonal(
                                onPressed: vm.macroDiscount,
                                child: const Text('Discount（-amount → ÷2）'),
                              ),
                              OutlinedButton.icon(
                                onPressed: vm.clearAll,
                                icon: const Icon(Icons.clear_all),
                                label: const Text('Clear'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- Status card ---
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.calculate, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Current value: ${vm.cal_value.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 24),

                  // --- History ---
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('History:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vm.history.length,
                      separatorBuilder: (_, __) => const Divider(height: 12),
                      itemBuilder: (_, i) => Text(vm.history[i]),
                    ),
                  ),

                  // --- Logs ---
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