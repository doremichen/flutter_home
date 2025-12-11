///
/// builder_demo.dart
/// BuilderDemoPage
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart.';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// --- 新增：Demo 目的說明（位於 AppBar 下方） ---
            _InfoBanner(
              title: '此 Demo 的目的',
              lines: const [
                '以「餐點建造」為例，演示 Builder 模式如何將「建造流程（Director）」與「建造細節（ConcreteBuilder）」分離。',
                '你可以在下拉選單切換不同 Builder（健康餐/速食餐/素食餐），再按下按鈕選擇建造配方（輕套餐/全餐）。',
                '右下方會顯示建造步驟的 Log 與最終成品，用來觀察不同 Builder 在相同流程下的差異。',
              ],
            ),
            const SizedBox(height: 16),

            /// --- 原本的控制列：選擇 Builder + 操作按鈕 ---
            Row(
              children: [
                const Text('餐點類型：'),
                const SizedBox(width: 12),
                DropdownButton<BuilderKind>(
                  value: _selected,
                  onChanged: _onBuilderChanged,
                  items: const [
                    DropdownMenuItem(
                      value: BuilderKind.healthy,
                      child: Text('健康餐'),
                    ),
                    DropdownMenuItem(
                      value: BuilderKind.fastfood,
                      child: Text('速食餐'),
                    ),
                    DropdownMenuItem(
                      value: BuilderKind.vegan,
                      child: Text('素食餐'),
                    ),
                  ],
                ),
                const Spacer(),
                FilledButton.tonal(
                  onPressed: _constructLight,
                  child: const Text('建造輕套餐'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _constructFull,
                  child: const Text('建造全餐'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// --- 建造步驟 Log ---
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.separated(
                    itemBuilder: (_, i) => Text(_builder.logs[i]),
                    separatorBuilder: (_, __) =>
                    const Divider(height: 12, thickness: 0.5),
                    itemCount: _builder.logs.length,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// --- 成品結果區 ---
            if (_result != null)
              Card(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('最終成品：'),
                      const SizedBox(height: 8),
                      ..._result!.toMap().entries.map(
                            (e) => Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                e.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text('：'),
                            Expanded(
                              child: Text(e.value ?? '（未設定）'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _result.toString(),
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: theme.colorScheme.outline),
                      ),
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