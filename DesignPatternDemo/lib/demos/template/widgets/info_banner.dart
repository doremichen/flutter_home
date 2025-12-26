///
/// info_banner.dart
/// InfoBanner
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/report_view_model.dart';

class InfoBanner extends StatelessWidget {

  const InfoBanner({super.key});

  String _label(TemplateType type) => switch (type) {
    TemplateType.sales => '銷售報表',
    TemplateType.inventory => '庫存報表',
    TemplateType.audit => '稽核報表',
    TemplateType.functionBased => '函式模板',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportViewModel>();
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
                title: const Text('Template Method Demo'),
                subtitle: Text(
                  '目前模板：${_label(vm.selectedType)}（${vm.templateName}）'
                      '\n輸入長度：${vm.input.length}'
                      '\n輸出預覽：${vm.lines == null ? '(尚未產生)' : (vm.lines?? []).take(2).join(' / ')}',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '父類封裝流程（不可改順序），子類實作每個步驟；'
                    '或以函式直接提供步驟——但流程仍由模板掌控。',
              ),
            ],
          ),
        ),
    );
  }

}