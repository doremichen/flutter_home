///
/// bridge_view_model.dart
/// BridgeViewModel
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import '../model/device.dart';
import '../pattern/remote.dart';

enum RemoteKind { basic, advanced }

class BridgeViewModel extends ChangeNotifier {
  // Device factories
  final List<Device Function()> deviceFactories = [
        () => TvDevice(),
        () => RadioDevice(),
        () => SmartLightDevice(),
  ];

  final List<String> deviceLabels = ['電視', '收音機', '智慧燈'];

  int selectedDeviceIndex = 0;
  RemoteKind selectedRemote = RemoteKind.basic;

  late Device device;
  late RemoteControl remote;

  final List<String> logs = [];
  List<String> get logsText => logs;

  String? _lastToast;

  BridgeViewModel() {
    device = deviceFactories[selectedDeviceIndex]();
    remote = _buildRemote(device, selectedRemote);
  }

  RemoteControl _buildRemote(Device d, RemoteKind kind) {
    return (kind == RemoteKind.basic) ? RemoteControl(d) : AdvancedRemote(d);
  }

  String? takeLastToast() {
    final m = _lastToast;
    _lastToast = null;
    return m;
  }

  // select device
  void selectDevice(int index) {
      selectedDeviceIndex = index;
      final newDevice = deviceFactories[selectedDeviceIndex]();
      device = newDevice;
      remote = _buildRemote(device, selectedRemote);
      _log('選擇裝置：${deviceLabels[index]}');
      notifyListeners();
  }

  void selectRemote(RemoteKind kind) {
    selectedRemote = kind;
    remote = _buildRemote(device, kind);
    _log('選擇遙控器：${remote.label}');
    notifyListeners();
  }

  // ---- Operate ----
  void togglePower() {
    remote.togglePower();
    _log('togglePower → ${remote.currentStatus()}');
    _toastStatus();
    notifyListeners();
  }

  void volumeUp() {
    remote.volumeUp();
    _log('volumeUp → ${remote.currentStatus()}');
    _toastStatus();
    notifyListeners();
  }

  void volumeDown() {
    remote.volumeDown();
    _log('volumeDown → ${remote.currentStatus()}');
    _toastStatus();
    notifyListeners();
  }

  void next() {
    remote.next();
    _log('next → ${remote.currentStatus()}');
    _toastStatus();
    notifyListeners();
  }

  void prev() {
    remote.prev();
    _log('prev → ${remote.currentStatus()}');
    _toastStatus();
    notifyListeners();
  }

  void mute() {
    if (remote is AdvancedRemote) {
      (remote as AdvancedRemote).mute();
      _log('mute → ${remote.currentStatus()}');
      _toastStatus();
      notifyListeners();
    }
  }

  void randomize() {
    if (remote is AdvancedRemote) {
      (remote as AdvancedRemote).randomize();
      _log('randomize → ${remote.currentStatus()}');
      _toastStatus();
      notifyListeners();
    }
  }

  void macroPowerPlay() {
    if (remote is AdvancedRemote) {
      (remote as AdvancedRemote).macroPowerPlay();
      _log('macroPowerPlay → ${remote.currentStatus()}');
      _toastStatus();
      notifyListeners();
    }
  }

  void clearLogs() {
    logs.clear();
    _lastToast = 'Logs cleared';
    notifyListeners();
  }

  // --- helper ----------------------------
  void _log(String s) {
      logs.add(s);
  }

  void _toastStatus() {
    _lastToast = remote.currentStatus();
  }


}

