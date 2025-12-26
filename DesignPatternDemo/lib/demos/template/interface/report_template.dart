///
/// report_template.dart
/// ReportTemplate
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/report_stats.dart';

class TemplateOutput {
  // lines
  final List<String> lines;
  // logs
  final List<String> logs;

  TemplateOutput({required this.lines, required this.logs});
}

abstract class ReportTemplate {
  String get name;

  // main flow
  TemplateOutput generate(List<int> data) {
    // logs
    final List<String> logs = [];
    logs.add('Start template: $name');

    onBefore(logs);

    final cleaned = preprocess(data, logs);
    final valid = validate(data, logs);
    final transformed = transform(data, logs);
    final stats = aggregate(data, logs);
    final header = buildHeader(stats, logs);
    final body = buildBody(data, stats, logs);
    final footer = buildFooter(data, logs);

    onAfter(logs);

    final lines = <String>[
      header,
      ...body,
      footer,
    ];

    return TemplateOutput(lines: lines, logs: logs);
  }

  // step method
  List<int> preprocess(List<int> data, List<String> logs);
  List<int> validate(List<int> data, List<String> logs);
  List<int> transform(List<int> data, List<String> logs);
  ReportStats aggregate(List<int> data, List<String> logs);
  String buildHeader(ReportStats stats, List<String> logs);
  List<String> buildBody(List<int> data, ReportStats stats, List<String> logs);
  String buildFooter(List<int> data, List<String> logs);

  // option lifecycle
  void onBefore(List<String> logs) {}
  void onAfter(List<String> logs) {}

}
