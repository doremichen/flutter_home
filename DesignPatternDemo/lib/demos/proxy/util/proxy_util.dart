///
/// proxy_util.dart
/// ProxyUtil
///
/// Created by Adam Chen on 2025/01/09
/// Copyright © 2025 Abb company. All rights reserved
///
import '../pattern/proxy_context.dart';

class ProxyUtil {
  static String getProxyName(ProxyKind kind) {
    switch (kind) {
      case ProxyKind.virtualOnly: return '延遲載入 (Virtual)';
      case ProxyKind.protectionOnly: return '權限控制 (Protection)';
      case ProxyKind.cachingOnly: return '快取機制 (Caching)';
      case ProxyKind.loggingAndCaching: return '日誌 + 快取';
      case ProxyKind.compositeAll: return '綜合代理 (All)';
    }
  }
}