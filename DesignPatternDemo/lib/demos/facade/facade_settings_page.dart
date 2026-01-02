///
/// facade_settings_page.dart
/// FacadeSettingsPage
///
/// Created by Adam Chen on 2026/01/02
/// Copyright © 2025 Abb company. All rights reserved
///
import 'view_model/facade_view_model.dart';
import 'package:flutter/material.dart';

class FacadeSettingsPage extends StatefulWidget {
  final FacadeViewModel vm;
  const FacadeSettingsPage({super.key, required this.vm});

  @override
  State<StatefulWidget> createState() => _FacadeSettingsPageState();
}

class _FacadeSettingsPageState extends State<FacadeSettingsPage> {
  late final TextEditingController _movieController;
  late final TextEditingController _gameController;
  late final TextEditingController _playlistController;

  @override
  void initState() {
    super.initState();
    _movieController = TextEditingController(text: widget.vm.movieTitle);
    _gameController = TextEditingController(text: widget.vm.gameTitle);
    _playlistController = TextEditingController(text: widget.vm.playlistName);
  }

  @override
  void dispose() {
    _movieController.dispose();
    _gameController.dispose();
    _playlistController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, _) {
        // sync controller
        _syncController(_movieController, widget.vm.movieTitle);
        _syncController(_gameController, widget.vm.gameTitle);
        _syncController(_playlistController, widget.vm.playlistName);

        return Scaffold(
            appBar: AppBar(title: const Text('配置場景參數')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('選擇場景模式', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildSceneSelector(widget.vm),
                  const SizedBox(height: 24),
                  const Text('詳細參數設定', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildSettingTiles(widget.vm),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('完成配置並返回'),
                    ),
                  ),
                ],
              ),
            ),
        );


      },
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text != value) {
      controller.text = value;
    }
  }

  Widget _buildSceneSelector(FacadeViewModel vm) {
    return Column(
      children: [
        const Text('1. 場景配置', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Center(
          child: SegmentedButton<SceneKind>(
            segments: const [
              ButtonSegment(value: SceneKind.movie, label: Text('Movie'), icon: Icon(Icons.movie)),
              ButtonSegment(value: SceneKind.game, label: Text('Game'), icon: Icon(Icons.videogame_asset)),
              ButtonSegment(value: SceneKind.music, label: Text('Music'), icon: Icon(Icons.music_note)),
            ],
            selected: {vm.selectedScene},
            onSelectionChanged: (s) => vm.selectScene(s.first),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTiles(FacadeViewModel vm) {
    return Column(
      children: [
        // movie tile, gem title, play list
        _buildSettingItem(
          icon: Icons.movie_outlined,
          label: '電影名稱',
          value: vm.movieTitle,
          onTap: () => _showEditDialog('電影名稱', _movieController, vm.setMovieTitle),
        ),
        _buildSettingItem(
          icon: Icons.videogame_asset_outlined,
          label: '遊戲標題',
          value: vm.gameTitle,
          onTap: () => _showEditDialog('遊戲標題', _gameController, vm.setGameTitle),
        ),
        _buildSettingItem(
          icon: Icons.library_music_outlined,
          label: '播放清單',
          value: vm.playlistName,
          onTap: () => _showEditDialog('播放清單', _playlistController, vm.setPlaylistName),
        ),

      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required String value,
    required onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200)
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueGrey),
        title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(
          value,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.edit_note, size: 20),
        onTap: onTap,
        dense: true,
      ),
    );
  }

  Future<void> _showEditDialog (
      String title,
      TextEditingController controller,
      Function(String) onSave
      ) async {

    //打開時自動全選文字，方便使用者直接覆蓋
    controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length
    );

    // 每次打開對話框前，先同步目前的 VM 數值
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('編輯 $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '請輸入$title',
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => controller.clear(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('取消'),
          ),
          // confirm
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('確認'),
          ),
        ],
      ),
    );

    if (result != null) {
      onSave(result);
    }
  }


}