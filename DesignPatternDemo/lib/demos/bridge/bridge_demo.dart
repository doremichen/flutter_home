///
/// bridge_demo.dart
/// BridgeDemoPage
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bridge_log_page.dart';
import 'view_model/bridge_view_model.dart';

class BridgeDemoPage extends StatelessWidget {

  const BridgeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
       return ChangeNotifierProvider(
         create: (_) => BridgeViewModel(),
         child: const _BridgeDemoBody(),
       );
  }

}

class _BridgeDemoBody extends StatelessWidget {
  const _BridgeDemoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<BridgeViewModel>(
        builder: (context, vm, _) {
          // show toast
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final msg = vm.takeLastToast();
            if (msg != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
              );
            }
          });

          final theme = Theme.of(context);

          return Scaffold(
              appBar: AppBar(
                title: const Text('Bridge Pattern Demo'),
                actions: [
                  // 右上角跳轉至結果清單頁面
                  IconButton(
                    icon: Badge(
                      label: Text('${vm.logs.length}'),
                      child: const Icon(Icons.history),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BridgeLogPage(vm: vm)),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // info
                      _buildInfoBanner(),

                      const SizedBox(height: 16),

                      // status live view
                      _buildDeviceStatusPreview(vm),

                      const Divider(height: 32, thickness: 1, color: Colors.black12),

                      // control panel
                      Expanded(
                        child: _buildBridgeControlPanel(vm),
                      ),

                      const SizedBox(height: 16),

                      _buildActionButtonGroup(vm),
                    ],
                  ),
                ),
              ),
          );
        }
    );
  }

  Widget _buildInfoBanner() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 140),
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 8),
          child: _InfoBanner(
            title: '此 Demo 的目的',
            lines: const [
            '展示 bridge 模式：將「抽象（遙控器）」與「實作（裝置）」分離並以組合相連，使兩者可獨立演進。',
            '選擇裝置（TV/Radio/SmartLight），選擇遙控器（Basic/Advanced）。操作按鈕會透過 bridge 呼叫裝置行為。',
            '觀察狀態卡與Log：更換遙控器不需改動裝置；新增裝置不需改動遙控器，達到低耦合可擴充的設計。',
            ]
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceStatusPreview(BridgeViewModel vm) {
    final String deviceName = vm.deviceLabels[vm.selectedDeviceIndex];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade100, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          // show icon
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.orange.shade50,
            child: Icon(
              deviceName == 'SmartLight' ? Icons.lightbulb : (deviceName == 'Radio' ? Icons.radio : Icons.tv),
              color: Colors.orange.shade700,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deviceName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  vm.remote.currentStatus(), // 透過 Bridge 獲取狀態
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ],
            ),
          ),
          // 快速電源開關
          Switch(
            value: vm.remote.currentStatus().contains('ON'), // 簡單邏輯判斷
            onChanged: (_) => vm.togglePower(),
            activeThumbColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildBridgeControlPanel(BridgeViewModel vm) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          const Text('1. 配置橋接組合', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 12),
          // 裝置選擇
          const Text('選擇裝置 (Implementor):', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(vm.deviceLabels.length, (i) {
              return ChoiceChip(
                label: Text(vm.deviceLabels[i]),
                selected: vm.selectedDeviceIndex == i,
                onSelected: (_) => vm.selectDevice(i),
              );
            }),
          ),

          const SizedBox(height: 16),

          // 遙控器選擇
          const Text('選擇遙控器 (Abstraction):', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          SegmentedButton<RemoteKind>(
            segments: const [
              ButtonSegment(value: RemoteKind.basic, label: Text('Basic'), icon: Icon(Icons.settings_input_component)),
              ButtonSegment(value: RemoteKind.advanced, label: Text('Advanced'), icon: Icon(Icons.auto_awesome)),
            ],
            selected: {vm.selectedRemote},
            onSelectionChanged: (s) => vm.selectRemote(s.first),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback? onPreesed, {bool isAdvanced = false}) {
    return ElevatedButton.icon(
      onPressed: onPreesed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isAdvanced ? Colors.deepPurple.shade50 : Colors.white,
        foregroundColor: isAdvanced ? Colors.deepPurple : Colors.black87,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildActionButtonGroup(BridgeViewModel vm) {
    return SingleChildScrollView(
      child: Column(
          children: [
            const SizedBox(height: 24),
            const Text('2. 遙控器操作', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 12),
            Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _actionBtn(Icons.volume_up, 'Vol +', vm.volumeUp),
                  _actionBtn(Icons.volume_down, 'Vol -', vm.volumeDown),
                  _actionBtn(Icons.skip_next, 'Next', vm.next),
                  _actionBtn(Icons.skip_previous, 'Prev', vm.prev),

                  // 進階功能按鈕 (進階遙控器獨有)
                  if (vm.selectedRemote == RemoteKind.advanced) ...[
                    _actionBtn(Icons.volume_off, 'Mute', vm.mute, isAdvanced: true),
                    _actionBtn(Icons.shuffle, 'Random', vm.randomize, isAdvanced: true),
                    _actionBtn(Icons.flash_on, 'Macro', vm.macroPowerPlay, isAdvanced: true),
                  ],
                ],
            ),
          ],
      ),
    );
  }
}

/// --- 頂部資訊卡（沿用既有樣式） ---
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