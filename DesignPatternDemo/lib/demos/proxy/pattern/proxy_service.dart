///
/// proxy_service.dart
/// VirtualProxy
/// ProtectionProxy
/// CachingProxy
/// LoggingProxy
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/data_service.dart';
import '../model/data.dart';
import '../model/real_service.dart';

// the proxy of real service
class VirtualProxy implements DataService {

  RealDataService? _realService;
  RealDataService get realService => _realService ??= RealDataService();

  @override
  Future<Data> get(String key) => realService.get(key);

  RealDataService? get peekReal => _realService;
}

// --- protected service ---
enum AccessRole { guest, user, admin }
class ProtectionProxy implements DataService {
  final DataService service;
  final AccessRole role;

  ProtectionProxy({required this.service, required this.role});

  @override
  Future<Data> get(String key) async {
    // geust
    if (role == AccessRole.guest) {
      // 故意加入極小延遲 (50ms)，防止針對權限校驗的側寫攻擊
      await Future.delayed(const Duration(milliseconds: 50));
      return Data(
        key: key,
        content: '403 Forbidden: guest 無權限訪問',
        at: DateTime.now(),
        source: 'forbidden',
      );
    }

    return service.get(key);
  }
  
}

// --- Cache proxy ---
class CachingProxy implements DataService {
  final DataService service;
  void Function()? onHit;
  void Function()? onMiss;

  // Map
  final Map<String, Future<Data>> _cache = {};

  // constructor
  CachingProxy({required this.service,
    required this.onHit,
    required this.onMiss});

    @override
    Future<Data> get(String key) async{
      final cached = _cache[key];
      if (cached != null) {
        onHit?.call();  // hit call back
        return cached.then((d) => _wrapAsCache(d));
      }

      onMiss?.call();   //  miss call back

      // trigger new request and put in map
      final future = service.get(key);
      _cache[key] = future;

      // 強健性改進：如果 Future 失敗了，必須從快取中移除該 Key
      // 否則下一個請求會永遠拿到這個失敗的 Future
      return future.then((data) {
        return data;
      }).catchError((Object error) {
        _cache.remove(key); // 錯誤自動清除
        throw error; // 繼續拋出錯誤給上層
      });
    }

    Data _wrapAsCache(Data data) {
      return Data(
        key: data.key,
        content: data.content,
        at: DateTime.now(),
        source: 'cache',
      );
    }

    void get clear => _cache.clear();
}
// --- log proxy ---
class LoggingProxy implements DataService {
  final DataService service;
  final void Function(String) log;

  LoggingProxy({required this.service, required this.log});

  @override
  Future<Data> get(String key) async {
    log('--- [LOG] 開始獲取: "$key" ---');

    final stopWatch = Stopwatch()..start();
    try {
      final data = await service.get(key);
      stopWatch.stop();

      log('--- [LOG] 獲取完成: "$key"，耗時: ${stopWatch.elapsedMilliseconds}');
      return data;
    } catch (e) {
      stopWatch.stop();
      log('--- [LOG] 獲取失敗: "$key"，耗時: ${stopWatch.elapsedMilliseconds}');
      rethrow;
    }
  }
}

