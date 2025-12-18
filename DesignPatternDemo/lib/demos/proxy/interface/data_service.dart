///
/// data_service.dart
/// DataService
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/data.dart';

abstract class DataService {
  Future<Data> get(String key);
}