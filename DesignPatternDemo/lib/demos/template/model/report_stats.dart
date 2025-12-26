///
/// report_stats.dart
/// ReportStats
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
class ReportStats {
  final int count;
  final int sum;
  final double avg;
  final int min;
  final int max;

  const ReportStats({
    required this.count,
    required this.sum,
    required this.avg,
    required this.min,
    required this.max,
  });

  @override
  String toString() =>
      'count=$count, sum=$sum, avg=${avg.toStringAsFixed(2)}, min=$min, max=$max';
}