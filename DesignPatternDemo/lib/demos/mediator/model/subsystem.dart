///
/// subsystem.dart
/// Component
/// Light
/// Blinds
/// Thermostat
/// MotionSensor
/// Speaker
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/home_mediator.dart';

enum SceneKind { movieNight, wakeUp, focus }
abstract class Component {
  // home mediator
  late HomeMediator mediator;
  final String name;
  Component(this.name);

  void setMediator(HomeMediator m) => mediator = m;
}

// Light
class Light extends Component {
  bool on = false;
  int brightness = 60; // 0..100

  Light() : super('Light');

  // --- operator ---
  void turnOn() {
    on = true;
    mediator.notify(this, 'lightOn');
  }

  void turnOff() {
    on = false;
    mediator.notify(this, 'lightOff');
  }

  void setBrightness(int v) {
    brightness = v.clamp(0, 100);
    mediator.notify(this, 'brightnessChanged');
  }

  @override
  String toString() => on ? 'ON, bright=$brightness' : 'OFF';

}

// Blinds
class Blinds extends Component {
  int level = 50;

  bool open = false;

  Blinds(): super('Blinds');

  // --- operator ---;
  void setLevel(int v) {
    open = (v == 0)? false : true;
    level = v.clamp(0, 100);
    mediator.notify(this, 'blindsLevelChanged');
  }

  @override
  String toString() => 'level=$level';
}

// Thermostat
class Thermostat extends Component {
  double temperature = 24.0; // ℃
  Thermostat(): super('Thermostat');

  // --- operator ---
  void setTemperature(double t) {
    temperature = t;
    mediator.notify(this, 'temperatureChanged');
  }

  @override
  String toString() => '${temperature.toStringAsFixed(1)}°C';
}

// MotionSensor
class MotionSensor extends Component {
  bool detected = false;
  MotionSensor(): super('MotionSensor');

  // --- operator ---
  void setDetected(bool v) {
    detected = v;
    mediator.notify(this, 'motionChanged');
  }

  @override
  String toString() => detected ? 'MOTION' : 'IDLE';
}

// Speaker
class Speaker extends Component {
  bool on = false;
  String mode = 'idle';

  int volume = 100;

  Speaker(): super('Speaker');

  // --- operator ---
  void power(bool v) {
    on = v;
    mediator.notify(this, 'speakerPower');
  }

  void setMode(String m) {
    mode = m;
    mediator.notify(this, 'speakerMode');
  }

  @override
  String toString() => on ? 'ON ($mode)' : 'OFF';

}