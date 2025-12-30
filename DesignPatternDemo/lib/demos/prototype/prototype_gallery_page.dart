///
/// prototype_gallery_page.dart
/// PrototypeGalleryPage
///
/// Created by Adam Chen on 2025/12/30.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart.';

import 'util/color_parser.dart';

class PrototypeGalleryPage extends StatelessWidget {
  final dynamic vm;
  const PrototypeGalleryPage({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('已克隆車庫'),
        actions: [
          TextButton(
            onPressed: () {
              vm.clearAll();
              Navigator.pop(context);
            },
            child: const Text('全部清空', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
      body:  vm.created.isEmpty
          ? const Center(child: Text('車庫空空如也，快去克隆一台吧！'))
          : _buildResult(vm),
    );
  }

  Widget _buildResult(dynamic vm) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vm.created.length,
      // 使用分隔線讓清單更有條理
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final car = vm.created[index];
        return Card(
          elevation: 3,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row( // 使用 Row 佈局，左側放圖示，右側放文字資訊
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 左側：編號與圖示 ---
                Column(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.deepPurple.shade50,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: 12, color: Colors.deepPurple.shade700),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Icon(Icons.directions_car, size: 40, color: ColorUtils.parse(car.specs.color)),
                  ],
                ),

                const SizedBox(width: 16),

                // --- 右側：詳細資訊 ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.model,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildInfoTag('顏色: ${car.specs.color}'),
                          const SizedBox(width: 8),
                          _buildInfoTag('座位: ${car.specs.seats}'),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        '附加特徵：',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 4),
                      // 特徵部分使用 Wrap，即使特徵很多也會自動換行而不會溢出
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: car.specs.features.map<Widget>((f) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(f, style: const TextStyle(fontSize: 10, color: Colors.black87)),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 輔助組件：小標籤
  Widget _buildInfoTag(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.black54),
    );
  }

}