

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/genre.dart';
import 'view_model/iterator_view_model.dart';

class IteratorControlPage extends StatelessWidget {

  const IteratorControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    // vm
    final vm = context.watch<IteratorViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('迭代模式控制台'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '播放控制器',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // select iterator type
                _buildSelectedType(vm),

                const SizedBox(height: 24),

                // action button
                _buildActionButton(context, vm),
              ],
            ),
        ),
        ),
      ),

    );

  }

  Widget _buildSelectedType(IteratorViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _iteratorButtons(vm),
            const SizedBox(height: 8),

            // Filter iterator
            if (vm.iteratorKind == IteratorKind.filterGenre) ...[
              _genreButtons(vm),
              const SizedBox(height: 8),
            ],

            // Step iterator
            if (vm.iteratorKind == IteratorKind.step) ...[
              _stepSlider(vm),
              const SizedBox(height: 8),
            ],

          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IteratorViewModel vm) {

    void _execute(VoidCallback action) {
      action();
      Navigator.of(context).pop(); // pop
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 主要控制區：核心前進動作
        Row(
          children: [
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: () => _execute(vm.nextOne),
                icon: const Icon(Icons.skip_next),
                label: const Text('Next'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12), // 增加點擊高度
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: FilledButton.tonal(
                onPressed: () => _execute(() => vm.nextBatch(5)),
                child: const Text('×5'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 功能控制區：對播放列表的修改
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _execute(vm.shufflePlaylist),
                icon: const Icon(Icons.shuffle, size: 18),
                label: const Text('Shuffle'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _execute(vm.addSampleSong),
                icon: const Icon(Icons.library_add, size: 18),
                label: const Text('Add Song'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 次要操作：重置 (使用 TextButton 降低視覺重量)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _execute(vm.reset),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset Playlist'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error, // 提醒此操作具破壞性
            ),
          ),
        ),
      ],
    );
  }

  Widget _iteratorButtons(IteratorViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('選擇模式：', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownMenu<IteratorKind>(
            initialSelection: vm.iteratorKind,
            onSelected: (v) => vm.selectKind(v!),
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: IteratorKind.forward, label: '向前'),
              DropdownMenuEntry(value: IteratorKind.reverse, label: '反向'),
              DropdownMenuEntry(value: IteratorKind.filterGenre, label: '篩選'),
              DropdownMenuEntry(value: IteratorKind.step, label: '步階'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _genreButtons(IteratorViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('選擇風格：', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownMenu<Genre>(
            initialSelection: vm.filterGenre,
            onSelected: (v) => vm.selectGenre(v!),
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: Genre.rock, label: '락'),
              DropdownMenuEntry(value: Genre.pop, label: '流行'),
              DropdownMenuEntry(value: Genre.jazz, label: '爵士'),
              DropdownMenuEntry(value: Genre.classical, label: '古典'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepSlider(IteratorViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('步階：${vm.step}', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        Slider(
          value: vm.step.toDouble(),
          min: 1,
          max: 8,
          divisions: 7,
          onChanged: (v) => vm.setStep(v.round()),
        ),
      ],
    );

  }

}