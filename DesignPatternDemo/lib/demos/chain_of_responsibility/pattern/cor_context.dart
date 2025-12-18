///
/// cor_context.dart
/// ChainBuilder
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../interface/handler.dart';
import 'handlers.dart';

class ChainBuilder {
  final void Function(String) logStr;

  ChainBuilder({required this.logStr});

  Handler build({
    required void Function(String) logStr,
    required bool withSpam,
    required bool withValidation,
    required bool withTier1,
    required bool withTier2,
    required bool withManager,
  }) {
    // 1. Build a chain of handlers
    final activeHandlers = <Handler>[
      AuthHandler(logStr: logStr),
      if (withSpam) SpamHandler(logStr: logStr),
      if (withValidation) ValidationHandler(logStr: logStr),
      if (withTier1) Tier1Handler(logStr: logStr),
      if (withTier2) Tier2Handler(logStr: logStr),
      if (withManager) ManagerHandler(logStr: logStr),
      // if (withAuth) AuthHandler(logStr: logStr),
      // if (withSpam) SpamHandler(logStr: logStr),
      // if (withValidation) ValidationHandler(logStr: logStr),
      // if (withTier1) Tier1Handler(logStr: logStr),
      // if (withTier2) Tier2Handler(logStr: logStr),
      // if (withManager) ManagerHandler(logStr: logStr),
    ];

    // 2. active handlers check
    if (activeHandlers.isEmpty) {
      throw StateError('責任鏈必須至少包含一個處理者。');
    }

    // 3. Set up the chain
    for (int i = 0; i < activeHandlers.length - 1; i++) {
      activeHandlers[i].setNext(activeHandlers[i + 1]);
    }

    // 4. return the first handler
    return activeHandlers.first;
  }
}