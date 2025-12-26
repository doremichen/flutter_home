///
/// report_view_model.dart
/// ReportViewModel
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart.';

import '../model/log_event.dart';
import '../interface/report_template.dart';
import '../model/report_stats.dart';
import '../pattern/audit_report.dart';
import '../pattern/function_template.dart';
import '../pattern/inventory_report.dart';
import '../pattern/sales_report.dart';

enum TemplateType { sales, inventory, audit, functionBased }

class ReportViewModel extends ChangeNotifier {
  ReportTemplate? _classTemplate;
  FunctionTemplate? _fnTemplate;
  TemplateType _selectedType = TemplateType.sales;

  List<int> _input = [];
  List<String>? _lines;
  final List<LogEvent> _logs = [];
  String? lastToast;

  bool _auto = false;
  Timer? _timer;

  ReportViewModel() {
    _switchTemplate(TemplateType.sales);
    generateData();
  }

  TemplateType get selectedType => _selectedType;
  List<int> get input => List.unmodifiable(_input);
  List<String>? get lines => _lines == null ? null : List.unmodifiable(_lines!);
  List<LogEvent> get logs => List.unmodifiable(_logs);
  bool get auto => _auto;

  String get templateName => switch (_selectedType){
    TemplateType.sales => '銷售報表',
    TemplateType.inventory => '庫存報表',
    TemplateType.audit => '稽核報表',
    TemplateType.functionBased => '函式模板',
  };

  void _switchTemplate(TemplateType type) {
    _clearTemplate();
    switch (type) {
      case TemplateType.sales:
        _classTemplate = SalesReport();
        break;
      case TemplateType.inventory:
        _classTemplate = InventoryReport();
        break;
      case TemplateType.audit:
        _classTemplate = AuditReport();
        break;
      case TemplateType.functionBased:
        _fnTemplate = _buildFunctionTemplate();
        break;
    }

    _selectedType = type;
    _appendLog('切換模板：$templateName');
    lastToast = '切換模板：$templateName';
    notifyListeners();
  }

  void generateData({int count = 12, int maxValue = 120}) {
    final rnd = Random();
    _input = List<int>.generate(
      count,
          (_) => rnd.nextInt(maxValue + 1) * (rnd.nextDouble() < 0.2 ? -1 : 1),
    );
    _lines = null;
    _appendLog('產生資料：$_input');
    lastToast = '產生資料：$_input';
    notifyListeners();
  }

  void _clearTemplate() {
    _classTemplate = null;
    _fnTemplate = null;
  }

  void selectTemplate(TemplateType type) {
    if (type == _selectedType) {
      return;
    }
    _switchTemplate(type);
  }

  void runTemplate() {
    if (_classTemplate == null && _fnTemplate == null) {
      _appendLog('未選擇模板');
      lastToast = '未選擇模板';
      notifyListeners();
      return;
    }

    if (_input.isEmpty) {
      _appendLog('未產生資料');
      lastToast = '未產生資料';
      notifyListeners();
      return;
    }

    List<String>? lines;
    List<String>? tmplLogs;
    // run
    if (_classTemplate != null) {
      final res = _classTemplate!.generate(_input);
      lines = res.lines;
      tmplLogs = res.logs;
    } else if (_fnTemplate != null) {
      final res = _fnTemplate!.generate(_input);
      lines = res.lines;
      tmplLogs = res.logs;
    }

    _lines = lines;
    for (final s in tmplLogs!) {
      _logs.add(LogEvent(s));
    }
    _appendLog('執行模板完成');
    lastToast = '執行模板完成';
    notifyListeners();
  }

  void clear() {
    _logs.clear();
    _input.clear();
    _lines = null;
    _appendLog('清空報表與日誌');
    lastToast = '清空報表與日誌';
    notifyListeners();
  }

  void toggleAuto() {
    _auto = !_auto;
    _timer?.cancel();
    if (_auto) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final rnd = Random().nextBool();
        if (rnd) {
          generateData(count: 10 + Random().nextInt(8));
        } else {
          runTemplate();
        }
      });
    }
    notifyListeners();
  }

  FunctionTemplate? _buildFunctionTemplate() {
    return FunctionTemplate(
      name: '函式模板',
      onBefore: (logs) => logs.add('onBefore(FN)：準備函式模板'),
      onAfter: (logs) => logs.add('onAfter(FN)：完成函式模板'),
      preprocess: (data, logs) {
        final cleaned = data.whereType<int>().toList();
        logs.add('Preprocess(FN)：${cleaned.length} 筆');
        return cleaned;
      },
      validate: (data, logs) {
        logs.add('Validate(FN)：保留全部');
        return data;
      },
      transform: (data, logs) {
        final mapped = data.map((v) => v.abs()).toList();
        logs.add('Transform(FN)：取絕對值 -> $mapped');
        return mapped;
      },
      aggregate: (data, logs) {
        final count = data.length;
        final sum = data.fold(0, (a, b) => a + b);
        final min = data.isEmpty ? 0 : data.reduce((a, b) => a < b ? a : b);
        final max = data.isEmpty ? 0 : data.reduce((a, b) => a > b ? a : b);
        final avg = count == 0 ? 0.0 : sum / count;
        final stats = ReportStats(count: count, sum: sum, avg: avg, min: min, max: max);
        logs.add('Aggregate(FN)：$stats');
        return stats;
      },
      buildHeader: (stats, logs) {
        final header = '🧩 函式模板：avg=${stats.avg.toStringAsFixed(2)}';
        logs.add('Header(FN)：$header');
        return header;
      },
      buildBody: (data, stats, logs) {
        final body = <String>[
          'min=${stats.min}, max=${stats.max}',
          'count=${stats.count}, sum=${stats.sum}',
        ];
        logs.add('Body(FN)：基本統計');
        return body;
      },
      buildFooter: (stats, logs) {
        const footer = '—— Function 完成';
        logs.add('Footer(FN)：$footer');
        return footer;
      },

    );
  }


  @override
  void dispose() {
    _timer?.cancel();
    _clearTemplate();
    super.dispose();
  }

  void _appendLog(String s) {
    _logs.add(LogEvent(s));
  }
}