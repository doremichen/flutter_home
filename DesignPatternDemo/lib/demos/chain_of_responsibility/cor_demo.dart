///
/// cor_demo.dart
/// CoRDemoPage
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cor_settings_page.dart';
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

class _CoRDemoBody extends StatelessWidget {
  const _CoRDemoBody();

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


          return Scaffold(
            appBar: AppBar(
              title: const Text('責任鍊 (CoR)'),
              actions: [
                IconButton(
                  tooltip: '進入設定',
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // 跳轉到設定頁面
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: vm,
                            child: CoRSettingsPage(),
                          )
                      ),
                    );
                  },
                ),
                IconButton(
                  tooltip: '清除日誌',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: vm.clearLogs,
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
                  // summary card
                  Expanded(
                    child: _buildCoRSummaryCard(context, vm),
                  ),
                  const SizedBox(height: 8),
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
        padding: const EdgeInsets.all(8),
        child: _InfoBanner(
          title: '責任鏈 (CoR)',
          lines: const [
            '展示責任鏈：請求依序通過多個處理者（Handler），每個節點可選擇「處理並早停」或「傳遞給下一個」。',
            '範例鏈：Auth → Spam → Validation → Tier1 → Tier2 → Manager；可動態啟用/停用某些節點並觀察影響。',
            '適用情境：驗證/分流/規則匹配/事件分派/編譯管線等，利於責任分離與擴充。',
          ],
        ),
      ),
    );
  }

  Widget _buildCoRSummaryCard(BuildContext context, CoRViewModel vm) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(12),
      child: SingleChildScrollView( // 防止內容過多時溢出
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '最後結果：${vm.lastResponse?.toString() ?? '(尚未執行)'}',
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                Text('全部: ${vm.total}'),
                Text('身份驗證: ${vm.handledByAuth}'),
                Text('垃圾郵件: ${vm.handledBySpam}'),
                Text('驗證: ${vm.handledByValidation}'),
                Text('Tier1: ${vm.handledByTier1}'),
                Text('Tier2: ${vm.handledByTier2}'),
                Text('主管: ${vm.handledByManager}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomLogPanel(BuildContext context, CoRViewModel vm) {
    if (vm.logs.isEmpty) {
      return const Center(child: Text('暫無代理路徑紀錄', style: TextStyle(color: Colors.grey)));
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
              const Text('代理執行路徑紀錄', style: TextStyle(color: Colors.white70, fontSize: 11)),
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
