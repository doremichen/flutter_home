
///
/// device.dart
/// Device
/// TvDevice
/// RadioDevice
/// SmartLightDevice
///
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///

/// Implementor：device interface
abstract class Device {
  String get name;

  // --- Power ---
  bool get isOn;
  void enable();
  void disable();

  // --- Volume (mapping to device's volume control) ---
  int get volume;           // 0..100
  void setVolume(int v);    // range
  void volumeUp() => setVolume(volume + 5);
  void volumeDown() => setVolume(volume - 5);

  // --- Channel / Station / Scene (abstraction of device's channel control)---
  void next();
  void prev();

  // --- used to ui status ---
  String status();
}

/// TV：channel 1..99，volume 0..100
class TvDevice extends Device {
  bool _on = false;
  int _volume = 20;
  int _channel = 1;

  @override
  String get name => 'TV';

  @override
  bool get isOn => _on;

  @override
  void enable() => _on = true;

  @override
  void disable() => _on = false;

  @override
  int get volume => _volume;

  @override
  void setVolume(int v) => _volume = v.clamp(0, 100);

  @override
  void next() => _channel = (_channel % 99) + 1;

  @override
  void prev() => _channel = (_channel <= 1) ? 99 : _channel - 1;

  @override
  String status() => _on
      ? 'TV ON | ch=$_channel | vol=$_volume'
      : 'TV OFF';
}

/// radio：frequency 88.0..108.0MHz Step 0.5，volume 0..100
class RadioDevice extends Device {
  bool _on = false;
  int _volume = 30;
  double _freq = 98.0;

  @override
  String get name => 'Radio';

  @override
  bool get isOn => _on;

  @override
  void enable() => _on = true;

  @override
  void disable() => _on = false;

  @override
  int get volume => _volume;

  @override
  void setVolume(int v) => _volume = v.clamp(0, 100);

  @override
  void next() {
    _freq += 0.5;
    if (_freq > 108.0) _freq = 88.0;
  }

  @override
  void prev() {
    _freq -= 0.5;
    if (_freq < 88.0) _freq = 108.0;
  }

  @override
  String status() => _on
      ? 'Radio ON | ${_freq.toStringAsFixed(1)}MHz | vol=$_volume'
      : 'Radio OFF';
}

/// Smart light：brightness 0..100 mapping volume；scene 0..5
class SmartLightDevice extends Device {
  bool _on = false;
  int _brightness = 60; // 映射 volume
  int _scene = 0;
  final List<String> _scenes = const ['Reading', 'Movie', 'Night', 'Focus', 'Party', 'Warm'];

  @override
  String get name => 'SmartLight';

  @override
  bool get isOn => _on;

  @override
  void enable() => _on = true;

  @override
  void disable() => _on = false;

  @override
  int get volume => _brightness;

  @override
  void setVolume(int v) => _brightness = v.clamp(0, 100);

  @override
  void next() => _scene = (_scene + 1) % _scenes.length;

  @override
  void prev() => _scene = (_scene - 1 + _scenes.length) % _scenes.length;

  @override
  String status() => _on
      ? 'Light ON | scene=${_scenes[_scene]} | bright=$_brightness'
      : 'Light OFF';
}