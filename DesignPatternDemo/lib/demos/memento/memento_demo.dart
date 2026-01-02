///
/// memento_demo.dart
/// MementoDemoPage
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final _textController = TextEditingController(text:'');
  final _checkpointController = TextEditingController(text: 'Manual checkpoint');

  // dispose
  @override
  void dispose() {
    _textController.dispose();
    _checkpointController.dispose();
    super.dispose();
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
            title: const Text('Memento Pattern Demo'),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// --- Info banner ---
                    _InfoBanner(
                      title: '此 Demo 的目的',
                      lines: const [
                        '展示 Memento（備忘錄）如何將物件狀態封裝成不可變快照（Memento），由 Caretaker 維護，以支援 Undo/Redo 與歷史回溯。',
                        'Originator：TextDocument（content + caret）。Caretaker：HistoryManager（維護快照堆疊）。',
                        '每次操作都能建立 checkpoint；Undo/Redo 以快照為準恢復狀態，避免暴露內部細節（封裝原則）。',
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// --- Control region ---
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            /// content + Caret
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: isWide ? 520 : constraints.maxWidth,
                                  ),
                                  child: TextField(
                                    controller: _textController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      labelText: 'Staged text',
                                      hintText: '輸入欲套用的內容',
                                    ),
                                    onChanged: vm.setStagedText,
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 260),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Caret: ${vm.stagedCaret}'),
                                      Slider(
                                        value: vm.stagedCaret.toDouble(),
                                        min: 0,
                                        max: vm.document.content.length.toDouble().clamp(0, 1),
                                        divisions: vm.document.content.isEmpty
                                            ? 1
                                            : vm.document.content.length,
                                        label: '${vm.stagedCaret}',
                                        onChanged: (v) => vm.setStagedCaret(v.round()),
                                      ),
                                      FilledButton.tonal(
                                        onPressed: vm.applySetContent,
                                        child: const Text('Apply content'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// 快速操作
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                FilledButton(
                                  onPressed: () => vm.appendSample('Hello, '),
                                  child: const Text('Append "Hello, "'),
                                ),
                                FilledButton(
                                  onPressed: () => vm.appendSample('World!'),
                                  child: const Text('Append "World!"'),
                                ),
                                FilledButton(
                                  onPressed: () => vm.deleteLast(5),
                                  child: const Text('Delete last 5'),
                                ),
                                FilledButton(
                                  onPressed: () => vm.moveCaret(vm.document.caret + 3),
                                  child: const Text('Move caret +3'),
                                ),
                                FilledButton(
                                  onPressed: () => vm.moveCaret(vm.document.caret - 3),
                                  child: const Text('Move caret -3'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: vm.undo,
                                  icon: const Icon(Icons.undo),
                                  label: const Text('Undo'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: vm.redo,
                                  icon: const Icon(Icons.redo),
                                  label: const Text('Redo'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// Checkpoint
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 320),
                                  child: TextField(
                                    controller: _checkpointController,
                                    decoration: const InputDecoration(
                                      labelText: 'Checkpoint label',
                                    ),
                                  ),
                                ),
                                FilledButton.tonal(
                                  onPressed: () => vm.saveCheckpoint(
                                    _checkpointController.text.trim().isEmpty
                                        ? 'Manual checkpoint'
                                        : _checkpointController.text.trim(),
                                  ),
                                  child: const Text('Save checkpoint'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: vm.clearAll,
                                  icon: const Icon(Icons.clear_all),
                                  label: const Text('Clear'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// --- 文件狀態 ---
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.description, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Content length: ${vm.document.content.length} | Caret: ${vm.document.caret}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              vm.document.content.isEmpty ? '(empty)' : vm.document.content,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// --- 歷史清單 ---
                    const Text(
                      'History (checkpoints):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 240,
                      child: Card(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: vm.historyManager.history.length,
                          separatorBuilder: (_, __) =>
                          const Divider(height: 12),
                          itemBuilder: (_, i) {
                            final m = vm.historyManager.history[i];
                            return ListTile(
                              leading: CircleAvatar(child: Text('${i + 1}')),
                              title: Text(m.label),
                              subtitle: Text(
                                'len=${m.content.length}, caret=${m.caret} • ${m.at.toLocal()}',
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    /// --- Logs ---
                    if (vm.logs.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Logs:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 140,
                        child: Card(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: vm.logs.length,
                            separatorBuilder: (_, __) =>
                            const Divider(height: 8),
                            itemBuilder: (_, i) => Text(vm.logs[i]),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
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
