

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/interpreter_view_model.dart';

class InterpreterDemoPage extends StatelessWidget {

  const InterpreterDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InterpreterViewModel(),
      child: const _InterpreterDemoBody(),
    );
  }

}

class _InterpreterDemoBody extends StatefulWidget {
  const _InterpreterDemoBody();

  @override
  State<StatefulWidget> createState() => _InterpreterDemoBodyState();

}

class _InterpreterDemoBodyState extends State<_InterpreterDemoBody> {
  // text editor controller
  final _srcController = TextEditingController();

  // init state
  @override
  void initState() {
    super.initState();
    final vm = context.read<InterpreterViewModel>();
    _srcController.text = vm.program;
  }

  // dispose controller
  @override
  void dispose() {
    _srcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InterpreterViewModel>(
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
        // sync input
        if (_srcController.text != vm.program) {
          _srcController.text = vm.program;
        }

        final isError = vm.lastValue == null
            && vm.ast.isEmpty
            && vm.tokens.isEmpty
            && vm.env.isEmpty
            && vm.logs.isNotEmpty;


        return Scaffold(
          appBar: AppBar(title: const Text('Interpreter Pattern Demo')),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// --- 說明卡 ---
                    _InfoBanner(
                      title: '此 Demo 的目的',
                      lines: const [
                        '展示 Interpreter（直譯器）如何以 Tokenizer + Parser + AST + eval 建構並執行一個小型 DSL。',
                        'DSL 支援變數指派與基本運算/函式（max/min/abs），以分號分隔多個語句。',
                        '右側 Cards 顯示執行結果、Environment、Tokens、AST 與 Logs。',
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// --- 控制區 ---
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _srcController,
                              maxLines: 6,
                              decoration: const InputDecoration(
                                labelText: 'DSL 程式',
                                hintText: '輸入指派與表達式；可用分號分隔多個語句。',
                              ),
                              onChanged: vm.setProgram,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilledButton(onPressed: vm.run, child: const Text('Run')),
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

                    /// --- Result / Env ---
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.play_circle, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Result: ${vm.lastValue?.toStringAsFixed(4) ?? '(無)'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isError
                                          ? Theme.of(context).colorScheme.error
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('Environment:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: vm.env.entries
                                  .map((e) => Chip(
                                label: Text(
                                    '${e.key} = ${e.value.toStringAsFixed(4)}'),
                              ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(height: 32),

                    /// --- Tokens / AST / Logs ---
                    isWide
                        ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _TokensCard(vm)),
                        const SizedBox(width: 12),
                        Expanded(child: _AstCard(vm)),
                        const SizedBox(width: 12),
                        Expanded(child: _LogsCard(vm)),
                      ],
                    )
                        : Column(
                      children: [
                        _TokensCard(vm),
                        const SizedBox(height: 12),
                        _AstCard(vm),
                        const SizedBox(height: 12),
                        _LogsCard(vm),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    );
  }

  Widget _TokensCard(InterpreterViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tokens:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.tokens.length,
              itemBuilder: (_, i) => Text(vm.tokens[i].toString()),
            ),
          ],
        ),
      ),
    );
  }


  Widget _AstCard(InterpreterViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AST:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              vm.ast.isEmpty ? '(empty)' : vm.ast,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }


  Widget _LogsCard(InterpreterViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.logs.length,
              separatorBuilder: (_, __) => const Divider(height: 8),
              itemBuilder: (_, i) => Text(vm.logs[i]),
            ),
          ],
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