///
/// builder_demo.dart
/// BuilderDemoPage
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import 'creator/director.dart';
import 'creator/meal_builder.dart';
import 'model/product.dart';

class BuilderDemoPage extends StatefulWidget {
  const BuilderDemoPage({super.key});

  @override
  State<BuilderDemoPage> createState() => _BuilderDemoPageState();
}

enum BuilderKind { healthy, fastfood, vegan }

class _BuilderDemoPageState extends State<BuilderDemoPage> {
  final director = MealDirector();
  BuilderKind _selected = BuilderKind.healthy;

  late MealBuilder _builder;
  Meal? _result;

  @override
  void initState() {
    super.initState();
    _builder = _createBuilder(_selected);
  }

  MealBuilder _createBuilder(BuilderKind kind) {
    switch (kind) {
      case BuilderKind.healthy:
        return HealthyMealBuilder();
      case BuilderKind.fastfood:
        return FastFoodMealBuilder();
      case BuilderKind.vegan:
        return VeganMealBuilder();
    }
  }

  void _onBuilderChanged(BuilderKind? kind) {
    if (kind == null) return;
    setState(() {
      _selected = kind;
      _builder = _createBuilder(kind);
      _result = null;
    });
  }

  void _constructLight() {
    setState(() {
      director.constructLightCombo(_builder);
      _result = _builder.getResult();
    });
  }

  void _constructFull() {
    setState(() {
      director.constructFullCourse(_builder);
      _result = _builder.getResult();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Builder 模式 Demo')),
      body: SafeArea(
        child: Material(
          color: Colors.transparent, // 確保繼承 Scaffold 的淺灰色背景
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// --- 1. 頂部：說明區 (可捲動) ---
                _buildInfoBanner(),

                const Divider(height: 32, thickness: 1, color: Colors.black12),

                /// --- 2. 下半部：控制面板 與 結果清單 (左右並排) ---
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 【左側：控制台】
                      _buildBuilderController(context),

                      const VerticalDivider(width: 32, thickness: 1, color: Colors.black12),

                      // 【右側：日誌與成品】
                      Expanded(
                        child: _buildBuilderResults(theme),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 140),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 8),
          child: _InfoBanner(
            title: '此 Demo 的目的',
            lines: const [
              '以「餐點建造」為例，演示 Builder 模式如何將「建造流程」與「具體建造細節」分離。',
              '左側切換不同 Builder 並執行建造配方，右側觀察相同的流程如何產生截然不同的成品。',
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuilderController(BuildContext context) {
    return SizedBox(
      width: 160, // 稍微加寬以容納選單文字
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('餐點類型', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 8),

            // 下拉選單封裝在裝飾容器中
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<BuilderKind>(
                  isExpanded: true,
                  value: _selected,
                  onChanged: _onBuilderChanged,
                  items: const [
                    DropdownMenuItem(value: BuilderKind.healthy, child: Text('健康餐', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: BuilderKind.fastfood, child: Text('速食餐', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: BuilderKind.vegan, child: Text('素食餐', style: TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text('建造配方', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 12),

            // 建造按鈕 A: 輕套餐
            _buildSideButton(
              onPressed: _constructLight,
              label: '建造輕套餐',
              icon: Icons.lunch_dining_outlined,
              isPrimary: false,
            ),

            const SizedBox(height: 12),

            // 建造按鈕 B: 全餐
            _buildSideButton(
              onPressed: _constructFull,
              label: '建造全餐',
              icon: Icons.restaurant,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 11)),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: isPrimary ? Colors.deepPurple.shade600 : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.deepPurple.shade700,
          elevation: isPrimary ? 2 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary ? BorderSide.none : BorderSide(color: Colors.deepPurple.shade100),
          ),
        ),
      ),
    );
  }

  Widget _buildBuilderResults(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('建造日誌 (Logs)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 12),

        // Log 區域
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _builder.logs.length,
              separatorBuilder: (_, __) => const Divider(height: 8, thickness: 0.5),
              itemBuilder: (_, i) => Text(
                _builder.logs[i],
                style: const TextStyle(fontSize: 12, color: Colors.black54, fontFamily: 'monospace'),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 成品展示區
        if (_result != null) ...[
          const Text('最終成品', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurple.shade100),
            ),
            child: Column(
              children: _result!.toMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text('${e.key}：', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Expanded(child: Text(e.value ?? 'N/A', style: const TextStyle(fontSize: 13))),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }


}

/// --- 小元件：頂部資訊 Banner（卡片樣式） --------------------------
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
    final titleStyle = theme.textTheme.titleMedium!
        .copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = theme.textTheme.bodyMedium;

    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: titleStyle),
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