///
/// mediator_control_page.dart
/// MediatorControlPage
///
/// Created by Adam Chen on 2026/01/07
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/subsystem.dart';
import 'view_model/mediator_view_model.dart';

class MediatorControlPage extends StatelessWidget {

  const MediatorControlPage({super.key});

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<MediatorViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('中介者控制台'),
      ),
      body: SafeArea(
        child:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // select scene
                _selectScene(context, vm),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _environmentControls(vm),
                        const Divider(height: 32),
                        _lightingDetail(vm),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // sensors status
                _SensorsStatus(vm),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectScene(BuildContext context,MediatorViewModel vm) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            _buildSectionTitle(Icons.auto_awesome, '場景模式 (Scenes)'),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownMenu<SceneKind>(
                  width: MediaQuery.of(context).size.width * 0.5, // 給予固定寬度
                  initialSelection: vm.scene,
                  label: const Text('選擇場景'),
                  onSelected: (v) => vm.applyScene(v!),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: SceneKind.movieNight, label: '電影夜'),
                    DropdownMenuEntry(value: SceneKind.wakeUp, label: '起床'),
                    DropdownMenuEntry(value: SceneKind.focus, label: '焦點'),
                  ],
                ),
                const Spacer(),
                // 將 Switch 放在右側，UX 更直覺
                _switchLight(context, vm),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String label,
    required String valueText,
    required Widget child,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Icon(icon, size: 16), const SizedBox(width: 4), Text(label)]),
              Text(valueText, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _switchLight(BuildContext context, MediatorViewModel vm) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('燈光', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Switch(
            // 狀態屬性
            value: vm.light.on,
            onChanged: (_) => vm.toggleLight(),

            // 視覺優化：當開啟時顯示發光的燈泡，關閉時顯示不發光的
            thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
              if (states.contains(WidgetState.selected)) {
                return const Icon(Icons.lightbulb, color: Colors.amber);
              }
              return const Icon(Icons.lightbulb_outline);
            }),

            // 顏色優化：開啟時使用溫暖的琥珀色
            activeThumbColor: Colors.amber,
            activeTrackColor: Colors.amber.withValues(alpha: 0.2),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withValues(alpha: 0.1),
          ),
        ],
      );
  }

  Widget _environmentControls(MediatorViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: _buildSliderTile(
            icon: Icons.thermostat,
            label: '溫度',
            valueText: '${vm.thermostat.temperature.toStringAsFixed(1)}°C',
            child: Slider(
              value: vm.thermostat.temperature,
              min: 16, max: 32, divisions: 16,
              onChanged: vm.setTemperature,
            ),
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: _buildSliderTile(
            icon: Icons.wb_cloudy_outlined,
            label: '環境光',
            valueText: '${vm.ambient}%',
            child: Slider(
              value: vm.ambient.toDouble(),
              min: 0, max: 100, divisions: 10,
              onChanged: (v) => vm.setAmbient(v.round()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _lightingDetail(MediatorViewModel vm) {
    return _buildSliderTile(
      icon: Icons.brightness_6,
      label: '燈光亮度',
      valueText: '${vm.light.brightness}%',
      enabled: vm.light.on,
      child: Slider(
        value: vm.light.brightness.toDouble(),
        min: 0, max: 100, divisions: 10,
        onChanged: vm.light.on ? (v) => vm.setLightBrightness(v.round()) : null,
      ),
    );
  }

  Widget _SensorsStatus(MediatorViewModel vm) {
    return SwitchListTile.adaptive(
      secondary: Icon(
        Icons.motion_photos_on,
        color: vm.motionSensor.detected ? Colors.orange : Colors.grey,
      ),
      value: vm.motionSensor.detected,
      onChanged: vm.setMotion,
      title: const Text('動態感測器'),
      subtitle: Text(vm.motionSensor.detected ? '偵測到移動' : '目前無動靜'),
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: vm.motionSensor.detected ? Colors.orange.withOpacity(0.05) : null,
    );
  }

}