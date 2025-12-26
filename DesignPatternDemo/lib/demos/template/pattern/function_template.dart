///
/// function_template.dart
/// FunctionTemplate
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import '../interface/report_template.dart';
import '../model/report_stats.dart';

// typedef function in every step of template
typedef StepList = List<int> Function(List<int> data, List<String> logs);
typedef StepStats = ReportStats Function(List<int> data, List<String> logs);
typedef StepHeader = String Function(ReportStats stats, List<String> logs);
typedef StepBody = List<String> Function(List<int> data, ReportStats stats, List<String> logs);
typedef StepFooter = String Function(ReportStats stats, List<String> logs);
typedef Hook = void Function(List<String> logs);

class FunctionTemplate {
  final String name;
  final Hook? onBefore;
  final Hook? onAfter;
  final StepList preprocess;
  final StepList validate;
  final StepList transform;
  final StepStats aggregate;
  final StepHeader buildHeader;
  final StepBody buildBody;
  final StepFooter buildFooter;

  FunctionTemplate({
    required this.name,
    this.onBefore,
    this.onAfter,
    required this.preprocess,
    required this.validate,
    required this.transform,
    required this.aggregate,
    required this.buildHeader,
    required this.buildBody,
    required this.buildFooter,
  });

  // main flow
  TemplateOutput generate(List<int> data) {
    final logs = <String>[];
    logs.add('開始流程（函式模板）：$name');

    onBefore?.call(logs);

    final cleaned = preprocess(data, logs);
    final valid = validate(cleaned, logs);
    final transformed = transform(valid, logs);
    final stats = aggregate(transformed, logs);
    final header = buildHeader(stats, logs);
    final body = buildBody(transformed, stats, logs);
    final footer = buildFooter(stats, logs);

    onAfter?.call(logs);

    final lines = <String>[header, ...body, footer];
    logs.add('完成流程，共 ${lines.length} 行');
    return TemplateOutput(lines: lines, logs: logs);
  }

}