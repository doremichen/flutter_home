///
/// command_control_page.dart
/// CommandControlPage
///
/// Created by Adam Chen on 2026/01/06
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';

import 'view_model/command_view_model.dart';

class CommandControlPage extends StatefulWidget {
  final CommandViewModel vm;
  const CommandControlPage({super.key, required this.vm});

  @override
  State<StatefulWidget> createState() => _CommandControlPageState(vm : vm);
}

class _CommandControlPageState extends State<CommandControlPage> {
  // input controller
  late final TextEditingController _amountController ;
  late final TextEditingController _setController;


  final CommandViewModel vm;
  _CommandControlPageState({required this.vm});

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '10');
    _setController = TextEditingController(text: '0');

    // add listener
    _amountController.addListener(() {
      if (_amountController.text.isNotEmpty) {
        final v = double.tryParse(_amountController.text);
        if (v != null) {
          vm.setAmount(v);
        }
      }
    });

  }

  @override
  void dispose() {
    _amountController.dispose();
    _setController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('命令模式控制')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Input amount and init value
                  _buildInputField(vm),
                  const SizedBox(height: 12),

                  // Basic commands
                  _buildBasicCommands(context, vm),
                  const SizedBox(height: 12),

                  // Macro commands
                  _buildMacroCommands(context, vm),
                  const SizedBox(height: 12),

                  // action button
                  _buildActionFooter(context),

                ],
              ),
            ),
          ),

        );

      }
    );

  }

  Widget _buildInputField(CommandViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Wrap input
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // amount
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: '數量',
                      hintText: '例如：10 / 2',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                // value
                SizedBox(
                  width: 160,
                  child: TextField(
                    controller: _setController,
                    decoration: const InputDecoration(
                      labelText: '設定值',
                      hintText: '例如：0 / 100',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                // execute set value button
                FilledButton.tonal(
                  onPressed: () {
                    final v = double.tryParse(_setController.text);
                    if (v != null) {
                      vm.setValue(v);
                    }
                  },
                  child: const Text('設定值'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicCommands(BuildContext context, CommandViewModel vm) {
    return Column(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton(
                onPressed: () {
                  final v = double.tryParse(_amountController.text);
                  if (v != null) {
                    vm.add();
                  }
                  // pop
                  Navigator.pop(context);
                },
                child: const Text('加')
            ),
            FilledButton(
                onPressed: () {
                  final v = double.tryParse(_amountController.text);
                  if (v != null) {
                    vm.sub();
                  }
                  // pop
                  Navigator.pop(context);
                },
                child: const Text('減')
            ),
            FilledButton(
                onPressed: () {
                  final v = double.tryParse(_amountController.text);
                  if (v != null) {
                    vm.mul();
                  }
                  // pop
                  Navigator.pop(context);
                },
                child: const Text('乘')
            ),
            FilledButton(
                onPressed: () {
                  final v = double.tryParse(_amountController.text);
                  if (v != null) {
                    vm.div();
                  }
                  // pop
                  Navigator.pop(context);
                },
                child: const Text('除')
            ),
            OutlinedButton.icon(
              onPressed: () {
                vm.undo();
                // pop
                Navigator.pop(context);
              },
              icon: const Icon(Icons.undo),
              label: const Text('撤銷'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                vm.redo();
                // pop
                Navigator.pop(context);
              },
              icon: const Icon(Icons.redo),
              label: const Text('重做'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroCommands(BuildContext context, CommandViewModel vm) {
    return Column(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('宏命令：'),
            FilledButton.tonal(
              onPressed: () {
                vm.macroBoost();
                // pop
                Navigator.pop(context);
              },
              child: const Text('促進（+amount → ×2）'),
            ),
            FilledButton.tonal(
              onPressed: () {
                vm.macroDiscount();
                // pop
                Navigator.pop(context);
              },
              child: const Text('折扣（-amount → ÷2）'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionFooter(BuildContext context) {
    return OutlinedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('取消')
    );
  }


}