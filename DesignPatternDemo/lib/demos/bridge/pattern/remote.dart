///
/// remote.dart
/// RemoteControl
/// AdvancedRemote
///
/// Created by Adam Chen on 2025/12/12
/// Copyright © 2025 Abb company. All rights reserved.
///



import '../model/device.dart';

/// Abstraction：Control
class RemoteControl {
  Device device;

  RemoteControl(this.device);

  void togglePower() {
    device.isOn ? device.disable() : device.enable();
  }

  void volumeUp() => device.volumeUp();

  void volumeDown() => device.volumeDown();

  void next() => device.next();

  void prev() => device.prev();

  String currentStatus() => device.status();

  String get label => 'Basic Remote';
}

/// Refined Abstraction：Advanced Remote Control
/// (including mute / random scene / one-click macro)
class AdvancedRemote extends RemoteControl {
  AdvancedRemote(super.device);

  void mute() => device.setVolume(0);

  /// For SmartLight, randomly switch scenes;
  /// for other devices, use next().
  void randomize({int time = 1}) {
    for (var i = 0; i < time; i++) {
      next();
    }
  }

  /// Macro: Power on → Adjust volume → Next
  void macroPowerPlay() {
    if (!device.isOn) device.enable();
    device.setVolume(50);
    device.next();
  }

  @override
  String get label => 'Advanced Remote';
}