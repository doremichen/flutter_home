///
/// mediator_demo.dart
/// MediatorDemoPage
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mediator_control_page.dart';
import 'model/subsystem.dart';
import 'view_model/mediator_view_model.dart';

class MediatorDemoPage extends StatelessWidget {

  const MediatorDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MediatorViewModel(),
      child: const _MediatorDemoBody(),
    );
  }

}

class _MediatorDemoBody extends StatelessWidget {
  const _MediatorDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<MediatorViewModel>(
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
          appBar: AppBar(
            title: const Text('中介者 (Mediator)'),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune), // 跳轉設定
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: vm,
                      child: const MediatorControlPage(),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: '清除紀錄',
                icon: const Icon(Icons.delete),
                onPressed: vm.clearLogs,
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // info banner
                  Expanded(flex: 1, child: _buildInfoBanner()),
                  const SizedBox(height: 12),

                  // subsystem status
                  Expanded(flex: 1, child: _buildSubsystemStatus(context, vm)),
                  const SizedBox(height: 12),

                  // logs card
                  Expanded(flex: 1, child: _buildLogs(context, vm)),
                ],
              ),
            ),
          ),
        );
      }
    );

  }

  Widget _buildInfoBanner() {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(16),
        child: _InfoBanner(
          title: '中介者 (Mediator)',
          lines: const [
            '展示中介者集中管理元件互動。',
            '場景與環境事件由仲介者決策並觸發聯動。',
            '降低耦合、集中規則、提升可維護性。',
          ],
        ),
      ),
    );
  }

  Widget _buildSubsystemStatus(BuildContext context, MediatorViewModel vm) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 區塊標題
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.settings_remote, size: 18, color: Colors.blueGrey),
                  SizedBox(width: 8),
                  Text('當前設備狀態', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Divider(),

            // 設備列表
            _buildEnhancedTile(
              context,
              icon: Icons.lightbulb,
              title: '智慧燈具',
              status: vm.light.on ? '已開啟' : '已關閉',
              detail: '亮度: ${vm.light.brightness}%',
              isActive: vm.light.on,
              activeColor: Colors.amber,
            ),
            _buildEnhancedTile(
              context,
              icon: Icons.blinds,
              title: '智慧窗簾',
              status: vm.blinds.open ? '已開啟' : '已關閉',
              detail: '開合度: ${vm.blinds.level}%',
              isActive: vm.blinds.open,
              activeColor: Colors.blue,
            ),
            _buildEnhancedTile(
              context,
              icon: Icons.thermostat,
              title: '恆溫器',
              status: '${vm.thermostat.temperature}°C',
              detail: '運作中',
              isActive: true,
              activeColor: Colors.orange,
            ),
            _buildEnhancedTile(
              context,
              icon: Icons.motion_photos_on,
              title: '感測器',
              status: vm.motionSensor.detected ? '偵測中' : '待命',
              detail: vm.motionSensor.detected ? '發現活動' : '無異常',
              isActive: vm.motionSensor.detected,
              activeColor: Colors.redAccent,
            ),
            _buildEnhancedTile(
              context,
              icon: Icons.speaker,
              title: '音響系統',
              status: vm.speaker.on ? '播放中' : '靜音',
              detail: '音量: ${vm.speaker.volume}%',
              isActive: vm.speaker.on,
              activeColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String status,
        required String detail,
        required bool isActive,
        required Color activeColor,
      }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? activeColor : Colors.grey,
          size: 20,
        ),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(detail, style: const TextStyle(fontSize: 12)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeColor.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isActive ? activeColor : Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLogs(BuildContext context, MediatorViewModel vm) {
    if (vm.logs.isEmpty) return const Text('沒有紀錄!');

    return Container(
      height: 150,
      color: Colors.black87,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('紀錄', style: TextStyle(color: Colors.white70, fontSize: 11)),
              IconButton(icon: const Icon(Icons.delete_sweep, size: 16, color: Colors.white70), onPressed: vm.clearLogs),
            ],
          ),
          Expanded(
            child: ListView.builder(
              primary: false,
              reverse: true,
              itemCount: vm.logs.length,
              itemBuilder: (_, i) => Text('> ${vm.logs[vm.logs.length - 1 - i]}',
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontFamily: 'monospace')),
            ),
          ),
        ],
      ),
    );
  }

}


class _InfoBanner extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _InfoBanner({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle =
    theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = theme.textTheme.bodyMedium;

    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (titleStyle != null) Text(title, style: titleStyle),
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