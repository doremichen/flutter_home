///
/// audit_report.dart
/// AuditReport
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import '../model/report_stats.dart';

import '../interface/report_template.dart';

class AuditReport extends ReportTemplate {

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
    final low = data.where((v) => v < stats.avg * 0.3).toList();
    final high = data.where((v) => v > stats.avg * 1.7).toList();
    final body = <String>[
      '異常（低）：${low.length} -> ${low.take(10).toList()}',
      '異常（高）：${high.length} -> ${high.take(10).toList()}',
      '樣本：${stats.count}',
    ];
    logs.add('Body：依平均檢出異常值（低/高）');
    return body;
  }

  @override
  String buildFooter(List<int> data, List<String> logs) {
    const footer = '—— Audit 完成';
    logs.add('Footer：$footer');
    return footer;
  }

  @override
  String buildHeader(ReportStats stats, List<String> logs) {
    final header = '🔍 稽核：平均 ${stats.avg.toStringAsFixed(2)}，範圍 [${
        stats.min}..${stats.max}]';
    logs.add('Header：$header');
    return header;
  }

  @override
  String get name => 'AuditReport';

  @override
  List<int> preprocess(List<int> data, List<String> logs) {
    final cleaned = data.whereType<int>().toList();
    logs.add('Preprocess：移除非整數，保留 ${cleaned.length} 筆');
    return cleaned;
  }

  @override
  List<int> transform(List<int> data, List<String> logs) {
    logs.add('Transform：不變更（稽核目的）');
    return data;
  }

  @override
  List<int> validate(List<int> data, List<String> logs) {
    // 稽核保留原始值，轉換步驟不做更動
    logs.add('Validate：保留原值（可含負數）');
    return data;
  }

}