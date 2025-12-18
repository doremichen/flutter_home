///
/// real_service.dart
/// RealDataService
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
///
import 'dart:math';

import '../model/data.dart';

import '../interface/data_service.dart';

class RealDataService implements DataService {

  final Random _random = Random();
  int callCount = 0;

  @override
  Future<Data> get(String key) async {
    // update call count
    callCount++;
    // 模擬 200~500ms 的網路延遲
    final delay = 200 + _random.nextInt(300);
    await Future.delayed(Duration(milliseconds: delay));

    return Data(
      key: key,
      content: '真實數據內容 $key: (呼叫次數: #$callCount)',
      at: DateTime.now(),
      source: 'real',
    );
  }

}