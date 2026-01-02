///
/// product.dart
/// Engine
/// Tire
/// SportEngine
/// SportTire
/// FamilyEngine
/// FamilyTire
/// TruckEngine
/// TruckTire
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
abstract class Engine {
  String spec();
}

abstract class Tire {
  String spec();
}

class SportEngine implements Engine {
  @override
  String spec() => '運動型引擎：雙渦輪增壓，高轉速';
}

class SportTire implements Tire {
  @override
  String spec() => '運動胎：軟質配方，高抓地力';
}

class FamilyEngine implements Engine {
  @override
  String spec() => '房車引擎: 燃油效率高，噪音低';
}

class FamilyTire implements Tire {
  @override
  String spec() => '房車胎：舒適耐用';
}

class TruckEngine implements Engine {
  @override
  String spec() => '卡車引擎：高扭力柴油發動機';
}

class TruckTire implements Tire {
  @override
  String spec() => '卡車輪胎：加強型胎側，重載';
}