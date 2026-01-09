
///
/// composite_demo.dart
/// CompositeDemoPage
///
/// Created by Adam Chen on 2025/12/1
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'composite_log_page.dart';
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

        return Scaffold(
          appBar: AppBar(
            title: const Text('組合模式 (Composite)'),
            actions: [
              IconButton(
                icon: Badge(
                  label: Text('${vm.logs.length}'),
                  child: const Icon(Icons.list_alt),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: vm,
                        child: const CompositeLogPage(),
                      ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // info
                  _buildInfoBanner(),
                  const SizedBox(height: 16),

                  // Selection Preview
                  _buildSelectionPreview(vm),
                  const Divider(height: 32, thickness: 1, color: Colors.black12),

                  // 樹狀清單與控制面板
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      // 給予一個足夠的最小高度，確保 TreeView 在沒鍵盤時看起來很完整
                      minHeight: 300,
                      // 也可以使用 MediaQuery 動態計算高度，避免在大螢幕顯得太短
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 左側：樹狀檔案瀏覽器 (佔據較大空間)
                        Expanded(
                          flex: 3,
                          child: _buildTreeView(vm),
                        ),
                        const VerticalDivider(width: 24),
                        // 右側：控制面板
                        Expanded(
                          flex: 2,
                          child: _buildControlPanel(vm),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // button
                  _buildActionButtons(vm),
                  const SizedBox(height: 16),
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
              title: '組合模式 (Composite)',
              lines: const [
                '展示組合模式：以樹狀結構統一處理「檔案（Leaf）」與「資料夾（Composite）」。',
                '選取任一節點後，可新增檔案/資料夾、重新命名、移除；資料夾節點的大小為其所有子節點大小總和。',
                '樹狀清單提供展開/收合，示範對整體與部分以同一介面操作的好處（可擴充、低耦合）。',
              ]
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionPreview(CompositeViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade100, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.amber.shade50,
            child: Icon(Icons.info_outline, color: Colors.amber.shade800),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '選取節點：${vm.selectedName}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '總計大小：${vm.selectedSize} bytes',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                // 樹狀圖快速操作
                TextButton(onPressed: vm.expandAll, child: const Text('展開全部')),
                TextButton(onPressed: vm.collapseAll, child: const Text('收合')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(CompositeViewModel vm) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('節點操作', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 12),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '名稱', isDense: true),
            ),

            const SizedBox(height: 8),
            TextField(
              controller: _sizeController,
              decoration: const InputDecoration(labelText: '大小 (僅限檔案)', isDense: true),
              keyboardType: TextInputType.number,
            ),
          ],
      ),
    );
  }

  Widget _buildActionButtons(CompositeViewModel vm) {
    return Column(
      children: [
        // 第一組：新增操作
        _buildButtonPair(
          left: ElevatedButton(
            onPressed: () {
              if (_nameController.text.isEmpty) return;
              vm.addFolder(name: _nameController.text);
              _nameController.clear();
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
            child: const Text('新增資料夾', style: TextStyle(fontSize: 12)),
          ),
          right: ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final size = int.tryParse(_sizeController.text) ?? 0;
              if (name.isEmpty || size <= 0) return;
              vm.addFile(name: name, size: size);
              _nameController.clear();
              _sizeController.clear();
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
            child: const Text('新增檔案', style: TextStyle(fontSize: 12)),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(),
        ),

        // 第二組：編輯操作
        _buildButtonPair(
          left: OutlinedButton.icon(
            onPressed: () {
              if (_nameController.text.isEmpty) return;
              vm.renameSelected(_nameController.text);
              _nameController.clear();
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('重命名', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          right: OutlinedButton.icon(
            onPressed: vm.removeSelected,
            icon: const Icon(Icons.delete_outline, size: 16),
            label: const Text('移除選取', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonPair({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 8), // 左右按鈕間距
        Expanded(child: right),
      ],
    );
  }

  Widget _buildTreeView(CompositeViewModel vm) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: vm.VisibleRows.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade100,
            indent: 48, // 讓線條避開圖示部分
          ),
          itemBuilder: (_, index) {
            final row = vm.VisibleRows[index];
            final n = row.node;
            final isSelected = n.id == vm.selectedId;
            final isExpanded = vm.expandedIds.contains(n.id);

            return Material(
              color: isSelected ? theme.colorScheme.primaryContainer.withOpacity(0.3) : Colors.transparent,
              child: InkWell(
                onTap: () => vm.select(n.id),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 12.0 + (row.depth * 20.0), // 增加縮排感
                    right: 12,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      // --- 前置圖示 (資料夾/檔案) ---
                      _buildNodeIcon(n, isExpanded),

                      const SizedBox(width: 12),

                      // --- 名稱與大小 ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? theme.colorScheme.primary : Colors.black87,
                              ),
                            ),
                            Text(
                              '${n.size} bytes',
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),

                      // --- 展開/收合按鈕 (僅資料夾顯示) ---
                      if (n.isFolder)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            isExpanded ? Icons.arrow_drop_down_circle : Icons.arrow_drop_down_circle_outlined,
                            color: Colors.amber.shade700,
                            size: 20,
                          ),
                          onPressed: () => vm.toggleExpand(n.id),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 輔助方法：根據節點狀態決定圖示
  Widget _buildNodeIcon(dynamic n, bool isExpanded) {
    if (n.isFolder) {
      return Icon(
        isExpanded ? Icons.folder_open : Icons.folder,
        color: Colors.amber.shade700,
        size: 24,
      );
    } else {
      return Icon(
        Icons.insert_drive_file_outlined,
        color: Colors.blue.shade600,
        size: 22,
      );
    }
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