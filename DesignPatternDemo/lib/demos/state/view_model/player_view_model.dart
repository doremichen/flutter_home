///
/// player_view_model.dart
/// PlayerViewModel
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../state/model/log_event.dart';
import '../interface/state_engine.dart';
import '../pattern/classic_state_engine.dart';
import '../pattern/enum_state_engine.dart';
import '../pattern/sealed_state_engine.dart';

enum EngineType { classic, enumBased, sealed }

class PlayerViewModel extends ChangeNotifier {
  StateEngine? _engine;
  EngineType _selectedType = EngineType.classic;

  final List<LogEvent> _logs = [];
  String? lastToast;
  bool _auto = false;
  Timer? _timer;

  PlayerViewModel() {
    _switchEngine(EngineType.classic);
  }

  // getters
  List<LogEvent> get logs => _logs;
  bool get auto => _auto;
  EngineType get selectedType => _selectedType;
  String? get stateLabel => _engine?.current;

  void _switchEngine(EngineType type) {
    // stop auto
    _timer?.cancel();
    _auto = false;

    // dispose old engine
    _engine?.dispose();

    // create new engine and bind log to vm
    switch (type) {
      case EngineType.classic:
        _engine = ClassicStateEngine(_log);
        break;
      case EngineType.enumBased:
        _engine = EnumStateEngine(_log);
        break;
      case EngineType.sealed:
        _engine = SealedStateEngine(_log);
        break;
    }
    _selectedType = type;
    _log('切換 State Engine：${_engineName(type)}');
    lastToast = '切換 State Engine：${_engineName(type)}';
    notifyListeners();
  }

  void _log(String msg) {
    _logs.add(LogEvent(msg));
    notifyListeners();
  }

  String _engineName(EngineType type) => switch (type) {
    EngineType.classic => 'Classic',
    EngineType.enumBased => 'Enum',
    EngineType.sealed => 'Sealed',
  };

  // --- control ---
  void play() {
    _engine?.play();
    lastToast = 'Play';
    _log('Play');
    lastToast = 'Play';
    notifyListeners();
  }

  void pause() {
    _engine?.pause();
    lastToast = 'Pause';
    _log('Pause');
    lastToast = 'Pause';
    notifyListeners();
  }

  void stop() {
    _engine?.stop();
    lastToast = 'Stop';
    _log('Stop');
    lastToast = 'Stop';
    notifyListeners();
  }

  void reset() {
    _engine?.reset();
    lastToast = 'Reset';
    _log('Reset');
    lastToast = 'Reset';
    notifyListeners();
  }

  void selectEngine(EngineType type) {
    if (type == _selectedType) {
      return;
    }
    _switchEngine(type);
  }

  void clearLogs() {
    _logs.clear();
    lastToast = 'Logs cleared';
    _log('Logs cleared');
    notifyListeners();
  }

  void toggleAuto() {
    _auto = !_auto;
    _timer?.cancel();
    if (_auto) {
      final rnd = Random();
      const actions = ['play', 'pause', 'stop', 'reset'];
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final act = actions[rnd.nextInt(actions.length)];
        switch (act) {
          case 'play':
            play();
            break;
          case 'pause':
            pause();
            break;
          case 'stop':
            stop();
            break;
          case 'reset':
            reset();
            break;
        }
      });
    }
    lastToast = 'Auto: $_auto';
    notifyListeners();
  }

  // dispose
  @override
  void dispose() {
    _timer?.cancel();
    _engine?.dispose();
    super.dispose();
  }
}