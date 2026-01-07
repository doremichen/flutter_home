///
/// interpreter_demo.dart
/// InterpreterDemoPage
///
/// Created by Adam Chen on 2025/12/22
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'interpreter_control_page.dart';
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

class _InterpreterDemoBody extends StatelessWidget {
  const _InterpreterDemoBody();

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

        final isError = vm.lastValue == null
            && vm.ast.isEmpty
            && vm.tokens.isEmpty
            && vm.env.isEmpty
            && vm.logs.isNotEmpty;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              title: const Text('Interpreter Pattern Demo'),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune), // 跳轉設定
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: vm,
                        child: const InterpreterControlPage(),
                      ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: vm.clearAll,
                tooltip: '清空',
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // 1. 目的介紹 (Banner)
                Expanded(flex: 1, child: _buildInfoBanner()),
                const Divider(height: 1),

                // 2. 執行結果 (Result)
                Expanded(flex: 1, child: _buildResultCard(context, vm, isError)),
                const Divider(height: 1),

                // 3. 詳盡數據 (Tokens / AST / Logs)
                Expanded(
                  flex: 3, // 給予較大的比例顯示詳細資訊
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildTokensCard(vm)),
                        const VerticalDivider(width: 1),
                        Expanded(child: _buildAstCard(vm)),
                        const VerticalDivider(width: 1),
                        Expanded(child: _buildLogsCard(vm)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        );
      }


    );
  }

  Widget _buildTokensCard(InterpreterViewModel vm) {
    return Card(
      margin: const EdgeInsets.all(8), // 稍微增加邊距，避免視覺上太擁擠
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Tokens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: vm.tokens.length,
                itemBuilder: (context, index) {
                  final token = vm.tokens[index];
                  return Text('[${token.type}] ${token.lexeme}', style: const TextStyle(fontSize: 11));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAstCard(InterpreterViewModel vm) {
    return Card(
      margin: const EdgeInsets.all(8), // 稍微增加邊距，避免視覺上太擁擠
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('AST 結構', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Text(
                  vm.ast.isEmpty ? '等待解析...' : vm.ast,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLogsCard(InterpreterViewModel vm) {
    return Card(
      margin: const EdgeInsets.all(8), // 稍微增加邊距，避免視覺上太擁擠
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('執行日誌', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: vm.logs.length,
                itemBuilder: (context, index) {
                  return Text('> ${vm.logs[vm.logs.length - 1 - index]}',
                      style: const TextStyle(color: Colors.blueGrey, fontSize: 10));
                },
              ),
            ),
          ),
        ],
      ),
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
            '展示 Interpreter（直譯器）如何以 Tokenizer + Parser + AST + eval 建構並執行一個小型 DSL。',
            'DSL 支援變數指派與基本運算/函式（max/min/abs），以分號分隔多個語句。',
            '如下顯示執行結果、Environment、Tokens、AST 與 Logs。',
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, InterpreterViewModel vm, bool isError) {
    return Card(
      margin: const EdgeInsets.all(8), // 稍微增加邊距，避免視覺上太擁擠
      child: Scrollbar(
        thumbVisibility: true, // 讓捲軸常駐，提醒使用者可以滾動
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Result 顯示區
              Row(
                children: [
                  Icon(
                    Icons.play_circle,
                    size: 28,
                    color: isError ? Theme.of(context).colorScheme.error : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Result: ${vm.lastValue?.toStringAsFixed(4) ?? '(無)'}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isError ? Theme.of(context).colorScheme.error : null,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: 24), // 加入分隔線讓層次更清晰

              // 2. Environment 標題
              const Text('Environment (變數狀態):',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // 3. 變數列表 (Wrap 會自動換行，外層 Scrollview 會處理垂直高度)
              if (vm.env.isEmpty)
                const Text('目前無定義變數', style: TextStyle(color: Colors.grey, fontSize: 13))
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: vm.env.entries.map((e) {
                    return Chip(
                      visualDensity: VisualDensity.compact, // 縮小 Chip 體積
                      label: Text(
                        '${e.key} = ${e.value.toStringAsFixed(4)}',
                        style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    );
                  }).toList(),
                ),
            ],
          ),
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