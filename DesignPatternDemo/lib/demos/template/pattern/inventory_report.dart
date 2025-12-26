///
/// inventory_report_dart
/// InventoryReport
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import 'dart:math';

import 'package:design_pattern_demo/demos/template/model/report_stats.dart';

import '../interface/report_template.dart';

class InventoryReport extends ReportTemplate {
  @override
  ReportStats aggregate(List<int> data, List<String> logs) {
    final count = data.length;
    final sum = data.fold(0, (a, b) => a + b);
    final min = data.isEmpty ? 0 : data.reduce((a, b) => a < b ? a : b);
    final max = data.isEmpty ? 0 : data.reduce((a, b) => a > b ? a : b);
    final avg = count == 0 ? 0.0 : sum / count;
    final stats = ReportStats(count: count, sum: sum, avg: avg, min: min, max: max);
    logs.add('Aggregate：$stats');
    return stats;
  }

  @override
  List<String> buildBody(List<int> data, ReportStats stats, List<String> logs) {
    final low = data.where((v) => v < 20).toList();
    final body = <String>[
      '低庫存（<20）：${low.length} 件',
      '最低 ${stats.min}，最高 ${stats.max}',
      if (low.isNotEmpty) '清單（最多 10）：${low.take(10).toList()}',
    ];
    logs.add('Body：統計低庫存與範圍');
    return body;
  }

  @override
  String buildFooter(List<int> data, List<String> logs) {
    const footer = '—— Inventory 完成';
    logs.add('Footer：$footer');
    return footer;
  }

  @override
  String buildHeader(ReportStats stats, List<String> logs) {
    final header = '🏪 庫存：平均 ${stats.avg.toStringAsFixed(1)}，總庫存 ${stats.sum}';
    logs.add('Header：$header');
    return header;
  }

  @override
  String get name => 'InventoryReport';

  @override
  List<int> preprocess(List<int> data, List<String> logs) {
    final cleaned = data.whereType<int>().toList();
    logs.add('Preprocess：移除非整數，保留 ${cleaned.length} 筆');
    return cleaned;
  }

  @override
  List<int> transform(List<int> data, List<String> logs) {
    final normalized = data.map((v) => min(999, max(0, v))).toList();
    logs.add('Transform：負數→0 / >999→999 -> $normalized');
    return normalized;
  }

  @override
  List<int> validate(List<int> data, List<String> logs) {
    // 保留全部，轉換時做上下限處理
    logs.add('Validate：全部保留，轉換時處理上下限');
    return data;
  }

}