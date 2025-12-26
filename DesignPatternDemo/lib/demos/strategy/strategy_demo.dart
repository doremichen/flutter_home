
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

import 'view_model/sort_view_model.dart';
import 'widgets/info_banner.dart';
import 'widgets/control_panel.dart';
import 'widgets/log_list.dart';


class StrategyDemoPage extends StatelessWidget {

  const StrategyDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SortViewModel(),
      child: const _StrategyDemoBody(),
    );
  }

}

class _StrategyDemoBody extends StatelessWidget {
  const _StrategyDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<SortViewModel>(
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
          appBar: AppBar(title: const Text('Strategy Pattern Demo (MVVM)')),
          body: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 說明卡
              InfoBanner(),
              // 控制區
              ControlPanel(),
              // 結果清單
              Expanded(child: LogList()),
            ],
          ),
        );
      }
    );

  }
}