///
/// factory_demo.dart
/// FactoryDemoPage
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creator/factory.dart';
import 'view_model/factory_view_model.dart';

class FactoryDemoPage extends StatelessWidget {

  const FactoryDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FactoryViewModel(),
      child: const _FactoryDemoBody(),
    );
  }

}

class _FactoryDemoBody extends StatelessWidget {

  const _FactoryDemoBody();

  @override
  Widget build(BuildContext context) {
    final factories = <VehicleFactory>[
      SportCarFactory(),
      FamilyCarFactory(),
      TruckFactory(),
    ];

    return Consumer<FactoryViewModel>(
      builder: (context, vm, _) {
        // show toast
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
                title: const Text('Factory Method Demo'),
                actions: [
                  IconButton(
                    tooltip: 'Clear all',
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Clear all'),
                          content: const Text('Remove all created vehicles?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
                          ],
                        ),
                      );
                      if (confirm == true) vm.clearAll();
                    }
                  ),
                ],
              ),
          body: Column(
            children: [
              const SizedBox(height: 12),
              // button
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: factories
                          .map(
                              (f) => ElevatedButton.icon(
                                onPressed: () => vm.createVehicle(f),
                                icon: const Icon(Icons.factory),
                                label: Text(f.label),
                            ),
                          ).toList(),
              ),

              const Divider(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Created vehicles:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),

              // Result
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.created.length,
                  separatorBuilder: (_, __) => const Divider(height: 12),
                  itemBuilder: (_, index) {
                    final v = vm.created[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(v.name),
                      subtitle: Text(v.describe()),
                    );
                  },
                ),
              ),

            ],
          ),
        );
      },
    );
  }

}