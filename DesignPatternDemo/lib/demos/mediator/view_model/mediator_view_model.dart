///
/// mediator_view_model.dart
/// MediatorViewModel
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';

import '../model/subsystem.dart';
import '../pattern/concrete_meduator.dart';

class MediatorViewModel extends ChangeNotifier {
  // subsystem
  final Light light = Light();
  final Blinds blinds = Blinds();
  final Thermostat thermostat = Thermostat();
  final MotionSensor motionSensor = MotionSensor();
  final Speaker speaker = Speaker();

  // mediator
  late final ConcreteHomeMediator mediator;

  // UI state
  int ambient = 50; // brightness of ambient light
  SceneKind scene = SceneKind.focus;
  SceneKind get selectedScene => scene;



  // output and statistics
  final List<String> logs = [];
  String? lastToast;

  MediatorViewModel() {
    mediator = ConcreteHomeMediator(
      light: light,
      blinds: blinds,
      thermostat: thermostat,
      motionSensor: motionSensor,
      speaker: speaker,
      logWriter: (s) => logs.add(s),
    );
  }

  void setAmbient(int v) {
    ambient = v.clamp(0, 100);
    mediator.setAmbientLight(ambient);
    lastToast = 'Ambient=$ambient';
    notifyListeners();
  }

  void setTemperature(double t) {
    thermostat.setTemperature(t);
    lastToast = 'Temp=${t.toStringAsFixed(1)}°C';
    notifyListeners();
  }

  void setMotion(bool v) {
    motionSensor.setDetected(v);
    lastToast = v ? 'Motion: ON' : 'Motion: OFF';
    notifyListeners();
  }

  // --- scene ---
  void applyScene(SceneKind s) {
    mediator.applyScene(s);
    scene = s;
    lastToast = 'Scene: $s';
    notifyListeners();
  }

  // --- control ---
  void toggleLight() {
      if (light.on) {
        light.turnOff();
        lastToast = 'Light: OFF';
      } else {
        light.turnOn();
        lastToast = 'Light: ON';
      }
      notifyListeners();
  }

  void setLightBrightness(int v) {
    light.setBrightness(v);
    lastToast = 'Light: bright=$v';
    notifyListeners();
  }

  void clearLogs() {
    logs.clear();
    lastToast = 'Logs cleared';
    notifyListeners();
  }

}