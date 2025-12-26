///
/// mediator_demo.dart
/// MediatorDemoPage
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';

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
        // SnackBar（避免在 build 期間觸發）
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
            title: const Text('Mediator Pattern Demo'),
            actions: [
              IconButton(
                tooltip: 'Clear logs',
                icon: const Icon(Icons.delete),
                onPressed: vm.clearLogs,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ===== main content =====
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// --- Info banner ---
                        _InfoBanner(
                          title: '此 Demo 的目的',
                          lines: const [
                            '展示 Mediator（仲介者）集中管理元件互動。',
                            '場景與環境事件由仲介者決策並觸發聯動。',
                            '降低耦合、集中規則、提升可維護性。',
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// --- Control ---
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Scene
                                const Text('Scene'),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    SegmentedButton<SceneKind>(
                                      segments: const [
                                        ButtonSegment(
                                            value: SceneKind.movieNight,
                                            label: Text('Movie Night')),
                                        ButtonSegment(
                                            value: SceneKind.wakeUp,
                                            label: Text('Wake Up')),
                                        ButtonSegment(
                                            value: SceneKind.focus,
                                            label: Text('Focus')),
                                      ],
                                      selected: {vm.scene},
                                      onSelectionChanged: (s) =>
                                          vm.applyScene(s.first),
                                    ),
                                    FilledButton.tonal(
                                      onPressed: vm.toggleLight,
                                      child: Text(
                                        vm.light.on ? 'Light OFF' : 'Light ON',
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                /// Ambient light
                                const Text('Ambient light'),
                                Slider(
                                  value: vm.ambient.toDouble(),
                                  min: 0,
                                  max: 100,
                                  divisions: 10,
                                  label: '${vm.ambient}',
                                  onChanged: (v) =>
                                      vm.setAmbient(v.round()),
                                ),

                                /// Temperature
                                const SizedBox(height: 12),
                                const Text('Temperature (°C)'),
                                Slider(
                                  value: vm.thermostat.temperature,
                                  min: 16,
                                  max: 32,
                                  divisions: 16,
                                  label: vm.thermostat.temperature
                                      .toStringAsFixed(1),
                                  onChanged: vm.setTemperature,
                                ),

                                /// Motion
                                const SizedBox(height: 12),
                                SwitchListTile(
                                  value: vm.motionSensor.detected,
                                  onChanged: vm.setMotion,
                                  title: const Text('Motion detected'),
                                  dense: true,
                                ),

                                /// Light brightness
                                const SizedBox(height: 12),
                                const Text('Light brightness'),
                                Slider(
                                  value: vm.light.brightness.toDouble(),
                                  min: 0,
                                  max: 100,
                                  divisions: 10,
                                  label: '${vm.light.brightness}',
                                  onChanged: vm.light.on
                                      ? (v) => vm
                                      .setLightBrightness(v.round())
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// --- subsystem status ---
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _deviceTile(
                                  icon: Icons.lightbulb,
                                  title: 'Light',
                                  subtitle: vm.light.toString(),
                                  trailing:
                                  'ON: ${vm.light.on ? "Yes" : "No"}',
                                ),
                                const Divider(),
                                _deviceTile(
                                  icon: Icons.blinds,
                                  title: 'Blinds',
                                  subtitle: vm.blinds.toString(),
                                ),
                                const Divider(),
                                _deviceTile(
                                  icon: Icons.thermostat,
                                  title: 'Thermostat',
                                  subtitle: vm.thermostat.toString(),
                                ),
                                const Divider(),
                                _deviceTile(
                                  icon: Icons.motion_photos_on,
                                  title: 'MotionSensor',
                                  subtitle: vm.motionSensor.toString(),
                                ),
                                const Divider(),
                                _deviceTile(
                                  icon: Icons.speaker,
                                  title: 'Speaker',
                                  subtitle: vm.speaker.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// ===== Logs =====
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Logs:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 180,
                  child: Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: vm.logs.length,
                      separatorBuilder: (_, __) =>
                      const Divider(height: 8),
                      itemBuilder: (_, i) => Text(vm.logs[i]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );

  }

  Widget _deviceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing != null ? Text(trailing) : null,
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