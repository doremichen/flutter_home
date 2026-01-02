///
/// flyweight_demo.dart
/// FlyweightDemoPage
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'flyweight_settings_page.dart';
import 'util/flyweight_util.dart';
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
            title: const Text('Flyweight 享元控制台'),
            actions: [
              // 跳轉至設定與新增頁面
              IconButton(
                icon: const Icon(Icons.add_box_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FlyweightSettingsPage(vm: vm)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: vm.clearAll,
                tooltip: '清除所有物件',
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // 固定頂部：模式說明
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _InfoBanner(
                    title: 'Flyweight 核心理念',
                    lines: const ['共享不變的內在狀態（Sprite），僅保存變動的外在狀態（座標）。'],
                  ),
                ),

                const SizedBox(height: 16),
                // 中間可捲動區：記憶體統計與物件列表
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildMemoryStatsCard(vm, context), // 記憶體對比卡片
                        const SizedBox(height: 16),
                        _buildRecentObjectsList(vm), // 最近生成的物件
                      ],
                    ),
                  ),
                ),

                // 固定底部：快速導向與日誌摘要
                _buildBottomActionPanel(context, vm),

              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildMemoryStatsCard(FlyweightViewModel vm, BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('效能統計數據', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Icon(Icons.analytics_outlined, color: theme.colorScheme.primary),
              ],
            ),
            const Divider(height: 24),
            _buildStatItem('物件總數', '${vm.totalObjects}', color: Colors.black87),
            _buildStatItem('唯一共享元 (Sprites)', '${vm.uniqueFlyweights}', color: Colors.blue.shade700),
            const SizedBox(height: 12),

            // 記憶體對比區塊
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMemoryRow('享元模式 (Shared)', '${vm.memoryWithFlyweightKB.toStringAsFixed(2)} KB'),
                  const SizedBox(height: 4),
                  _buildMemoryRow('傳統模式 (Naive)', '${vm.memoryNaiveKB.toStringAsFixed(2)} KB'),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('節省空間', style: TextStyle(fontWeight: FontWeight.bold)),
                      Flexible(
                        child: Text(
                          '-${vm.memorySavingKB.toStringAsFixed(2)} KB (${vm.memorySavingPct.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 輔助小組件：顯示單行統計
  Widget _buildStatItem(String label, String value, {required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  // 輔助小組件：顯示記憶體 KB
  Widget _buildMemoryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildRecentObjectsList(FlyweightViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('最近生成的物件 (最新 50 筆)', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        vm.objects.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
          shrinkWrap: true, // 必須，因為在 SingleChildScrollView 內
          physics: const NeverScrollableScrollPhysics(), // 滾動由外層 SingleChildScrollView 負責
          itemCount: vm.objects.length > 50 ? 50 : vm.objects.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 70),
          itemBuilder: (_, i) {
            // 反向取值，最新的在最上面
            final index = vm.objects.length - 1 - i;
            final obj = vm.objects[index];

            return ListTile(
              title: Text(
                '${obj.sprite.type} [#${index + 1}]',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '位置: (${obj.x.toInt()}, ${obj.y.toInt()}) | 共享 Sprite ID: ${obj.sprite.hashCode.toString().substring(0, 5)}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Text(
                '${obj.sprite.sizeKB} KB',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.hourglass_empty, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          const Text('目前尚無物件，點擊右上角新增', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBottomActionPanel(BuildContext context, FlyweightViewModel vm) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 日誌摘要區域 (固定高度的終端機感日誌)
          if (vm.logs.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('系統運行日誌', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                Text('${vm.logs.length} 筆', style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 80, // 固定高度，防止長度失控
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  reverse: true, // 讓最新的日誌出現在最下面並自動捲動
                  itemCount: vm.logs.length,
                  itemBuilder: (context, index) {
                    // 反向取值顯示最新
                    final logIdx = vm.logs.length - 1 - index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '> ${vm.logs[logIdx]}',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 2. 動作按鈕：導向設定頁面
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FlyweightSettingsPage(vm: vm)),
              ),
              icon: const Icon(Icons.settings_suggest),
              label: const Text('開啟配置面板並新增物件', style: TextStyle(fontWeight: FontWeight.bold)),
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