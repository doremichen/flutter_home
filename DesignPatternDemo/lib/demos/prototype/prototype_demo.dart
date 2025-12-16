///
/// prototype_demo.dart
/// PrototypeDemoPage
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/PrototypeViewModel.dart';

class PrototypeDemoPage extends StatelessWidget {

  const PrototypeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrototypeViewModel(),
      child: const _PrototypeDemoBody(),
    );
  }

}

class _PrototypeDemoBody extends StatefulWidget {
  const _PrototypeDemoBody();

  @override
  State<StatefulWidget> createState() => _PrototypeDemoBodyState();
}

class _PrototypeDemoBodyState extends State<_PrototypeDemoBody> {
  final _nameController = TextEditingController();
  final _featureController = TextEditingController();
  final _colorController = TextEditingController();


  @override
  void dispose() {
    //
    _nameController.dispose();
    _featureController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrototypeViewModel>(
      builder: (context, vm, _) {
        // show toast message
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.takeLastToast();
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
          }
        });

        // synchronize input controller
        _nameController.value = _nameController.value.copyWith(text: vm.nameSuffix);
        _colorController.value = _colorController.value.copyWith(text: vm.color);
        // theme
        Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Prototype Demo'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Clear all',
                onPressed: vm.clearAll,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= 上半部：設定 / 說明 =================
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- InfoBanner ------------------
                        _InfoBanner(
                          title: '此 Demo 的目的',
                          lines: const [
                            '展示 Prototype（原型）如何透過既有樣本快速建立新物件，並以「深拷貝」確保新物件與原型相互獨立。',
                            '上方可選不同車款原型（跑車/家庭/卡車）；可在右側欄位調整顏色、座位與功能，按下「Clone」即產生新車輛。',
                            '清單會列出所有已建立的克隆，便於比較與驗證拷貝的獨立性（含 features 深拷貝）。',
                          ],
                        ),

                        const SizedBox(height: 16),

                        // --- prototype choice -------
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(vm.keys.length, (i) {
                            final isSelected = vm.selectedIndex == i;
                            return ChoiceChip(
                              label: Text(vm.keys[i]),
                              selected: isSelected,
                              onSelected: (_) => vm.selectPrototype(i),
                            );
                          }),
                        ),

                        const SizedBox(height: 12),

                        // ---- customize field ------
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // left
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Name suffix（可留空）',
                                        ),
                                        onChanged: vm.setNameSuffix,
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _colorController,
                                        decoration: const InputDecoration(
                                          labelText: 'Color',
                                        ),
                                        onChanged: vm.setColor,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Text('Seats: '),
                                          Expanded(
                                            child: Slider(
                                              value: vm.seats.toDouble(),
                                              min: 1,
                                              max: 7,
                                              divisions: 6,
                                              label: '${vm.seats}',
                                              onChanged: (v) =>
                                                  vm.setSeats(v.round()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // right
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Features',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: List.generate(
                                          vm.customizationFeatures.length,
                                              (i) => Chip(
                                            label: Text(
                                                vm.customizationFeatures[i]),
                                            onDeleted: () =>
                                                vm.removeFeatureAt(i),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _featureController,
                                              decoration:
                                              const InputDecoration(
                                                labelText: 'Add new feature',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          FilledButton.tonal(
                                            onPressed: () {
                                              vm.addFeature(
                                                  _featureController.text);
                                              _featureController.clear();
                                            },
                                            child: const Text('Add'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // --- Operation buttons -------
                        Row(
                          children: [
                            FilledButton(
                              onPressed: vm.cloneWithCustomization,
                              child: const Text('Clone'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.tonal(
                              onPressed: vm.resetCustomization,
                              child: const Text('Reset customization'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 32),

                // ================= 下半部：結果清單 =================
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Created clones',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(height: 1),

                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: vm.created.length,
                            separatorBuilder: (_, __) =>
                            const Divider(height: 12),
                            itemBuilder: (_, index) {
                              final v = vm.created[index];
                              return ListTile(
                                leading:
                                CircleAvatar(child: Text('${index + 1}')),
                                title: Text('${v.model} (${v.type})'),
                                subtitle: Text(
                                  'Color: ${v.specs.color}, Seats: ${v.specs.seats}\n'
                                      'Features: ${v.specs.features.join(", ")}',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ================= Logs =================
                if (vm.logs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
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
          ),

        );
      }
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