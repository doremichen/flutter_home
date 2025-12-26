///
/// classic_state_engine.dart
/// ClassicStateEngine
/// IdleState
/// PlayingState
/// PausedState
/// StoppedState
///
/// Created by Adam Chen on 2025/12/25
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/state_engine.dart';

// PlayerStateBase
abstract class PlayerStateBase {
  String get name;

  void play(ClassicStateEngine ctx);
  void pause(ClassicStateEngine ctx);
  void stop(ClassicStateEngine ctx);
  void reset(ClassicStateEngine ctx);
}

class ClassicStateEngine extends StateEngine {

  PlayerStateBase _state = IdleState();
  final void Function(String) _log;

  ClassicStateEngine(this._log)  {
    _log('初始化狀態：Idle');
  }

  @override
  String get current => _state.name;

  @override
  void pause() => _state.pause(this);


  @override
  void play() => _state.play(this);


  @override
  void reset() => _state.reset(this);

  @override
  void stop() => _state.stop(this);

  @override
  void dispose() {
    _state = IdleState();
    _log('dispose()');
  }


  void changeState(PlayerStateBase state) {
    _log('changeState()');
    _state = state;
    _log('狀態：$current');
  }

  void log(String msg) => _log(msg);


}

// --- state ---
class IdleState implements PlayerStateBase {

  @override
  String get name => 'IdleState';

  @override
  void pause(ClassicStateEngine ctx) {
    ctx.log('無效操作：Idle 狀態不可 pause');
  }

  @override
  void play(ClassicStateEngine ctx) {
    ctx.log('狀態：Playing');
    ctx.changeState(PlayingState());
  }

  @override
  void reset(ClassicStateEngine ctx) {
    ctx.log('保持 Idle（reset 無狀態變更）');
  }

  @override
  void stop(ClassicStateEngine ctx) {
    ctx.log('無效操作：Idle 狀態不可 stop');
  }

}

class PlayingState implements PlayerStateBase {
  @override
  String get name => 'PlayingState';

  @override
  void pause(ClassicStateEngine ctx) {
    ctx.log('狀態：Paused');
    ctx.changeState(PausedState());
  }

  @override
  void play(ClassicStateEngine ctx) {
    ctx.log('無效操作：Playing 狀態不可 play');
  }

  @override
  void reset(ClassicStateEngine ctx) {
    ctx.log('執行 reset() -> 回到 Idle');
    ctx.changeState(IdleState());
  }

  @override
  void stop(ClassicStateEngine ctx) {
    ctx.log('狀態：Stopped');
    ctx.changeState(StoppedState());
  }
  
}

class PausedState implements PlayerStateBase {
  @override
  String get name => 'PausedState';

  @override
  void pause(ClassicStateEngine ctx) {
    ctx.log('無效操作：Paused 狀態不可 pause');
  }

  @override
  void play(ClassicStateEngine ctx) {
    ctx.log('執行 play() -> 復播');
    ctx.changeState(PlayingState());
  }

  @override
  void reset(ClassicStateEngine ctx) {
    ctx.log('執行 reset() -> 回到 Idle');
    ctx.changeState(IdleState());

  }

  @override
  void stop(ClassicStateEngine ctx) {
    ctx.log('狀態：Stopped');
    ctx.changeState(StoppedState());
  }
  
}

class StoppedState implements PlayerStateBase {
  @override
  String get name => 'StoppedState';

  @override
  void pause(ClassicStateEngine ctx) {
    ctx.log('無效操作：Stopped 狀態不可 pause');
  }

  @override
  void play(ClassicStateEngine ctx) {
    ctx.log('執行 play() -> 重新播放');
    ctx.changeState(PlayingState());
  }

  @override
  void reset(ClassicStateEngine ctx) {
    ctx.log('執行 reset() -> 回到 Idle');
    ctx.changeState(IdleState());
  }

  @override
  void stop(ClassicStateEngine ctx) {
    ctx.log('無效操作：Stopped 狀態不可 stop');
  }

}

