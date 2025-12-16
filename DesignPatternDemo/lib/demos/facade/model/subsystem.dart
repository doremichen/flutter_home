///
/// subsystem.dart
/// SubSystem
/// Amplifier
/// Projector
/// TheaterLights
/// StreamingPlayer
///
/// Created by Adam Chen on 2025/12/16
/// Copyright © 2025 Abb company. All rights reserved.
///
abstract class SubSystem {
  void on();
  void off();
  String status();
}

//Amplifier
class Amplifier extends SubSystem {
  bool _on = false;
  int _volume = 20;
  String _input = 'HDMI-1';


  @override
  void off() => _on = false;


  @override
  void on() => _on = true;

  void setVolume(int volume) => _volume = volume;
  void setInput(String input) => _input = input;


  @override
  String status() => _on
      ? 'Amplifier ON | input=$_input | vol=$_volume'
      : 'Amplifier is off';

  // --- get ----
  bool get isOn => _on;
  int get volume => _volume;
  String get input => _input;

}

class Projector extends SubSystem {
  bool _on = false;
  String _mode = 'Cinema'; // Cinema / Game / Music

  @override
  void off() => _on = false;

  @override
  void on() => _on = true;
  void setMode(String mode) => _mode = mode;

  @override
  String status() => _on
      ? 'Projector ON | mode=$_mode'
      : 'Projector OFF';

  // === getter ===
  bool get isOn => _on;
  String get mode => _mode;

}

class TheaterLights extends SubSystem {
  bool _on = false;
  int _level = 80;  //0..100

  @override
  void off() => _on = false;


  @override
  void on() => _on = true;

  void dim(int level) {
    _on = true;
    _level = level.clamp(0, 100);
  }


  @override
  String status() => _on ? 'Lights ON | level=$_level' : 'Lights OFF';

  // --- getter ---
  bool get isOn => _on;
  int get level => _level;

}

class StreamingPlayer extends SubSystem {
  bool _on = false;
  String _title = '(idle)';
  bool _playing = false;

  static const String EMPTY_TITLE = '(idle)';


  @override
  void off() {
    _on = false;
    _playing = false;
    _title = EMPTY_TITLE;
  }

  void play(String title) {
    _on = true;
    _playing = true;
    _title = title;
  }

  void pause() => _playing = false;
  void resume() {
    //check
    if (!_on || _title.isEmpty) {
      return;
    }

    _playing = true;
  }


  @override
  void on() => _on = true;

  @override
  String status() {
    if (!_on) return 'Player OFF';
    final s = _playing ? 'PLAYING' : 'PAUSED';
    final t = _title.isEmpty ? EMPTY_TITLE : _title;
    return 'Player ON | $s | "$t"';
  }

  // --- getter ---
  bool get isOn => _on;
  String get title => _title;
  bool get isPlaying => _playing;

}