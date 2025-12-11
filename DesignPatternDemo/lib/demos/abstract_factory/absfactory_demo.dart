///
/// abstractory_factory_demo.dart
/// AbstractFactoryDemoPage
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:design_pattern_demo/demos/abstract_factory/view_model/absfactory_vm.dart';
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import 'creator/abstract_factory.dart';

class AbstractFactoryDemoPage extends StatelessWidget {

  const AbstractFactoryDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AbstractFactoryViewModel(
        factories: [
          SportPartsFactory(),
          FamilyPartsFactory(),
          TruckPartsFactory(),
        ]
      ),
      child: const _AbstractFactoryDemoBody(),
    );
  }

}

class _AbstractFactoryDemoBody extends StatelessWidget {
  const _AbstractFactoryDemoBody ();

  @override
  Widget build(BuildContext context) {
    return Consumer<AbstractFactoryViewModel>(
        builder: (context, vm, _) {
          // Snackbar Toast
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
              title: const Text('Abstract Factory Demo'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Clear all',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Clear all'),
                        content: const Text('Remove all created part sets?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
                        ],
                      ),
                    );
                    if (confirm == true) vm.clearAll();
                  },
                )
              ],
            ),
            body: Column(
              children: [
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8,
                    children: List.generate(vm.factories.length, (i) {
                      final isSelected = vm.selectedIndex == i;
                      return ChoiceChip(
                        label: Text(vm.factories[i].label),
                        selected: isSelected,
                        onSelected: (_) => vm.selectFactory(i),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 12),

                // Create set button
                ElevatedButton.icon(
                  onPressed: vm.createMatchedSet,
                  icon: const Icon(Icons.build),
                  label: const Text('Create Matched Parts Set'),
                ),

                const Divider(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Created sets:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.createdSets.length,
                    itemBuilder: (_, i) => Text(vm.createdSets[i]),
                    separatorBuilder: (_, __) => const Divider(height: 12),
                  ),
                ),

              ],
            ),

          );


        }
    );
  }
}