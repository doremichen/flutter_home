///
/// abstractory_factory_demo.dart
/// AbstractFactoryDemoPage
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'view_model/absfactory_vm.dart';
import 'package:flutter/material.dart';
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
          backgroundColor: Colors.grey.shade50, // 全局淺色背景
          appBar: AppBar(
            title: const Text('Abstract Factory Demo'),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            actions: [
              IconButton(
                tooltip: '全部清除',
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('全部清除'),
                      content: const Text('移除所有已建立的車輛?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('取消'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('確認'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) vm.clearAll();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Material(
              color: Colors.transparent, // 關鍵：透明背景，顯示 Scaffold 的背景色
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 上半部：可捲動的說明 Banner
                    _buildHeaderSection(),

                    const Divider(height: 32, thickness: 1, color: Colors.black12),

                    // 下半部：左右並排佈局
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 左側：控制面板
                          _buildLeftControlPanel(vm),

                          const VerticalDivider(width: 32, thickness: 1, color: Colors.black12),

                          // 右側：結果清單
                          Expanded(child: _buildResultList(vm)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 140), // 給定一個固定或比例高度
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 8), // 留點空間給滾動條
          child: _InfoBanner(
            title: '此 Demo 的目的',
            lines: const [
              '展示 Abstract Factory 如何產生「一組相互匹配的產品族」，以維持風格與相容性的一致。',
              '左方的 ChoiceChip 用來選擇不同零件工廠（跑車/家庭/卡車），建立時會一次產生同系列的零件組合。',
              '右方清單列出已建立的零件套件，便於比較不同工廠的輸出差異與擴充性。',
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildLeftControlPanel(dynamic vm) {
    return SizedBox(
      width: 150, // 稍微調寬一點以容納 ChoiceChip
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('選擇工廠:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            // 工廠選擇器
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(vm.factories.length, (i) {
                return ChoiceChip(
                  label: Text(vm.factories[i].label, style: const TextStyle(fontSize: 11)),
                  selected: vm.selectedIndex == i,
                  onSelected: (_) => vm.selectFactory(i),
                  visualDensity: VisualDensity.compact, // 縮減尺寸以適應窄欄
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('操作:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            // 建立按鈕 (全靠左對齊)
            _buildActionButton(vm),
          ],
        ),
      ),
    );
 }

  Widget _buildActionButton(dynamic vm) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: vm.createMatchedSet,
        icon: const Icon(Icons.build, size: 16),
        label: const Text('產生', style: TextStyle(fontSize: 11)),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          // 內容靠左
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          backgroundColor: Colors.blue.shade50,
          foregroundColor: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildResultList(dynamic vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('結果:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24), // 避開導覽列
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: vm.createdSets.isEmpty
                  ? const Center(child: Text('無資料', style: TextStyle(fontSize: 12)))
                  : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: vm.createdSets.length,
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (_, i) => Text(
                      vm.createdSets[i],
                      style: const TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ),
            ),
          ),
        ),
      ],
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