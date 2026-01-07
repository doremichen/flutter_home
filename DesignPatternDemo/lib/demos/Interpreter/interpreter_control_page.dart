///
/// interpreter_control_page.dart
/// InterpreterControlPage
///
/// Created by Adam Chen on 2026/01/06
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/interpreter_view_model.dart';

class InterpreterControlPage extends StatefulWidget {
  const InterpreterControlPage({super.key});

  @override
  State<StatefulWidget> createState() => _InterpreterControlPageState();
}

class _InterpreterControlPageState extends State<InterpreterControlPage> {
  late final TextEditingController _srcController;


  @override
  void initState() {
    super.initState();
    final vm = context.read<InterpreterViewModel>();
    _srcController = TextEditingController(text: vm.program);
    // add listener
    _srcController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _srcController.removeListener(_onTextChanged);
    _srcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InterpreterViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('直譯模式控制台')),
      body: SafeArea(
        child: SingleChildScrollView( //
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. 輸入區域
              _buildInputField(),

              const SizedBox(height: 16),

              // 2. 按鈕區域
              _buildActionFooter(context, vm),
            ],
          ),
        ),
      ),

    );
  }

  void _onTextChanged() {
    if (_srcController.text.isNotEmpty) {
      context.read<InterpreterViewModel>().setProgram(_srcController.text);
    }
  }

  Widget _buildInputField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _srcController,
              maxLines: null,
              minLines: 3,
              decoration: const InputDecoration(
                labelText: 'DSL 程式',
                hintText: '輸入指派與表達式；可用分號分隔多個語句。',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionFooter(BuildContext context, InterpreterViewModel vm) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton(
            onPressed: () {
              vm.run();
              // pop
              Navigator.of(context).pop();
            },
            child: const Text('Run')
        ),
        OutlinedButton.icon(
          onPressed: () {
            // pop
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.cancel),
          label: const Text('取消'),
        ),
      ],
    );
  }
}