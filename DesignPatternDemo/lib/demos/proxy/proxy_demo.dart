///
/// proxy_demo.dart
/// ProxyDemoPage
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'proxy_settings_page.dart';
import 'view_model/proxy_view_model.dart';

class ProxyDemoPage extends StatelessWidget {

  const ProxyDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProxyViewModel(),
      child: const _ProxyDemoBody(),
    );
  }
}

class _ProxyDemoBody extends StatefulWidget {
  const _ProxyDemoBody();

  @override
  State<StatefulWidget> createState() => _ProxyDemoBodyState();
}

class _ProxyDemoBodyState extends State<_ProxyDemoBody> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ProxyViewModel>(
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
            title: const Text('Proxy 代理模式監控'),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune), // 跳轉設定
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProxySettingsPage(vm: vm)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: vm.clearResults,
                tooltip: '清空結果',
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // info banner
                _buildInfoBanner(),

                // summary card
                _buildProxySummaryCard(vm),

                // result list
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('請求結果',
                          style: TextStyle(fontWeight: FontWeight.bold))
                          ),
                ),
                Expanded(
                  child: _buildResultsList(vm),
                ),

                // system log
                _buildBottomLogPanel(context, vm),
              ],
            ),
          ),
        );
      }
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
              '展示 Proxy（代理）如何在不改變用戶端介面的前提下，加入「延遲載入」、「存取控制」、「快取」、「紀錄」等橫切需求。',
              '選擇不同 Proxy 組合（Virtual/Protection/Caching/Logging/Composite），輸入 Key 後進行一次或批次讀取。',
              '統計卡顯示：總請求、真實服務呼叫次數、快取命中/未命中；清單與 Log 可觀察各代理的實際行為。',
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProxySummaryCard(ProxyViewModel vm) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // title bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: Text('總請求: ${vm.totalRequests}')),
                Expanded(child: Text('真實服務: ${vm.serviceCalls}')),
                Expanded(child: Text('快取命中: ${vm.cacheHits} / misses: ${vm.cacheMisses}')),
              ],
            ),
            const Divider(),
            // summary
            Text('當前 Proxy: ${vm.selectedKind.name}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(ProxyViewModel vm) {
    if (vm.results.isEmpty) {
      return const Center(child: Text('尚無請求紀錄', style: TextStyle(color: Colors.grey)));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vm.results.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) {
        // 最新的結果顯示在最上方
        final reverseIndex = vm.results.length - 1 - i;
        final result = vm.results[reverseIndex];

        return ListTile(
          leading: Icon(
            result.source == 'Cache' ? Icons.bolt : Icons.cloud_download,
            color: result.source == 'Cache' ? Colors.orange : Colors.blue,
          ),
          title: Text('Key: ${result.key}'),
          subtitle: Text(result.content),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(result.source, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
              Text(
                '${result.at.minute}:${result.at.second}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomLogPanel(BuildContext context, ProxyViewModel vm) {
    if (vm.logs.isEmpty) return const SizedBox.shrink(); // 如果為空，直接不佔位

    return Container(
      height: 150, // 稍微高一點，因為 Proxy 的日誌通常較長（包含權限檢查）
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