///
/// home_mediator.dart
/// HomeMediator
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/subsystem.dart';

abstract class HomeMediator {
  void notify(Component sender, String event);
  void applyScene(SceneKind scene);
}