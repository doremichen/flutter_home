///
/// cor_settings_page.dart
/// CorSettingsPage
///
/// Created by Adam Chen on 2026/01/06
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/data.dart';
import 'view_model/cor_view_model.dart';

class CoRSettingsPage extends StatefulWidget {

  CoRSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _CoRSettingsPageState();

}

class _CoRSettingsPageState extends State<CoRSettingsPage> {

  late final TextEditingController _msgController;

  @override
  void initState() {
    super.initState();
    _msgController = TextEditingController(text: '退款流程諮詢');
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CoRViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('責任鍊展示模式設定')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('請求參數設定', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildCategorySelector(vm),
                      const SizedBox(height: 12),
                      _buildSeveritySelector(vm),
                      const SizedBox(height: 12),
                      _buildNodeSwitch(vm),
                      const SizedBox(height: 24),
                      _buildActionFooter(context, vm),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(CoRViewModel vm) {
    return Column(
      children: [
        // Title
        const Text('類別：', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SegmentedButton<Category>(
          segments: const [
            ButtonSegment(value: Category.billing, label: Text('帳單')),
            ButtonSegment(value: Category.tech, label: Text('科技')),
            ButtonSegment(value: Category.sales, label: Text('銷售量')),
          ],
          selected: {vm.category},
          onSelectionChanged: (s) => vm.setCategory(s.first),
        ),
      ],
    );
  }

  Widget _buildSeveritySelector(CoRViewModel vm) {
    return Column(
      children: [
        // Title
        const Text('嚴重度：', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SegmentedButton<Severity>(
          segments: const [
            ButtonSegment(value: Severity.low, label: Text('低')),
            ButtonSegment(value: Severity.medium, label: Text('中')),
            ButtonSegment(value: Severity.high, label: Text('高')),
          ],
          selected: {vm.severity},
          onSelectionChanged: (s) => vm.setSeverity(s.first),
        ),
      ],
    );
  }

  Widget _buildNodeSwitch(CoRViewModel vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // description and switch
        Row(
          children: [
            // --- 左邊：TextField (比例佔 2) ---
            Expanded(
              flex: 2,
              child: TextField(
                controller: _msgController,
                decoration: const InputDecoration(
                  labelText: '描述',
                  hintText: '請輸入...',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: vm.setMessage,
              ),
            ),

            const SizedBox(width: 12), // 兩者間的間距

            // --- 右邊：已認證開關 (比例佔 1) ---
            Expanded(
              flex: 3,
              child: Container(
                // 加個邊框或 Padding 可以讓感應區更明確（選配）
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // 讓開關靠右對齊
                  children: [
                    const Flexible(
                      child: Text('已認證', overflow: TextOverflow.ellipsis),
                    ),
                    Switch(
                      value: vm.hasAuth,
                      onChanged: vm.setHasAuth,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        const Text('節點開關', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(label: const Text('垃圾郵件'), selected: vm.enableSpam, onSelected: vm.setEnableSpam),
            FilterChip(label: const Text('驗證'), selected: vm.enableValidation, onSelected: vm.setEnableValidation),
            FilterChip(label: const Text('Tier1'), selected: vm.enableTier1, onSelected: vm.setEnableTier1),
            FilterChip(label: const Text('Tier2'), selected: vm.enableTier2, onSelected: vm.setEnableTier2),
            FilterChip(label: const Text('主管'), selected: vm.enableManager, onSelected: vm.setEnableManager),
          ],
        ),
      ],
    );

  }

  Widget _buildActionFooter(BuildContext context, CoRViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: () { vm.runOnce(); Navigator.pop(context); },
                  icon: const Icon(Icons.send),
                  label: const Text('執行請求'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // 加上間距
          // execute batch
          SizedBox(
            width: double.infinity, // 讓按鈕橫向撐滿
            child: FilledButton.icon(
              onPressed: () { vm.runBatch(5); Navigator.pop(context); },
              icon: const Icon(Icons.send),
              label: const Text('執行批次請求'),
            ),
          ),
        ],
      ),
    );
  }
}
