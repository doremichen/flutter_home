///
/// info_banner.dart
/// InfoBanner
///
/// Created by Adam Chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/shape_view_model.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  String _label(VisitorType t) => switch (t) {
    VisitorType.area => '面積',
    VisitorType.perimeter => '周長',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShapeViewModel>();
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline),
              title: const Text('訪問者 (Visitor)'),
              subtitle: Text(
                '目前 Visitor：${_label(vm.visitorType)}（${vm.visitorName}）'
                    '\n圖形數量：${vm.shapes.length}'
                    '\n輸出預覽：${vm.outputLines == null ? '(尚未執行)' : vm.outputLines!.take(2).join(' / ')}',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '資料結構（Shape）與操作（Visitor）分離：'
                  '\n• Shape 只負責資料與 accept(visitor)。'
                  '\n• Visitor 實作各種演算法（面積、週長等），不需修改 Shape 類別。'
                  '\n• 新增演算法只需新增 Visitor 類別。',
            ),
          ],
        ),
      ),
    );
  }
}