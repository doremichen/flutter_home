
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/log_view_model.dart';
import 'widgets/control_panel.dart';
import 'widgets/info_banner.dart';
import 'widgets/log_list.dart';

class ObserverDemoPage extends StatelessWidget {
  const ObserverDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LogViewModel(),
      child: const _ObserverDemoBody(),
    );

  }

}

class _ObserverDemoBody extends StatelessWidget {
  const _ObserverDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<LogViewModel>(
      builder: (context, vm, _) {

        // show toast
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
            title: const Text('Observer Pattern Demo'),
          ),
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