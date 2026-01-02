///
/// handler.dart
/// Handler
///
/// Created by Adam Chen on 2025/12/11
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../model/data.dart';

abstract class Handler {
  Handler? next;
  final void Function(String) logStr;

  Handler({required this.logStr});

  // set next
  Handler setNext(Handler handler) {
    next = handler;
    return handler;
  }

  // implement by subclass
  Future<Response?> handle(Request req);

  Future<Response> proceed(Request req) async {
    final nextHandler = next;
    if (nextHandler == null) {
      // terminal condition
      throw StateError('[${runtimeType}] 鏈條已結束，但沒有任何 Handler 給出回應。請確保鏈條末端有一個終端處理者。');
    }

    final response = await nextHandler.handle(req);

    if (response == null) {
      throw StateError('[${nextHandler.runtimeType}] 回傳了 null；責任鏈必須以一個具體的 Response 結束。');
    }

    return response;
  }

}