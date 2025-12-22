///
/// command.dart
/// CommandInvoker
///
/// Created by Adam Chen on 2025/12/22.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'command.dart';

class CommandInvoker {
  // _undoStack
  final List<Command> _undo_stack = [];
  // redoStack
  final List<Command> _redo_stack = [];

  // history
  final List<String> history = [];

  bool execute(Command cmd) {
    if (cmd.execute()) {
      _undo_stack.add(cmd);
      _redo_stack.clear();
      history.add('EXEC → ${cmd.label}');
    } else {
      history.add('FAILED → ${cmd.label}');
      return false;
    }
    return true;
  }

  bool undo() {
    if (_undo_stack.isEmpty) return false;
    final c = _undo_stack.removeLast();
    final ok = c.undo();
    if (ok) {
      _redo_stack.add(c);
      history.add('UNDO ← ${c.label}');
    } else {
      history.add('UNDO FAILED ← ${c.label}');
    }
    return ok;
  }

  bool redo() {
    if (_redo_stack.isEmpty) return false;
    final c = _redo_stack.removeLast();
    final ok = c.execute();
    if (ok) {
      _undo_stack
          .add(c);
      history.add('REDO → ${c.label}');
    } else {
      history.add('REDO FAILED → ${c.label}');
    }
    return ok;
  }

  void clearHistory() {
    history.clear();
  }

}