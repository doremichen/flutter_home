///
/// iterator_demo.dart
/// IteratorDemoPage
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'iterator_control_page.dart';
import 'model/genre.dart';
import 'view_model/iterator_view_model.dart';

class IteratorDemoPage extends StatelessWidget {
  const IteratorDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IteratorViewModel(),
      child: const _IteratorDemoBody(),
    );
  }
}

class _IteratorDemoBody extends StatelessWidget{
  const _IteratorDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<IteratorViewModel>(
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

        return Scaffold(
            appBar: AppBar(
              title: const Text('Iterator Pattern Demo'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.tune), // 跳轉設定
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: vm,
                        child: const IteratorControlPage(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Clear logs',
                  icon: const Icon(Icons.delete),
                  onPressed: vm.clearLogs,
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // info banner
                    Expanded(flex: 1, child: _buildInfoBanner()),
                    const SizedBox(height: 12),

                    // result card
                    Expanded(flex: 1, child: _buildResultCard(context, vm)),
                    const SizedBox(height: 12),

                    // logs card
                    Expanded(flex: 1, child: _buildLogsCard(context, vm)),
                  ],
                ),
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
          title: '此 Demo 的目的',
          lines: const [
            '展示 Iterator（疊代器）如何提供一致的遍歷介面。',
            '支援 Forward / Reverse / Filter / Step 等迭代方式。',
            '可觀察已產出數量與是否到尾端。',
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, IteratorViewModel vm) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top progress status
              _topProgressStatus(context, vm),
              const SizedBox(height: 8),
              // progress indicator
              _progressIndicator(context, vm),
              const SizedBox(height: 8),
              // song list
              Row(
                children: [
                  const Icon(Icons.history, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text('Yielded Songs', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  if (vm.yielded.isNotEmpty)
                    Text('${vm.yielded.length} 首', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              _songList(context, vm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogsCard(BuildContext context, IteratorViewModel vm) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // logs title
          _logsTitle(context, vm),
          const SizedBox(height: 8),

          // log content
          _logsContent(context, vm),
        ],
      ),
    );
  }

  Widget _topProgressStatus(BuildContext context, IteratorViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '播放進度',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
        ),
        // status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: vm.reachedEnd ? Colors.green.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            vm.reachedEnd ? '已到尾端' : '已產出 ${vm.yieldedCount} 首',
            style: TextStyle(
              fontSize: 10,
              color: vm.reachedEnd ? Colors.green : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _progressIndicator(BuildContext context, IteratorViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: vm.playList.songsLength > 0 ? vm.yieldedCount / vm.playList.songsLength : 0,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${vm.yieldedCount}/${vm.playList.songsLength}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
        ),
      ],
    );
  }

  Widget _songList(BuildContext context, IteratorViewModel vm) {
    return Container(
      height: 200, // 稍微拉高一點，視覺較不壓迫
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: vm.yielded.isEmpty
          ? const Center(child: Text('尚未產出內容', style: TextStyle(color: Colors.grey)))
          : Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: vm.yielded.length,
          itemBuilder: (_, i) {
            final s = vm.yielded[i];
            return ListTile(
              dense: true, // 緊湊模式更適合卡片內列表
              visualDensity: VisualDensity.compact,
              leading: Text(
                '#${(i + 1).toString().padLeft(2, '0')}',
                style: const TextStyle(fontFamily: 'monospace', color: Colors.grey),
              ),
              title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(
                '${s.artist} • ${s.genre.label}',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: Text('${s.durationSec}s', style: const TextStyle(fontSize: 11)),
            );
          },
        ),
      ),
    );
  }

  Widget _logsTitle(BuildContext context, IteratorViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Icons.terminal, size: 18, color: Colors.grey),
            SizedBox(width: 8),
            Text('操作日誌 (Logs)', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),

        if (vm.logs.isNotEmpty)
          Text(
            '共 ${vm.logs.length} 筆',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
      ],
    );
  }

  Widget _logsContent(BuildContext context, IteratorViewModel vm) {
    return Container(
      height: 100, // 稍微增加高度
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: vm.logs.isEmpty
        ? const Center(child: Text('尚未產出內容', style: TextStyle(color: Colors.grey)))
        : Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: vm.logs.length,
          itemBuilder: (_, i) {
            final logEntry = vm.logs[vm.logs.length - 1 - i]; // 逆序顯示最新操作
            final isError = logEntry.toUpperCase().contains('ERROR');

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // time and number
                    Text(
                      '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Colors.grey.withValues(alpha: 0.7),
                      ),
                    ),
                    const Text('• ', style: TextStyle(color: Colors.blue)),
                    // Log content
                    Expanded(
                      child: Text(
                        logEntry,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: isError ? Colors.redAccent : Colors.black87,
                        ),
                      ),
                    ),
                  ],
              ),
            );


          }
        ),
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