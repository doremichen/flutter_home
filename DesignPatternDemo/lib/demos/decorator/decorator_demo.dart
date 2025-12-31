///
/// decorator_demo.dart
/// DecoratorDemoPage
///
/// Created by Adam Chen on 2025/12/31
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import 'decorator_log_page.dart';
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
            title: const Text('Decorator 模式 Demo'),
            actions: [
              // 右上角跳轉至 Log 頁面
              IconButton(
                icon: Badge(
                  label: Text('${vm.logs.length}'),
                  child: const Icon(Icons.receipt_long),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DecoratorLogPage(vm: vm)),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // info
                    _buildInfoBanner(),

                    const SizedBox(height: 16),

                    // Preview
                    _buildCoffeePreview(vm),

                    const Divider(height: 32, thickness: 1, color: Colors.black12),

                    // control panel
                    _buildControlPanel(vm),
                  ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoBanner() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 140),
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 8),
          child: _InfoBanner(
              title: '此 Demo 的目的',
              lines: const [
                '展示 Decorator（裝飾者）如何以「包裝」方式，動態為物件添加功能與屬性，而不需改動原類別。',
                '左側選擇基底飲品（Espresso/House/Dark），右側按鈕可逐一套用裝飾（Milk/Mocha/...）。',
                '下方狀態卡與明細列會即時顯示目前的組成與總價，支援撤銷最後一個裝飾與清空所有裝飾。',              ]
          ),
        ),
      ),
    );
  }

  Widget _buildCoffeePreview(DecoratorViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade100, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.brown.shade50,
            child: Icon(Icons.local_cafe, color: Colors.brown.shade700, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '目前配方：${vm.description}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '總計金額：\$${vm.totalCost.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, color: Colors.brown.shade800, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(DecoratorViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('1. 選擇基底飲品 (Base)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _baseChip(vm, 'Espresso', BaseKind.espresso),
            _baseChip(vm, 'House Blend', BaseKind.house),
            _baseChip(vm, 'Dark Roast', BaseKind.dark),
          ],
        ),

        const SizedBox(height: 24),
        const Text('2. 添加裝飾 (Decorators)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 12),

        // 使用兩兩平行的封裝方法
        _buildButtonPair(
          left: _decoBtn(vm, 'Add Milk (+10)', DecoratorKind.milk),
          right: _decoBtn(vm, 'Add Mocha (+15)', DecoratorKind.mocha),
        ),
        const SizedBox(height: 8),
        _buildButtonPair(
          left: _decoBtn(vm, 'Add Whip (+12)', DecoratorKind.whip),
          right: _decoBtn(vm, 'Add Soy (+8)', DecoratorKind.soy),
        ),
        const SizedBox(height: 8),
        _buildButtonPair(
          left: _decoBtn(vm, 'Add Sugar (+2)', DecoratorKind.sugar),
          right: Container(), // 奇數按鈕時右側留空或放其他功能
        ),

        const Divider(height: 40),

        const Text('3. 訂單管理', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 12),
        _buildButtonPair(
          left: OutlinedButton.icon(
            onPressed: vm.undoLast,
            icon: const Icon(Icons.undo),
            label: const Text('撤銷最後一項'),
          ),
          right: OutlinedButton.icon(
            onPressed: vm.clearDecorators,
            icon: const Icon(Icons.delete_outline),
            label: const Text('清空裝飾'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ),
      ],
    );
  }

// 輔助方法：兩兩對齊
  Widget _buildButtonPair({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 8),
        Expanded(child: right),
      ],
    );
  }

// 輔助方法：基底選擇 Chip
  Widget _baseChip(DecoratorViewModel vm, String label, BaseKind kind) {
    return ChoiceChip(
      label: Text(label),
      selected: vm.selectedBase == kind,
      onSelected: (_) => vm.selectBase(kind),
    );
  }

// 輔助方法：裝飾按鈕
  Widget _decoBtn(DecoratorViewModel vm, String label, DecoratorKind kind) {
    return FilledButton.tonal(
      onPressed: () => vm.applyDecorator(kind),
      child: Text(label, style: const TextStyle(fontSize: 12)),
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