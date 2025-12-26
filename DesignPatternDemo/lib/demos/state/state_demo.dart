///
/// state_demo.dart
/// StateDemoPage
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import '../state/widgets/control_panel.dart';
import '../state/widgets/info_banner.dart';
import '../state/widgets/log_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/player_view_model.dart';


class StateDemoPage extends StatelessWidget {

  const StateDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerViewModel(),
      child: const _StateDemoBody(),
    );
  }

}

class _StateDemoBody extends StatelessWidget {
  const _StateDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('State Pattern Demo (MVVM)')),
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