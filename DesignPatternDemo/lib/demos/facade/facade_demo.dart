///
/// facade_demo.dart
/// FacadeDemoPage
///
/// Created by Adam Chen on 2025/12/31
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'facade_log_page.dart';
import 'facade_settings_page.dart';
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
  late final _movieController;
  late final _gameController ;
  late final _playlistController;

  @override
  void initState() {
    super.initState();
    final vm = context.read<FacadeViewModel>();
    _movieController = TextEditingController(text: vm.movieTitle);
    _gameController = TextEditingController(text: vm.gameTitle);
    _playlistController = TextEditingController(text: vm.playlistName);
  }

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
          // text control value
          if (mounted) {
            _movieController.text = vm.movieTitle;
            _gameController.text = vm.gameTitle;
            _playlistController.text = vm.playlistName;
          }
        });

        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Facade 模式 Demo'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: '配置場景參數',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FacadeSettingsPage(vm: vm)),
                ),
              ),
              IconButton(
                icon: Badge(
                  label: Text('${vm.logs.length}'),
                  child: const Icon(Icons.history),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FacadeLogPage(vm: vm)),
                ),
              ),
            ],
          ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInfoBanner(),
                          const SizedBox(height: 16),
                          // 這裡現在即便文字再長也會自動延展，由 SingleChildScrollView 處理
                          _buildOverallStatusPreview(vm),
                          const SizedBox(height: 12),
                          _buildConfigSummary(vm),
                        ],
                      ),
                    ),
                  ),

                  // 分隔線，明確區分顯示區與操作區
                  const Divider(height: 1),
                  const Text('2. 子系統當前配置', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildSubsystemInfo(Icons.speaker, '功放揚聲器', '音量與環繞聲隨場景自動調整'),
                  _buildSubsystemInfo(Icons.videocam, '投影設備', '解析度與長寬比由 Facade 控管'),
                  _buildSubsystemInfo(Icons.lightbulb, '智能燈光', '亮度依據目前模式自動調暗/調亮'),
                  // 固定底部：Facade 統一操作按鈕
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildActionButtons(vm),
                  ),

                ],
              )
            ),
        );
      },
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
              '核心理念：為多個複雜的子系統提供一個統一、精簡的高階介面。',
              '一鍵協調：Facade 自動處理「功放、投影機、燈光、播放器」的開啟順序與設定參數。',
              '操作透明：觀察下方狀態與 Log，看 Facade 如何將簡單的 Start 指令轉化為複雜的調校序列。',
              ]
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStatusPreview(FacadeViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          // icon
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.settings_input_component, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),
          // system status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('家庭劇院系統狀態', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  vm.overallStatus(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(FacadeViewModel vm) {
    return Column(
      children: [
        _buildButtonPair(
          left: FilledButton.icon(
            onPressed: vm.start,
            icon: const Icon(Icons.play_arrow),
            label: const Text('一鍵啟動'),
          ),
          right: OutlinedButton.icon(
            onPressed: vm.shutdown,
            icon: const Icon(Icons.power_settings_new),
            label: const Text('系統關閉'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ),
        const SizedBox(height: 8),
        _buildButtonPair(
          left: FilledButton.tonal(onPressed: vm.pause, child: const Text('暫停播放')),
          right: FilledButton.tonal(onPressed: vm.resume, child: const Text('繼續播放')),
        ),
      ],
    );
  }

  Widget _buildButtonPair({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 8),
        Expanded(child: right),
      ],
    );
  }

  // Widget _buildControlPanelContent(FacadeViewModel vm) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text('1. 場景配置', style: TextStyle(fontWeight: FontWeight.bold)),
  //       const SizedBox(height: 8),
  //       Center(
  //         child: SegmentedButton<SceneKind>(
  //           segments: const [
  //             ButtonSegment(value: SceneKind.movie, label: Text('Movie'), icon: Icon(Icons.movie)),
  //             ButtonSegment(value: SceneKind.game, label: Text('Game'), icon: Icon(Icons.videogame_asset)),
  //             ButtonSegment(value: SceneKind.music, label: Text('Music'), icon: Icon(Icons.music_note)),
  //           ],
  //           selected: {vm.selectedScene},
  //           onSelectionChanged: (s) => vm.selectScene(s.first),
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       // movie tile, gem title, play list
  //       _buildSettingItem(
  //         icon: Icons.movie_outlined,
  //         label: '電影名稱',
  //         value: vm.movieTitle,
  //         onTap: () => _showEditDialog('電影名稱', _movieController, vm.setMovieTitle),
  //       ),
  //       _buildSettingItem(
  //         icon: Icons.videogame_asset_outlined,
  //         label: '遊戲標題',
  //         value: vm.gameTitle,
  //         onTap: () => _showEditDialog('遊戲標題', _gameController, vm.setGameTitle),
  //       ),
  //       _buildSettingItem(
  //         icon: Icons.library_music_outlined,
  //         label: '播放清單',
  //         value: vm.playlistName,
  //         onTap: () => _showEditDialog('播放清單', _playlistController, vm.setPlaylistName),
  //       ),
  //
  //       const SizedBox(height: 24),
  //       const Text('2. 子系統當前配置', style: TextStyle(fontWeight: FontWeight.bold)),
  //       const SizedBox(height: 8),
  //       _buildSubsystemInfo(Icons.speaker, '功放揚聲器', '音量與環繞聲隨場景自動調整'),
  //       _buildSubsystemInfo(Icons.videocam, '投影設備', '解析度與長寬比由 Facade 控管'),
  //       _buildSubsystemInfo(Icons.lightbulb, '智能燈光', '亮度依據目前模式自動調暗/調亮'),
  //     ],
  //   );
  // }

  Widget _buildSubsystemInfo(IconData icon, String title, String desc) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
      dense: true,
      // 縮小內距以節省螢幕空間
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap
  }) {
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

  Widget _buildConfigSummary(FacadeViewModel vm) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FacadeSettingsPage(vm: vm)),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.tune, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '配置參數：${vm.getCurrentTitle()}',
                style: const TextStyle(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
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