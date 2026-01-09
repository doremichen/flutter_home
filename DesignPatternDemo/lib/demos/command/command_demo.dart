///
/// command_demo.dart
/// CommandDemoPage
///
/// Created by Adam Chen on 2025/12/22.
/// Copyright © 2025 Abb company. All rights reserved.
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'command_control_page.dart';
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
            title: const Text('命令模式 (Command)'),
            actions: [
              IconButton(
                tooltip: '進入控制台',
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // 跳轉到設定頁面
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: vm,
                          child: const CommandControlPage(),
                        )
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: '清除所有',
                icon: const Icon(Icons.delete_outline),
                onPressed: vm.clearAll,
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // info banner
                Expanded(
                  child: _buildInfoBanner(),
                ),
                const SizedBox(height: 8),

                // Status card
                Expanded(
                  child: _buildCommandSummaryCard(context, vm),
                ),
                const SizedBox(height: 8),

                // History
                Expanded(
                  child: _buildCommandHistory(context, vm),
                ),
                const Divider(height: 8),

                // system log
                Expanded(
                  child: _buildBottomLogPanel(context, vm),
                ),

              ],

            ),

          ),

        );
      }
    );
  }

  Widget _buildInfoBanner() {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _InfoBanner(
          title: '命令模式 (Command)',
          lines: const [
            '展示命令模式如何將「操作」封裝成物件，支援排程、紀錄、撤銷/重作 與宏命令。',
            '輸入數值後，透過加/減/乘/除等命令更新計算；可執行撤銷/重作回復狀態。',
            '宏命令將多個命令視為一個，執行時依序呼叫，撤銷時反向回滾。',          ],
        ),
      ),
    );
  }

  Widget _buildCommandSummaryCard(BuildContext context, CommandViewModel vm) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
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
    );
  }

  Widget _buildCommandHistory(BuildContext context, CommandViewModel vm) {
    if (vm.history.isEmpty) {
      return const Center(child: Text('暫無歷史紀錄', style: TextStyle(color: Colors.grey)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('歷史紀錄:', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Card(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.history.length,
              separatorBuilder: (_, __) => const Divider(height: 12),
              itemBuilder: (_, i) => Text(vm.history[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomLogPanel(BuildContext context, CommandViewModel vm) {
    if (vm.logs.isEmpty) {
      return const Center(child: Text('暫無Log紀錄', style: TextStyle(color: Colors.grey)));
    }
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('命令執行紀錄', style: TextStyle(color: Colors.white70, fontSize: 11)),
              IconButton(icon: const Icon(Icons.delete_sweep, size: 16, color: Colors.white70), onPressed: vm.clearLogs),
            ],
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: vm.logs.length,
              itemBuilder: (_, i) => Text('> ${vm.logs[vm.logs.length - 1 - i]}',
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontFamily: 'monospace')),
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