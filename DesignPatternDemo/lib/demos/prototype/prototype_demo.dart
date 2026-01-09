///
/// prototype_demo.dart
/// PrototypeDemoPage
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'prototype_gallery_page.dart';
import 'view_model/prototype_view_model.dart';
import 'util/color_parser.dart';

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
  late final _nameController;
  late final _featureController;
  late final _colorController;


  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PrototypeViewModel>(context, listen: false);

    _nameController = TextEditingController(text: vm.nameSuffix);
    _colorController = TextEditingController(text: vm.color);
    _featureController = TextEditingController();

    vm.addListener(_onViewModelChanged);
  }


  @override
  void dispose() {
    final vm = Provider.of<PrototypeViewModel>(context, listen: false);
    vm.removeListener(_onViewModelChanged);
    //
    _nameController.dispose();
    _featureController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    final vm = Provider.of<PrototypeViewModel>(context, listen: false);

    if (_nameController.text != vm.nameSuffix) {
      _nameController.text = vm.nameSuffix;
    }
    if (_colorController.text != vm.color) {
      _colorController.text = vm.color;
    }
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

        // theme
        Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('原型模式 (Prototype)'),
            actions: [
              IconButton(
                icon: Badge(
                  label: Text('${vm.created.length}'),
                  child: const Icon(Icons.directions_car_filled),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PrototypeGalleryPage(vm: vm))),
              ),
            ],
          ),
          body: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- info banner ---
                      _buildInfoBanner(),

                      const SizedBox(height: 16),

                      // --- current information ---
                      _buildCompactPreview(vm),

                      const Divider(height: 32, thickness: 1, color: Colors.black12),

                      Expanded(
                        child: _buildControlPanel(vm),
                      ),
                      const SizedBox(height: 24),
                      // 按鈕改為並排或大按鈕
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: vm.cloneWithCustomization,
                              icon: const Icon(Icons.copy_all),
                              label: const Text('執行克隆 (Clone)'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: vm.resetCustomization,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: Colors.deepPurple),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('重置'),
                            ),
                          ),
                        ],
                      ),
                    ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildInfoBanner() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 140),
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 8),
            child: _InfoBanner(
              title: '原型模式 (Prototype)',
              lines: const [
                '展示原型模式如何透過既有樣本快速建立新物件，並以「深拷貝」確保新物件與原型相互獨立。',
                '可選不同車款原型（跑車/家庭/卡車）；可在右側欄位調整顏色、座位與功能，按下「複製」即產生新車輛。',
                '清單會列出所有已建立的克隆，便於比較與驗證拷貝的獨立性（含 特徵 深拷貝）。',
              ],
            ),
        ),
      ),
    );
  }

  Widget _buildControlPanel(dynamic vm) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('1. 選擇原型', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(vm.keys.length, (i) {
              return ChoiceChip(
                label: Text(vm.keys[i]),
                selected: vm.selectedIndex == i,
                onSelected: (_) => vm.selectPrototype(i),
              );
            }),
          ),

          const SizedBox(height: 24),
          const Text('2. 調整屬性', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 12),

          _buildAttributeCard(vm),
        ],
      ),
    );
  }

  Widget _buildAttributeCard(dynamic vm) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '名稱後綴 (Suffix)', isDense: true),
            onChanged: vm.setNameSuffix,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _colorController,
            decoration: const InputDecoration(labelText: '顏色 (Color)', isDense: true),
            onChanged: vm.setColor,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _featureController,
                  decoration: const InputDecoration(labelText: '新增特徵 (Feature)', isDense: true),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                onPressed: () {
                  if (_featureController.text.isNotEmpty) {
                    vm.addFeature(_featureController.text);
                    _featureController.clear(); // 僅在手動添加後清空
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('座位:', style: TextStyle(fontSize: 12)),
              Text('${vm.seats}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: vm.seats.toDouble(),
            min: 1, max: 7, divisions: 6,
            onChanged: (v) => vm.setSeats(v.round()),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactPreview(PrototypeViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.shade100, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          // icon and name
          Icon(Icons.directions_car, size: 48, color: vm.color.toColor()),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.selectedPrototypeName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '後綴: ${vm.nameSuffix.isEmpty ? "無" : vm.nameSuffix}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 20),
          // 右側：參數簡覽
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPreviewRowInline('顏色', vm.color),
              _buildPreviewRowInline('座位', '${vm.seats}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewRowInline(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
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