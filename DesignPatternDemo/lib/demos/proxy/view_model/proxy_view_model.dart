///
/// proxy_view_model
/// ProxyViewModel
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/data_service.dart';
import '../model/data.dart';
import '../pattern/proxy_service.dart';
import 'package:flutter/material.dart';

import '../pattern/proxy_context.dart';

class ProxyViewModel extends ChangeNotifier {
  ProxyKind selectedKind = ProxyKind.compositeAll;
  AccessRole role = AccessRole.user;

  late DataService _service;

  // 統計
  int totalRequests = 0;
  int serviceCalls = 0; // 實際 Real 呼叫次數
  int cacheHits = 0;
  int cacheMisses = 0;

  // 狀態
  final List<Data> results = [];
  final List<String> logs = [];
  String lastKey = 'article-100';
  String? _lastToast;

  ProxyViewModel() {
    _rebuildChain();
  }

  String? takeLastToast() {
    final m = _lastToast;
    _lastToast = null;
    return m;
  }
  
  void selectKind(ProxyKind kind) {
    selectedKind = kind;
    _log('選擇 Proxy：$kind');
    _rebuildChain();
    notifyListeners();
  }

  void setRole(AccessRole r) {
    role = r;
    _log('選擇角色：$role');
    _rebuildChain();
    notifyListeners();
  }

  void setKey(String k) {
    lastKey = k;
    _log('輸入 Key：$lastKey');
    notifyListeners();
  }

  Future<void> fetchOnce() async {
    if (lastKey.isEmpty) return;
    totalRequests++;
    final data = await _service.get(lastKey);
    results.add(data);
    if (data.source == 'real') serviceCalls++;
    _log('請求完成：$data');
    _lastToast = '${data.source}: ${data.key}';
    notifyListeners();
  }

  Future<void> fetchBatch(int times) async {
    for (int i = 0; i < times; i++) {
      // 產生部分重覆的 key，觀察快取命中
      final key = i % 3 == 0 ? lastKey : 'article-${100 + (i % 5)}';
      totalRequests++;
      final data = await _service.get(key);
      results.add(data);
      if (data.source == 'real') serviceCalls++;
    }
    _log('批量請求完成');
    _lastToast = '批量請求完成: $times';
    notifyListeners();
  }

  void clearResults() {
    results.clear();
    totalRequests = 0;
    serviceCalls = 0;
    cacheHits = 0;
    cacheMisses = 0;
    _log('清除結果與統計');
    _lastToast = 'Cleared';
    notifyListeners();
  }

  void clearLogs() {
    logs.clear();
    _lastToast = 'Logs cleared';
    notifyListeners();
  }

  // --- helper ---
  void _rebuildChain() {
    _service = buildProxyChain(
      kind: selectedKind,
      role: role,
      logWriter: (s) => logs.add(s),
      onHit: () => cacheHits++,
      onMiss: () => cacheMisses++,
    );
    _log('代理鏈已重建：$selectedKind (role=$role)');
  }

  void _log(String s) => logs.add(s);

}