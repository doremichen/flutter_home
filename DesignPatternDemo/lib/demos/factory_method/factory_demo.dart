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
        // show toast/snack bar after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.takeLastToast();
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
          }
        });

        Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('工廠方法模式展示'),
            actions: [
              IconButton(
                tooltip: '全部清除',
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('全部清除'),
                      content: const Text('移除所有已建立的車輛?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('取消'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('確認'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) vm.clearAll();
                },
              ),
            ],
          ),
          extendBody: false,
          body: SafeArea(
            child: Padding(
              // 側邊與頂部留白
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// --- 上半部：Demo 目的說明 (保持置頂) ---
                  _buildHeaderSection(),

                  const Divider(height: 24, thickness: 1),

                  /// --- 下半部：左按鈕 / 右清單 (並排區) ---
                  Expanded(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 【左側：按鈕區】
                          // 使用 SizedBox 或指定寬度，避免與右側清單擠壓
                          _buildFactoryButtonList(factories, vm),

                          const VerticalDivider(width: 24, thickness: 1),

                          // 【右側：結果清單】
                          // 使用 Expanded 佔滿剩餘的所有右側空間
                          Expanded(
                            child: _buildResultList(vm),
                          ),
                        ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection() {
    return _InfoBanner(
      title: '此 Demo 的目的',
      lines: const [
        '示範 Factory Method 如何將建立邏輯封裝在工廠中。',
        '呼叫端透過抽象介面取得具體產品。',
        '下方按鈕可建立不同車款，便於觀察擴充性。',
      ],
    );
  }


  Widget _buildFactoryButtonList(List factories, dynamic vm) {
    return SizedBox(
        width: 140, // 根據按鈕文字長度調整寬度
        child: SingleChildScrollView(
          child: Column(
            children: factories.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSingleFactoryButton(f, vm), // 這裡建議按鈕寬度設為 double.infinity
            )).toList(),
          ),
        )
    );
  }

  Widget _buildResultList(dynamic vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('已建立車輛:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: vm.created.isEmpty
                  ? const Center(child: Text('無資料', style: TextStyle(fontSize: 12)))
                  : ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: vm.created.length,
                separatorBuilder: (_, __) => const Divider(height: 8),
                itemBuilder: (_, index) {
                  final v = vm.created[index];
                  // 右側空間有限，ListTile 需簡化
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: Text(v.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text(v.describe(), style: const TextStyle(fontSize: 11)),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildSingleFactoryButton(VehicleFactory factory, dynamic vm) {
    return SizedBox(
      width: double.infinity, // 填滿左側 140 寬度
      child: ElevatedButton.icon(
        onPressed: () => vm.createVehicle(factory),
        icon: const Icon(Icons.add, size: 16),
        label: Text(
          factory.label,
          style: const TextStyle(fontSize: 11),
          textAlign: TextAlign.start,
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
    );
  }
}

/// --- 小元件：頂部資訊 Banner（卡片樣式、與 Builder Demo 同格式） ---
class _InfoBanner extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _InfoBanner({
    required this.title,
    required this.lines,
  });

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
