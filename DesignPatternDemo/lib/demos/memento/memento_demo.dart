///
/// memento_demo.dart
/// MementoDemoPage
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'memento_history_page.dart';
import 'view_model/memento_view_model.dart';

class MementoDemoPage extends StatelessWidget {

  const MementoDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MementoViewModel(),
      child: const _MementoDemoBody(),
    );
  }

}

class _MementoDemoBody extends StatefulWidget {
  const _MementoDemoBody();

  @override
  State<StatefulWidget> createState() => _MementoDemoBodyState();
}

class _MementoDemoBodyState extends State<_MementoDemoBody> {
  // input controller
  late final _textController;
  late final _checkpointController;


  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '');
    _checkpointController = TextEditingController(text: '手動檢查點');

    // add listener
    _textController.addListener(_textChanged);
    _checkpointController.addListener(_checkpointChanged);

  }

  // dispose
  @override
  void dispose() {
    _textController.dispose();
    _checkpointController.dispose();
    super.dispose();
  }

  void _textChanged() {
    final vm = context.read<MementoViewModel>();
    if (_textController.text != vm.stagedText) {
      vm.setStagedText(_textController.text);
    }
  }

  void _checkpointChanged() {
    final vm = context.read<MementoViewModel>();
    var label = _checkpointController.text;
    if (label.isEmpty) label = '手動檢查點';
    vm.saveCheckpoint(label);
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<MementoViewModel>(
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

        final theme = Theme.of(context);
        // synch input
        _textController.value = _textController.value.copyWith(text: vm.stagedText);
        return Scaffold(
          appBar: AppBar(
            title: const Text('備忘錄 (Memento)'),
            actions: [
              // 右上角跳轉至結果清單頁面
              IconButton(
                icon: Badge(
                  label: Text('${vm.history.length}'),
                  child: const Icon(Icons.history),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: vm,
                        child: const MementoHistoryPage(),
                      ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // info banner
                  Expanded(
                    flex: 1,
                    child: _buildInfoBanner(),
                  ),
                  const SizedBox(height: 12,),
                  // main (control and status)
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          // control
                          _buildControlsCard(vm),
                          const SizedBox(height: 8),
                          // status
                          _buildContentStatus(context, vm),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12,),
                  // system log
                  _buildSystemLog(vm),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoBanner() {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(16),
        child: _InfoBanner(
          title: '備忘錄 (Memento)',
          lines: const [
            '展示備忘錄如何將物件狀態封裝成不可變快照（Memento），由 Caretaker 維護，以支援 Undo/Redo 與歷史回溯。',
            'Originator：TextDocument（content + caret）。Caretaker：HistoryManager（維護快照堆疊）。',
            '每次操作都能建立 checkpoint；Undo/Redo 以快照為準恢復狀態，避免暴露內部細節（封裝原則）。',
          ],
        ),
      ),
    );
  }

  Widget _buildControlsCard(MementoViewModel vm) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Staged Text & Apply
            TextField(
              controller: _textController,
              textInputAction: TextInputAction.done,
              maxLines: 3,
              onSubmitted: (_) {
                vm.applySetContent();
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                labelText: '分階段內容',
                hintText: '輸入欲套用的內容',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: vm.applySetContent,
                  icon: const Icon(Icons.send_rounded, color: Colors.blue),
                  tooltip: 'Apply content',
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Caret Slider & Undo/Redo
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('游標位置: ${vm.stagedCaret}', style: Theme.of(context).textTheme.labelSmall),
                      Slider(
                        value: vm.stagedCaret.toDouble().clamp(
                            0.0,
                            vm.document.content.length.toDouble() > 0
                                ? vm.document.content.length.toDouble()
                                : 0.01
                        ),
                        min: 0,
                        max: vm.document.content.length.toDouble() > 0
                            ? vm.document.content.length.toDouble()
                            : 0.01,
                        divisions: vm.document.content.isEmpty ? 1 : vm.document.content.length,
                        onChanged: (v) => vm.setStagedCaret(v.round()),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                IconButton.filledTonal(onPressed: vm.undo, icon: const Icon(Icons.undo, size: 20)),
                const SizedBox(width: 4),
                IconButton.filledTonal(onPressed: vm.redo, icon: const Icon(Icons.redo, size: 20)),
              ],
            ),

            const SizedBox(height: 32),

            _buildQuickAction(vm),

            const SizedBox(height: 32),

            _buildCheckpoint(vm),

          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(MementoViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text('快速編輯', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _actionChip(label: '+ Hello', onTap: () => vm.appendSample('Hello, ')),
                _actionChip(label: '+ World', onTap: () => vm.appendSample('World!')),
                _actionChip(label: '- Del 5', onTap: () => vm.deleteLast(5)),
                _actionChip(label: 'Caret +3', onTap: () => vm.moveCaret(vm.document.caret + 3)),
                _actionChip(label: 'Caret -3', onTap: () => vm.moveCaret(vm.document.caret - 3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionChip({required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildCheckpoint(MementoViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _checkpointController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: '存檔標籤',
              hintText: 'Manual checkpoint',
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => vm.saveCheckpoint(_checkpointController.text.trim().isEmpty
              ? 'Manual' : _checkpointController.text.trim()),
          icon: const Icon(Icons.save_as_rounded),
          style: IconButton.styleFrom(backgroundColor: Colors.green.withValues(alpha: 0.1), foregroundColor: Colors.green),
        ),
        IconButton(
          onPressed: vm.clearAll,
          icon: const Icon(Icons.delete_forever_rounded),
          style: IconButton.styleFrom(backgroundColor: Colors.red.withValues(alpha: 0.1), foregroundColor: Colors.red),
        ),
      ],
    );
  }

  Widget _buildContentStatus(BuildContext context, MementoViewModel vm) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 標題與狀態標籤
            Row(
              children: [
                Icon(Icons.article_outlined, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text('文件實時狀態', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                _buildBadge('LEN: ${vm.document.content.length}'),
                const SizedBox(width: 4),
                _buildBadge('POS: ${vm.document.caret}', isPrimary: true),
              ],
            ),
            const SizedBox(height: 12),

            /// 內容顯示區（類編輯器風格）
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 150), // 限制高度，防止爆版
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: SelectableText.rich(
                  TextSpan(
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.5),
                    children: _buildContentWithCaret(vm.document.content, vm.document.caret),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _buildContentWithCaret(String content, int caret) {
    if (content.isEmpty) {
      return [const TextSpan(text: '(empty)', style: TextStyle(color: Colors.grey))];
    }

    // 確保 caret 不會越界
    final safeCaret = caret.clamp(0, content.length);
    final before = content.substring(0, safeCaret);
    final after = content.substring(safeCaret);

    return [
      TextSpan(text: before),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          width: 2,
          height: 16,
          color: Colors.blueAccent, // 模擬閃爍游標
        ),
      ),
      TextSpan(text: after),
    ];
  }

  Widget _buildBadge(String text, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isPrimary ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          color: isPrimary ? Colors.blue : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildSystemLog(MementoViewModel vm) {
    final theme = Theme.of(context);

    return Container(
      height: 150, // 固定高度，不佔用過多主螢幕空間
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: Border(top: BorderSide(color: theme.dividerColor.withOpacity(0.2))),
      ),
      child: Column(
        children: [
          // 日誌標題列
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.terminal_rounded, size: 14, color: theme.primaryColor),
                    const SizedBox(width: 6),
                    Text('系統日誌', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                // 清空按鈕
                GestureDetector(
                  onTap: () => vm.clearLogs(),
                  child: Text('清除', style: theme.textTheme.labelSmall?.copyWith(color: theme.primaryColor)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 日誌內容區
          Expanded(
            flex: 2,
            child: ListView.builder(
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: vm.logs.length,
              // 建議在 ViewModel 中讓最新的日誌排在最後面，並搭配自動捲動
              itemBuilder: (context, index) {
                final log = vm.logs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    log,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.black87,
                    ),
                  ),
                );
              },
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
