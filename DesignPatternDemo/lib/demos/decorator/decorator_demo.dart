///
/// decorator_demo.dart
/// DecoratorDemoPage
///
/// Created by Adam Chen on 2025/12/31
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.takeLastToast();
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text('裝飾模式 (Decorator)'),
            actions: [
              IconButton(
                icon: Badge(
                  label: Text('${vm.logs.length}'),
                  child: const Icon(Icons.receipt_long),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: vm,
                        child: const DecoratorLogPage(),
                      ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // info banner
                  _buildInfoBanner(),
                  const SizedBox(height: 16),
                  _buildCoffeePreview(vm),

                  const Divider(height: 32, thickness: 1, color: Colors.black12),

                  // Control region
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildControlPanel(vm),
                    ),
                  ),

                  const Divider(height: 32, thickness: 1, color: Colors.black12),

                  // --- 3. 固定底部 (操作按鈕) ---
                  // 這部分會被推到螢幕最下方，且不會隨中間內容滾動
                  _buildActionButtons(vm),
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
              title: '裝飾模式 (Decorator)',
              lines: const [
                '展示裝飾模式如何以「包裝」方式，動態為物件添加功能與屬性，而不需改動原類別。',
                '1.選擇基底飲品（Espresso/House/Dark），2. 添加裝飾（Milk/Mocha/...），3. 訂單管理（撤銷/清空）。',
                '下方狀態卡與明細列會即時顯示目前的組成與總價，支援撤銷最後一個裝飾與清空所有裝飾。',
              ]
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
          BoxShadow(color: Colors.black.withValues(), blurRadius: 10, offset: const Offset(0, 4))
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
        const Text('1. 選擇基底飲品 (Base)',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _baseChip(vm, '濃縮咖啡', BaseKind.espresso),
            _baseChip(vm, '自家混合', BaseKind.house),
            _baseChip(vm, '深烘焙', BaseKind.dark),
          ],
        ),
        const SizedBox(height: 24),
        const Text('2. 添加裝飾 (Decorators)',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 12),
        _buildButtonPair(
          left: _decoBtn(vm, '加牛奶（+10）', DecoratorKind.milk),
          right: _decoBtn(vm, '加摩卡（+15）', DecoratorKind.mocha),
        ),
        const SizedBox(height: 8),
        _buildButtonPair(
          left: _decoBtn(vm, '增加鞭子（+12）', DecoratorKind.whip),
          right: _decoBtn(vm, '加豆奶（+8）', DecoratorKind.soy),
        ),
        const SizedBox(height: 8),
        _buildButtonPair(
          left: _decoBtn(vm, '加糖（+2）', DecoratorKind.sugar),
          right: const SizedBox.shrink(),
        ),
        // 這裡可以放更多未來會增加的裝飾項目...
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

  Widget _buildActionButtons(DecoratorViewModel vm) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('3. 訂單管理', style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        ),
        const SizedBox(height: 12),
        _buildButtonPair(
          left: OutlinedButton.icon(
            onPressed: vm.undoLast,
            icon: const Icon(Icons.undo, size: 18),
            label: const Text('撤銷', style: TextStyle(fontSize: 12)),
          ),
          right: OutlinedButton.icon(
            onPressed: vm.clearDecorators,
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('清空裝飾', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ),
      ],
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