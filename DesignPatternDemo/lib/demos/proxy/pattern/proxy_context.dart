///
/// proxy_context.dart
///
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/data_service.dart';

import 'proxy_service.dart';

enum ProxyKind {
  virtualOnly,
  protectionOnly,
  cachingOnly,
  loggingAndCaching,
  compositeAll // Protection → Caching → Logging → Virtual → Real
}

// build proxy chain
DataService buildProxyChain({
  required ProxyKind kind,
  required AccessRole role,
  void Function(String)? logWriter,
  void Function()? onHit,
  void Function()? onMiss,
}) {

  final virtual = VirtualProxy();
  // start of chain
  DataService chain = virtual;
  switch (kind) {
    case ProxyKind.virtualOnly:
      break;
    case ProxyKind.protectionOnly:
      chain = ProtectionProxy(service: chain, role: role);
      break;
    case ProxyKind.cachingOnly:
      chain = CachingProxy(service: chain, onHit: onHit, onMiss: onMiss);
      break;
    case ProxyKind.loggingAndCaching:
      chain = CachingProxy(service: chain, onHit: onHit, onMiss: onMiss);
      chain = LoggingProxy(service: chain, log: logWriter ?? (_) {});
      break;
    case ProxyKind.compositeAll:
      chain = ProtectionProxy(service: chain, role: role);
      chain = CachingProxy(service: chain, onHit: onHit, onMiss: onMiss);
      chain = LoggingProxy(service: chain, log: logWriter ?? (_) {});
      break;
    }

  return chain;
}