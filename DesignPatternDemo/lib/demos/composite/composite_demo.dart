
///
/// composite_demo.dart
/// CompositeDemoPage
///
/// Created by Adam Chen on 2025/12/1
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/composite_view_model.dart';

class CompositeDemoPage extends StatelessWidget {

  const CompositeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompositeViewModel(),
      child: const _CompositeDemoBody(),
    );
  }

}

class _CompositeDemoBody extends StatefulWidget {
  const _CompositeDemoBody();

  @override
  State<_CompositeDemoBody> createState() => _CompositeDemoBodyState();
}

class _CompositeDemoBodyState  extends State<_CompositeDemoBody> {
  // input controller
  final _nameController = TextEditingController();
  final _sizeController = TextEditingController();


  @override
  void dispose() {
    // release input controller
    _nameController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompositeViewModel>(
      builder: (context, vm, _) {
        // toast message
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
            title: const Text('Composite Pattern Demo'),
            actions: [
              IconButton(
                tooltip: 'Clear logs',
                icon: const Icon(Icons.delete),
                onPressed: vm.clearLogs,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// --- 說明卡（與其他 Demo 一致） ---
                _InfoBanner(
                  title: '此 Demo 的目的',
                  lines: const [
                    '展示 Composite 模式：以樹狀結構統一處理「檔案（Leaf）」與「資料夾（Composite）」。',
                    '選取任一節點後，可新增檔案/資料夾、重新命名、移除；資料夾節點的大小為其所有子節點大小總和。',
                    '樹狀清單提供展開/收合，示範對整體與部分以同一介面操作的好處（可擴充、低耦合）。',
                  ],
                ),
                const SizedBox(height: 16),

                /// --- 目前選取資訊 + 控制列 ---
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '選取：${vm.selectedName} | size=${vm.selectedSize} bytes',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            FilledButton.tonal(
                              onPressed: vm.expandAll,
                              child: const Text('展開全部'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.tonal(
                              onPressed: vm.collapseAll,
                              child: const Text('收合到 root'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: '名稱（檔案或資料夾）',
                                  hintText: '例如：notes.txt / assets',
                                )
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 140,
                              child: TextField(
                                controller: _sizeController,
                                decoration: const InputDecoration(
                                  labelText: '檔案大小（bytes）',
                                  hintText: '僅檔案用',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: () {
                                final name = _nameController.text;
                                if (name.isEmpty) return;
                                // add folder
                                vm.addFolder(name: name);
                                // clear input
                                _nameController.clear();
                              },
                              child: const Text('新增資料夾'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: () {
                                final name = _nameController.text.trim();
                                final size = int.tryParse(_sizeController.text.trim() == ''
                                    ? '0'
                                    : _sizeController.text.trim())
                                    ?? 0;
                                if (name.isEmpty || size <= 0) return;
                                vm.addFile(name: name, size: size);
                                _nameController.clear();
                                _sizeController.clear();
                              },
                              child: const Text('新增檔案'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: '重新命名（輸入新名稱）',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {
                                final newName = _nameController.text.trim();
                                if (newName.isEmpty) return;
                                vm.renameSelected(newName);
                                _nameController.clear();
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('重新命名'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: vm.removeSelected,
                              icon: const Icon(Icons.remove_circle),
                              label: const Text('移除選取'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// --- 樹狀清單 ---
                Expanded(
                  child: Card(
                    child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: vm.VisibleRows.length,
                        separatorBuilder: (_, __) => const Divider(height: 8),
                        itemBuilder: (_, index) {
                          final row = vm.VisibleRows[index];
                          final n = row.node;
                          final isSelected = n.id == vm.selectedId;

                          return InkWell(
                            onTap: () => vm.select(n.id),
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.0 + row.depth * 16.0, right: 8, top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    n.isFolder ? Icons.folder : Icons.insert_drive_file,
                                    color: n.isFolder ? Colors.amber[700] : theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${n.name}  (${n.size} bytes)',
                                      style: isSelected
                                          ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
                                          : theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                  if (n.isFolder)
                                    IconButton(
                                      tooltip: vm.expandedIds.contains(n.id) ? '收合' : '展開',
                                      icon: Icon(vm.expandedIds.contains(n.id) ? Icons.expand_less : Icons.expand_more),
                                      onPressed: () => vm.toggleExpand(n.id),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
        );
      },
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
    final titleStyle = theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
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