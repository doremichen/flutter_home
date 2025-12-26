///
/// concrete_home_mediator.dart
/// ConcreteHomeMediator
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/subsystem.dart';

import '../interface/home_mediator.dart';

class ConcreteHomeMediator implements HomeMediator {
  // subsystem components
  final Light light;
  final Blinds blinds;
  final Thermostat thermostat;
  final MotionSensor motionSensor;
  final Speaker speaker;

  final void Function(String) logWriter;

  // reference
  int ambientLight = 50;
  SceneKind scene = SceneKind.focus;

  ConcreteHomeMediator({
    required this.light,
    required this.blinds,
    required this.thermostat,
    required this.motionSensor,
    required this.speaker,
    required this.logWriter,
  }) {
    // set mediator
    light.setMediator(this);
    blinds.setMediator(this);
    thermostat.setMediator(this);
    motionSensor.setMediator(this);
    speaker.setMediator(this);
  }

  void setAmbientLight(int v) {
    ambientLight = v.clamp(0, 100);
    logWriter('[Mediator] Ambient light: $ambientLight');
    // low brightness + move => auto on
    if (ambientLight < 20 && motionSensor.detected) {
      // check if light is off
      if (!light.on) {
        logWriter('[Rule] low ambient + motion → turn light ON (80)');
        light.turnOn();
        light.setBrightness(80);
      }
    }
    // high brightness => auto off
    if (ambientLight > 80 && light.on) {
      logWriter('[Rule] high ambient → turn light OFF');
      light.turnOff();
    }
  }

  @override
  void applyScene(SceneKind s) {
    logWriter('[Mediator] Apply scene: $s');
    scene = s;
    switch (s) {
      case SceneKind.movieNight:
        logWriter('[Scene] Movie Night');
        blinds.setLevel(100);      // full on
        light.turnOn();
        light.setBrightness(20);   // dark
        speaker.power(true);
        speaker.setMode('cinema');
        break;
      case SceneKind.wakeUp:
        logWriter('[Scene] Wake Up');
        blinds.setLevel(0);        // full off
        light.turnOn();
        light.setBrightness(80);
        speaker.power(true);
        speaker.setMode('news');
        break;
      case SceneKind.focus:
        logWriter('[Scene] Focus');
        blinds.setLevel(70);
        light.turnOn();
        light.setBrightness(60);
        speaker.power(true);
        speaker.setMode('focus');
        break;
    }
  }

  @override
  void notify(Component sender, String event) {
    // collection all event to dispatch
    logWriter('[Mediator] $event from ${sender.name}');

    switch (event) {
      case 'temperatureChanged':
        // to hot → blinds=80, lights=30
        // to cold → blinds=0 (open)
        if (thermostat.temperature >= 27) {
          logWriter('[Rule] hot → blinds=80, lights=30');
          blinds.setLevel(80);
          if (!light.on) light.turnOn();
          light.setBrightness(30);
        } else if (thermostat.temperature <= 20) {
          logWriter('[Rule] cold → blinds=0 (open)');
          blinds.setLevel(0);
        }
        break;

      case 'motionChanged':
        // move and dark → light=70
        if (motionSensor.detected && ambientLight < 30) {
          if (!light.on) {
            logWriter('[Rule] motion+dark → light ON (70)');
            light.turnOn();
            light.setBrightness(70);
          }
        }
        if (!motionSensor.detected && ambientLight > 60 && light.on) {
          logWriter('[Rule] idle+bright → light OFF');
          light.turnOff();
        }
        break;

      case 'brightnessChanged':
        // brightness is too bright → blinds=60
        if (light.on && light.brightness > 85 && ambientLight > 60) {
          logWriter('[Rule] too bright → blinds=60');
          blinds.setLevel(60);
        }
        break;

      case 'blindsLevelChanged':
        // blinds is closed → speaker focus mode ON
        if (blinds.level >= 95) {
          logWriter('[Rule] blinds closed → speaker focus mode ON');
          speaker.power(true);
          speaker.setMode('focus');
        }
        break;

      case 'speakerPower':
      case 'speakerMode':
      case 'lightOn':
      case 'lightOff':
        // do nothing and only log
        break;

      default:
        logWriter('[Mediator] unhandled event: $event');
    }
  }
}