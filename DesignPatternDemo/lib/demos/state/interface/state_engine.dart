///
/// state_engine.dart
/// StateEngine
///
/// Created by Adam Chen on 2025/12/25
/// Copyright © 2025 Abb company. All rights reserved
///
abstract class StateEngine {
  String get current;

  void dispose() {
    // default: do nothing
  }

  // action
  void play();
  void pause();
  void stop();
  void reset();

}