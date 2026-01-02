///
/// sealed_state_engine.dart
/// SealedStateEngine
///
/// Created by Adam Chen on 2025/12/25
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/state_engine.dart';

sealed class PlayerStateS {
  const PlayerStateS();
  String get name;
}
// --- State ---
class IdleStateS extends PlayerStateS {
  const IdleStateS();
  @override
  String get name => 'IdleState';
}

class PlayingStateS extends PlayerStateS {
  const PlayingStateS();

  @override
  String get name => 'PlayingState';
}

class PausedStateS extends PlayerStateS {
  const PausedStateS();

  @override
  String get name => 'PausedState';
}

class StoppedStateS extends PlayerStateS {
  const StoppedStateS();

  @override
  String get name => 'Stoppe';
}

// sealed state engine
class SealedStateEngine implements StateEngine {
  PlayerStateS _state = const IdleStateS();
  final void Function(String) _log;

  SealedStateEngine(this._log) {
    _log('初始化狀態：Idle');
  }

  @override
  String get current => _state.name;

  @override
  void dispose() {
    _state = const IdleStateS();
    _log('dispose()');
  }

  @override
  void pause() {
    _log('pause()');
    switch (_state) {
      case IdleStateS():
        _log('無效操作：Idle 狀態不可 pause');
        break;
      case PlayingStateS():
        _log('狀態：Playing');
        _state = const PausedStateS();
        _log('狀態：Paused');
        break;
      case PausedStateS():
        _log('無效操作：Paused 狀態不可 pause');
        break;
      case StoppedStateS():
        _log('無效操作：Stopped 狀態不可 pause');
        break;
    }
  }

  @override
  void play() {
    _log('play()');
    switch (_state) {
      case IdleStateS():
        _log('狀態：Playing');
        _state = const PlayingStateS();
        break;
      case PlayingStateS():
        _log('無效操作：Playing 狀態不可 play');
        break;
      case PausedStateS():
        _log('執行 play() -> 復播');
        _state = const PlayingStateS();
        break;
      case StoppedStateS():
        _log('執行 play() -> 重新播放');
        _state = const PlayingStateS();
        break;
    }
  }

  @override
  void reset() {
    _log('reset()');
    switch (_state) {
      case IdleStateS():
        _log('保持 Idle（reset 無狀態變更）');
        break;
      case PlayingStateS():
        _log('執行 reset() -> 回到 Idle');
        _state = const IdleStateS();
        _log('狀態：Idle');
        break;
      case PausedStateS():
        _log('執行 reset() -> 回到 Idle');
        _state = const IdleStateS();
        _log('狀態：Idle');
        break;
      case StoppedStateS():
        _log('執行 reset() -> 回到 Idle');
        _state = const IdleStateS();
        _log('狀態：Idle');
        break;
    }
  }

  @override
  void stop() {
    _log('stop()');
    switch (_state) {
      case IdleStateS():
        _log('無效操作：Idle 狀態不可 stop');
        break;
      case PlayingStateS():
        _log('狀態：Stopped');
        _state = const StoppedStateS();
        break;
      case PausedStateS():
        _log('狀態：Stopped');
        _state = const StoppedStateS();
        break;
      case StoppedStateS():
        _log('無效操作：Stopped 狀態不可 stop');
        break;
    }
  }

}