///
/// proxy_demo.dart
/// ProxyDemoPage
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import 'pattern/proxy_context.dart';
import 'pattern/proxy_service.dart';
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
  // key input controller
  final _keyController = TextEditingController(text: 'article-100');

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

        final theme = Theme.of(context);

        // 同步輸入框
        _keyController.value = _keyController.value.copyWith(text: vm.lastKey);

        return Scaffold(
            appBar: AppBar(
              title: const Text('Proxy Pattern Demo'),
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
                        '展示 Proxy（代理）如何在不改變用戶端介面的前提下，加入「延遲載入」、「存取控制」、「快取」、「紀錄」等橫切需求。',
                        '選擇不同 Proxy 組合（Virtual/Protection/Caching/Logging/Composite），輸入 Key 後進行一次或批次讀取。',
                        '統計卡顯示：總請求、真實服務呼叫次數、快取命中/未命中；清單與 Log 可觀察各代理的實際行為。',
                      ],
                    ),
                    const SizedBox(height: 16),
                    /// --- 控制列：選擇 Proxy + 角色 + Key ---
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text('Proxy：'),
                                const SizedBox(width: 8),
                                SegmentedButton<ProxyKind>(
                                  segments: const [
                                    ButtonSegment(value: ProxyKind.virtualOnly, label: Text('Virtual')),
                                    ButtonSegment(value: ProxyKind.protectionOnly, label: Text('Protection')),
                                    ButtonSegment(value: ProxyKind.cachingOnly, label: Text('Caching')),
                                    ButtonSegment(value: ProxyKind.loggingAndCaching, label: Text('Logging+Caching')),
                                    ButtonSegment(value: ProxyKind.compositeAll, label: Text('Composite')),
                                  ],
                                  selected: {vm.selectedKind},
                                  onSelectionChanged: (s) => vm.selectKind(s.first),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Text('角色：'),
                                const SizedBox(width: 8),
                                SegmentedButton<AccessRole>(
                                  segments: const [
                                    ButtonSegment(value: AccessRole.guest, label: Text('Guest')),
                                    ButtonSegment(value: AccessRole.user, label: Text('User')),
                                    ButtonSegment(value: AccessRole.admin, label: Text('Admin')),
                                  ],
                                  selected: {vm.role},
                                  onSelectionChanged: (s) => vm.setRole(s.first),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 280,
                                  child: TextField(
                                    controller: _keyController,
                                    decoration: const InputDecoration(
                                      labelText: 'Key',
                                      hintText: 'e.g., article-100',
                                    ),
                                    onChanged: vm.setKey,
                                  ),
                                ),

                              ],
                            ),
                          ],

                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // --- Button ---
                    Row(
                      children: [
                        FilledButton(onPressed: vm.fetchOnce, child: const Text('Fetch once')),
                        const SizedBox(width: 8),
                        FilledButton.tonal(
                          onPressed: () => vm.fetchBatch(10),
                          child: const Text('Fetch batch ×10'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: vm.clearResults,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear results'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // --- Summary ---
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text('Total requests: ${vm.totalRequests}')),
                                Expanded(child: Text('Real service calls: ${vm.serviceCalls}')),
                                Expanded(child: Text('Cache hits: ${vm.cacheHits} / misses: ${vm.cacheMisses}')),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '說明：快取命中代表直接回覆，不會呼叫真實服務；Protection 在 Guest 角色下會回覆 403，不計入實際呼叫。',
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(height: 24),

                    // --- Result（Card + ListView.separated）---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Results:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 400, // 給結果清單一個固定高度，或者根據需求調整
                      child: Card(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: vm.results.length,
                          separatorBuilder: (_, __) => const Divider(height: 12),
                          itemBuilder: (_, i) {
                            final d = vm.results[i];
                            return ListTile(
                              leading: CircleAvatar(child: Text('${i + 1}')),
                              title: Text('${d.key}  (${d.source})'),
                              subtitle: Text(d.content),
                              trailing: Text(d.at.toLocal().toString()),
                            );
                          },
                        ),
                      ),
                    ),

                    // --- logs ---
                    if (vm.logs.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 140,
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