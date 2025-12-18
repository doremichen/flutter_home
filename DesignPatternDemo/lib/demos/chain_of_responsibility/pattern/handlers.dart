///
/// handlers.dart
/// AuthHandler
/// SpamHandler
/// ValidationHandler
/// Tier1Handler
/// Tier2Handler
/// ManagerHandler
///
/// Created by Adam Chen on 2025/12/18.
/// Copyright © 2025 Abb company. All rights reserved.
///
// AuthHandler
import 'dart:math';

import 'package:design_pattern_demo/demos/chain_of_responsibility/model/data.dart';

import '../interface/handler.dart';

class AuthHandler extends Handler {
  AuthHandler({required super.logStr});

  @override
  Future<Response?> handle(Request req) async {
    logStr('[Auth] check hasAuth=${req.hasAuth}');
    if (!req.hasAuth) {
      return Response(
        handleBy: 'AuthHandler',
        status: '401 Unauthorized',
        note: '缺少認證憑證',
      );
    }
    // next
    return proceed(req);
  }

}

//SpamHandler
class SpamHandler extends Handler {

  Random _random = Random();
  SpamHandler({required super.logStr});
  @override
  Future<Response?> handle(Request req) async {
    // 簡單規則 + 隨機：若包含黑名單詞或略高機率標記為 spam
    final isBlacklisted = req.message.contains('FREE MONEY') || req.message.contains('CLICK HERE');
    final randomHit = _random.nextDouble() < 0.05; // 5% 假設誤判/攔截
    final isSpam = isBlacklisted || randomHit;

    logStr('[Spam] blacklisted=$isBlacklisted randomHit=$randomHit → isSpam=$isSpam');
    if (isSpam) {
      return Response(
        handleBy: 'SpamHandler',
        status: '403 Forbidden',
        note: '訊息疑似垃圾，已攔截',
      );
    }
    return proceed(req);
  }

}

//ValidationHandler
class ValidationHandler extends Handler {
  ValidationHandler({required super.logStr});

  @override
  Future<Response?> handle(Request req) async {
    final tooShort = req.message
        .trim()
        .length < 5;
    logStr('[Validation] messageLen=${req.message.length} tooShort=$tooShort');

    if (tooShort) {
      return Response(
        handleBy: 'ValidationHandler',
        status: '422 Unprocessable',
        note: '訊息長度太短',
      );
    }

    // NEXT
    return proceed(req);
  }
}

// Tier1Handler
class Tier1Handler extends Handler {
  Tier1Handler({required super.logStr});

  @override
  Future<Response?> handle(Request req) async {
    // Tier1 可處理低嚴重度或 billing 類別；高嚴重度則轉交
    final canHandle = req.severity == Severity.low || req.category == Category.billing;
    logStr('[Tier1] canHandle=$canHandle (category=${req.category}, severity=${req.severity})');

    if (canHandle && req.severity != Severity.high) {
        return Response(
          handleBy: 'Tier1Handler',
          status: 'RESOLVED',
          note: 'Tier1 已完成回覆/退款流程',
        );
    }

    // next
    return proceed(req);
  }

}

// Tier2Handler
class Tier2Handler extends Handler {
  Tier2Handler({required super.logStr});

  @override
  Future<Response?> handle(Request req) async {
    // Tier2 專注於 tech 中高嚴重度
    final canHandle = req.category == Category.tech && req.severity != Severity.low;
    logStr('[Tier2] canHandle=$canHandle (category=${req.category}, severity=${req.severity})');

    if (canHandle) {
      return Response(
        handleBy: 'Tier2Handler',
        status: 'RESOLVED',
        note: '技術支援已提供修復/替代方案',
      );
    }
    // NEXT
    return proceed(req);
  }

}

// ManagerHandler
class ManagerHandler extends Handler {
  ManagerHandler({required super.logStr});

  @override
  Future<Response?> handle(Request req) async {
    logStr('[Manager] escalate and decide final action.');
    return Response(
      handleBy: 'ManagerHandler',
      status: 'ESCALATED',
      note: '升級處理：特例、客訴或重大事件',
    );

  }

}