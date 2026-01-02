///
/// facade_demo.dart
/// FacadeDemoPage
///
/// Created by Adam Chen on 2025/12/31
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/facade_view_model.dart';

class FacadeDemoPage extends StatelessWidget {

  const FacadeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FacadeViewModel(),
      child: const _FacadeDemoBody(),
    );
  }

}

class _FacadeDemoBody extends StatefulWidget {
  const _FacadeDemoBody();

  @override
  State<StatefulWidget> createState() {
    return _FacadeDemoBodyState();
  }
}

class _FacadeDemoBodyState extends State<_FacadeDemoBody> {
  // input controller
  final _movieController = TextEditingController(text: 'Interstellar');
  final _gameController = TextEditingController(text: 'Console');
  final _playlistController = TextEditingController(text: 'My Favorites');

  @override
  void dispose() {
    // dispose
    _movieController.dispose();
    _gameController.dispose();
    _playlistController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<FacadeViewModel>(
      builder: (context, vm, _) {
        // SnackBar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.takeLastToast();
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
          }
        });

        final theme = Theme.of(context);
        // synch title
        _movieController.value =
            _movieController.value.copyWith(text: vm.movieTitle);
        _gameController.value =
            _gameController.value.copyWith(text: vm.gameTitle);
        _playlistController.value =
            _playlistController.value.copyWith(text: vm.playlistName);

        return Scaffold(
            appBar: AppBar(
              title: const Text('Facade Pattern Demo'),
              actions: [
                IconButton(
                  tooltip: 'Clear logs',
                  icon: const Icon(Icons.delete),
                  onPressed: vm.clearLogs,
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoBanner(
                    title: '此 Demo 的目的',
                    lines: const [
                      '展示 Facade（外觀）如何為多個子系統提供「統一且精簡」的高階操作介面。',
                      '選擇場景（Movie/Game/Music）並輸入必要參數，一鍵啟動；Facade 會負責協調功放、投影機、燈光、播放器。',
                      '下方顯示整體狀態與子系統狀態，Log 區可觀察 Facade 內部的操作序列（例如看電影的開關與調校步驟）。',
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- select scene and input argument ---
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('場景：'),
                              const SizedBox(width: 8),
                              SegmentedButton<SceneKind>(
                                segments: const [
                                  ButtonSegment(value: SceneKind.movie, label: Text('Movie')),
                                  ButtonSegment(value: SceneKind.game, label: Text('Game')),
                                  ButtonSegment(value: SceneKind.music, label: Text('Music')),
                                ],
                                selected: {vm.selectedScene},
                                onSelectionChanged: (s) => vm.selectScene(s.first),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _movieController,
                                  decoration: const InputDecoration(
                                    labelText: 'Movie title',
                                    hintText: 'e.g., Interstellar',
                                  ),
                                  onChanged: vm.setMovieTitle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _gameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Game title',
                                    hintText: 'e.g., Console',
                                  ),
                                  onChanged: vm.setGameTitle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _playlistController,
                                  decoration: const InputDecoration(
                                    labelText: 'Playlist name',
                                    hintText: 'e.g., My Favorites',
                                  ),
                                  onChanged: vm.setPlaylistName,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // --- button ---
                          Row(
                            children: [
                              FilledButton(onPressed: vm.start, child: const Text('Start')),
                              const SizedBox(width: 8),
                              FilledButton.tonal(onPressed: vm.pause, child: const Text('Pause')),
                              const SizedBox(width: 8),
                              FilledButton.tonal(onPressed: vm.resume, child: const Text('Resume')),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: vm.shutdown,
                                icon: const Icon(Icons.power_settings_new),
                                label: const Text('Shutdown'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // --- status ---
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Icon(Icons.theaters, size: 28),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(vm.overallStatus(), style: theme.textTheme.bodyLarge),
                                  ),
                                ],

                              ),

                            ),
                          ),

                          const Divider(height: 24),

                          // --- subsystem status ---
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Subsystems:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.speaker, size: 22),
                                      SizedBox(width: 8),
                                      Expanded(child: Text('Amplifier status follows overall status above.')),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      Icon(Icons.videocam, size: 22),
                                      SizedBox(width: 8),
                                      Expanded(child: Text('Projector mode and power managed by Facade.')),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      Icon(Icons.lightbulb, size: 22),
                                      SizedBox(width: 8),
                                      Expanded(child: Text('Lights dim level set by scene.')),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      Icon(Icons.play_circle_fill, size: 22),
                                      SizedBox(width: 8),
                                      Expanded(child: Text('Streaming Player play/pause/resume handled by Facade.')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SingleChildScrollView(
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 200,
                                  child: Card(
                                    child: ListView.separated(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: vm.logs.length,
                                      separatorBuilder: (_, __) => const Divider(height: 12),
                                      itemBuilder: (_, i) => Text(vm.logs[i]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        );

      },
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