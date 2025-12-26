///
/// enum_state_engine.dart
/// EnumStateEngine
///
/// Created by Adam Chen on 2025/12/25
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/state_engine.dart';

enum PlayerState { idle, playing, paused, stopped }

class EnumStateEngine implements StateEngine {
  PlayerState _state = PlayerState.idle;
  final void Function(String) _log;

  EnumStateEngine(this._log) {
    _log('初始化狀態：Idle');
  }

  @override
  String get current => switch (_state) {
    PlayerState.idle => 'IdleState',
    PlayerState.playing => 'PlayingState',
    PlayerState.paused => 'PausedState',
    PlayerState.stopped => 'StoppedState',
  };


  @override
  void dispose() {
    _state = PlayerState.idle;
    _log('dispose()');
  }

  @override
  void pause() {
    _log('pause()');
    switch (_state) {
      case PlayerState.idle:
        _log('無效操作：Idle 狀態不可 pause');
        break;
      case PlayerState.playing:
        _log('狀態：Playing');
        _state = PlayerState.paused;
        _log('狀態：Paused');
        break;
      case PlayerState.paused:
        _log('無效操作：Paused 狀態不可 pause');
        break;
      case PlayerState.stopped:
        _log('無效操作：Stopped 狀態不可 pause');
        break;
    }
  }

  @override
  void play() {
    _log('play()');
    switch (_state) {
      case PlayerState.idle:
        _log('狀態：Playing');
        _state = PlayerState.playing;
        break;
      case PlayerState.playing:
        _log('無效操作：Playing 狀態不可 play');
        break;
      case PlayerState.paused:
        _log('執行 play() -> 復播');
        _state = PlayerState.playing;
        break;
      case PlayerState.stopped:
        _log('執行 play() -> 重新播放');
        _state = PlayerState.playing;
        break;
    }
  }

  @override
  void reset() {
    _log('reset()');
    switch (_state) {
      case PlayerState.idle:
        _log('保持 Idle（reset 無狀態變更）');
        break;
      case PlayerState.playing:
        _log('執行 reset() -> 回到 Idle');
        _state = PlayerState.idle;
        _log('狀態：Idle');
        break;
      case PlayerState.paused:
        _log('執行 reset() -> 回到 Idle');
        _state = PlayerState.idle;
        _log('狀態：Idle');
        break;
      case PlayerState.stopped:
        _log('執行 reset() -> 回到 Idle');
        _state = PlayerState.idle;
        _log('狀態：Idle');
        break;
    }
  }

  @override
  void stop() {
    _log('stop()');
    switch (_state) {
      case PlayerState.idle:
        _log('無效操作：Idle 狀態不可 stop');
        break;
      case PlayerState.playing:
        _log('狀態：Stopped');
        _state = PlayerState.stopped;
        break;
      case PlayerState.paused:
        _log('狀態：Stopped');
        _state = PlayerState.stopped;
        break;
      case PlayerState.stopped:
        _log('無效操作：Stopped 狀態不可 stop');
        break;
    }
  }

}