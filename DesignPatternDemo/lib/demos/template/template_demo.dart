///
/// template_demo.dart
/// TemplateDemoPage
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/report_view_model.dart';
import 'widgets/info_banner.dart';
import 'widgets/control_panel.dart';
import 'widgets/log_list.dart';



class TemplateDemoPage extends StatelessWidget {

  const TemplateDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportViewModel(),
      child: const _TemplateDemo(),
    );
  }

}

class _TemplateDemo extends StatelessWidget {

  const _TemplateDemo();

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportViewModel>(
      builder: (context, vm, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.lastToast;
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
            vm.lastToast = null;
          }
        });

        return Scaffold(
          appBar: AppBar(title: const Text('Template Method Pattern Demo (MVVM)')),
          body: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoBanner(),
              ControlPanel(),
              Expanded(child: LogList()),
            ],
          ),
        );
      }
    );
  }
}