///
/// sales_repot.dart
/// SalesReport
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import 'dart:math';

import 'package:design_pattern_demo/demos/template/model/report_stats.dart';

import '../interface/report_template.dart';

class SalesReport extends ReportTemplate {

  @override
  String get name => 'SalesReport';

  @override
  void onBefore(List<String> logs) {
    logs.add('onBefore：準備銷售報表');
    super.onBefore(logs);
  }

  @override
  ReportStats aggregate(List<int> data, List<String> logs) {
    final count = data.length;
    final sum = data.fold(0, (a, b) => a + b);
    final min = data.isEmpty ? 0 : data.reduce(minFn);
    final max = data.isEmpty ? 0 : data.reduce(maxFn);
    final avg = count == 0 ? 0.0 : sum / count;
    final stats = ReportStats(
        count: count,
        sum: sum,
        avg: avg,
        min: min,
        max: max);
    logs.add('Aggregate：$stats');
    return stats;
  }

  int minFn(int a, int b) => a < b ? a : b;
  int maxFn(int a, int b) => a > b ? a : b;

  @override
  List<String> buildBody(List<int> data, ReportStats stats, List<String> logs) {
    final sorted = List<int>.from(data)..sort((a, b) => b.compareTo(a));
    final top3 = sorted.take(3).toList();
    final body = <String>[
      'Top-3：${top3.map((e) => '\$${e}').toList()}',
      '最大 \$${stats.max}，最小 \$${stats.min}',
      '筆數：${stats.count}',
    ];
    logs.add('Body：Top-3 / 範圍 / 筆數');
    return body;
  }

  @override
  String buildFooter(List<int> data, List<String> logs) {
    const footer = '—— Sales 完成';
    logs.add('Footer：$footer');
    return footer;
  }

  @override
  String buildHeader(ReportStats stats, List<String> logs) {
    final header = '📈 銷售：總額 \$${stats.sum}，平均 \$${stats.avg.toStringAsFixed(2)}';
    logs.add('Header：$header');
    return header;
  }

  @override
  List<int> preprocess(List<int> data, List<String> logs) {
    final cleaned = data.whereType<int>().toList();
    logs.add('Preprocess：移除非整數，保留 ${cleaned.length} 筆');
    return cleaned;
  }

  @override
  List<int> transform(List<int> data, List<String> logs) {
    // 業績彙總不計負值（退款另報），先將負值歸零
    final normalized = data.map((v) => max(0, v)).toList();
    logs.add('Transform：負值→0 -> $normalized');
    return normalized;
  }

  @override
  List<int> validate(List<int> data, List<String> logs) {
    final cleaned = data.whereType<int>().toList();
    logs.add('Preprocess：移除非整數，保留 ${cleaned.length} 筆');
    return cleaned;
  }

}