///
/// cor_view_model.dart
/// CoRViewModel
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';

import '../model/data.dart';
import '../pattern/cor_context.dart';

class CoRViewModel extends ChangeNotifier {
  // --- UI setting ---
  Category category = Category.billing;
  Severity severity = Severity.low;
  bool hasAuth = true;
  bool enableSpam = true;
  bool enableValidation = true;
  bool enableTier1 = true;
  bool enableTier2 = true;
  bool enableManager = true;
  String message = '退款流程諮詢';

  // --- summary ---
  int total = 0;
  int handledByAuth = 0;
  int handledBySpam = 0;
  int handledByValidation = 0;
  int handledByTier1 = 0;
  int handledByTier2 = 0;
  int handledByManager = 0;

  // --- Output ---
  Response? lastResponse;
  final List<String> logs = [];
  String? _lastToast;

  String? takeLastToast() {
    final m = _lastToast;
    _lastToast = null;
    return m;
  }

  // --- set ---
  void setCategory(Category c) {
    category = c;
    notifyListeners();
  }

  void setSeverity(Severity s) {
    severity = s;
    notifyListeners();
  }

  void setHasAuth(bool b) {
    hasAuth = b;
    notifyListeners();
  }

  void setEnableSpam(bool b) {
    enableSpam = b;
    notifyListeners();
  }

  void setEnableValidation(bool b) {
    enableValidation = b;
    notifyListeners();
  }

  void setEnableTier1(bool b) {
    enableTier1 = b;
    notifyListeners();
  }

  void setEnableTier2(bool b) {
    enableTier2 = b;
    notifyListeners();
  }

  void setEnableManager(bool b) {
    enableManager = b;
    notifyListeners();
  }

  void setMessage(String m) {
    message = m;
    notifyListeners();
  }

 void clearLogs() {
    logs.clear();
    _lastToast = 'Logs cleared';
    notifyListeners();
 }
 void clearSummary() {
    total = 0;
    handledByAuth = 0;
    handledBySpam = 0;
    handledByValidation = 0;
    handledByTier1 = 0;
    handledByTier2 = 0;
    handledByManager = 0;
    _lastToast = 'Stats cleared';
    notifyListeners();
 }

 // --- run ---
  Future<void> runOnce() async {
    final request = Request(
      category: category,
      severity: severity,
      message: message,
      hasAuth: hasAuth,
    );
    // chain of responsible handler
    final head = ChainBuilder(logStr: (s) => logs.add(s)).build(
      logStr: logs.add,
      withSpam: enableSpam,
      withValidation: enableValidation,
      withTier1: enableTier1,
      withTier2: enableTier2,
      withManager: enableManager,
    );

    try {
      final res = await head.handle(request);
      total++;
      lastResponse = res;
      _lastToast = res?.status;

      // 統計 by handler
      switch (res?.handleBy) {
        case 'AuthHandler': handledByAuth++; break;
        case 'SpamHandler': handledBySpam++; break;
        case 'ValidationHandler': handledByValidation++; break;
        case 'Tier1': handledByTier1++; break;
        case 'Tier2': handledByTier2++; break;
        case 'Manager': handledByManager++; break;
        default: break;
      }
    } catch (e, st) {
      // show ui
      final err = _toErrorResponse(e, st);
      lastResponse = err;
      _lastToast = err.status; // SnackBar 顯示 "ERROR"
      logs.add('[Error] $e');
      logs.add(st.toString());
    }
    notifyListeners();
  }

  Future<void> runBatch(int n) async {

    // chain of responsible handler
    final head = ChainBuilder(logStr: (s) => logs.add(s)).build(
      logStr: logs.add,
      withSpam: enableSpam,
      withValidation: enableValidation,
      withTier1: enableTier1,
      withTier2: enableTier2,
      withManager: enableManager,
    );
    // loop
    for (var i = 0; i < n; i++) {
      // random produce request
      final cat = Category.values[i % Category.values.length];
      final sev = Severity.values[i % Severity.values.length];
      final msg = (i % 4 == 0) ? 'FREE MONEY' : (i % 3 == 0) ? 'CLICK HERE' : '問題描述 #$i';

      category = cat;
      severity = sev;
      message = msg;
      // gen request
      final request = Request(
        category: category,
        severity: severity,
        message: message,
        hasAuth: hasAuth,
      );
      try {
        final res = await head.handle(request);
        total++;
        lastResponse = res;
        switch (res?.handleBy) {
          case 'AuthHandler': handledByAuth++; break;
          case 'SpamHandler': handledBySpam++; break;
          case 'ValidationHandler': handledByValidation++; break;
          case 'Tier1': handledByTier1++; break;
          case 'Tier2': handledByTier2++; break;
          case 'Manager': handledByManager++; break;
          default: break;
        }
      } catch (e, st) {
        final err = _toErrorResponse(e, st);
        lastResponse = err;       // UI 顯示最後一次的錯誤
        logs.add('[Error] $e');   // 批次不中斷，繼續下一筆
        logs.add(st.toString());
      }
    }
    _lastToast = 'Batch $n done';
    notifyListeners();
  }


  Response _toErrorResponse(Object error, StackTrace st) {
    final msg = error.toString();
    return Response(
      handleBy: 'Error',
      status: 'ERROR',
      note: msg,
    );
  }

}