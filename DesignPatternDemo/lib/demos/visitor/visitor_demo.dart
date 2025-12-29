

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/shape_view_model.dart';
import 'widgets/info_banner.dart';
import 'widgets/control_panel.dart';
import 'widgets/result_list.dart';

class VisitorDemoPage extends StatelessWidget {

  const VisitorDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShapeViewModel(),
      child: const VisitorDemoView(),
    );
  }

}

class VisitorDemoView extends StatelessWidget {
  const VisitorDemoView();

  @override
  Widget build(BuildContext context) {
    return Consumer<ShapeViewModel>(
      builder: (context, vm, child) {
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
          appBar: AppBar(
            title: const Text('Visitor Demo'),
          ),
          body: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 說明卡
              InfoBanner(),
              // 控制區
              ControlPanel(),
              // 結果清單
              Expanded(child: ResultList()),
            ],
          ),
        );
      }
    );
  }
}