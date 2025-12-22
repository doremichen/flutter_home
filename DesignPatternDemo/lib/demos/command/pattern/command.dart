///
/// command.dart
/// Command
/// AddCommand
/// SubtractCommand
/// MultiplyCommand
/// DivideCommand
/// SetValueCommand
/// MacroCommand
///
/// Created by Adam Chen on 2025/12/22.
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../model/calculator.dart';

abstract class Command {
  String get label;
  bool execute();
  bool undo();

  @override
  String toString() => label;
}

//Add command
class AddCommand implements Command {
  // input data
  final Calculator _cal;
  final double _value;

  AddCommand(this._cal, this._value);

  @override
  bool execute() {
    _cal.value += _value;
    return true;
  }

  @override
  String get label => 'Add $_value';

  @override
  bool undo() {
    _cal.value -= _value;
    return true;
  }
}

// subtract command
class SubtractCommand implements Command {
  // input data
  final Calculator _cal;
  final double _value;

  SubtractCommand(this._cal, this._value);

  @override
  bool execute() {
    _cal.value -= _value;
    return true;
  }

  @override
  String get label => 'Subtract $_value';

  @override
  bool undo() {
    _cal.value += _value;
    return true;
  }
}

// multiply command
class MultiplyCommand implements Command {
  // input data
  final Calculator _cal;
  final double _value;

  MultiplyCommand(this._cal, this._value);

  @override
  bool execute() {
    _cal.value *= _value;
    return true;
  }

  @override
  String get label => 'Multiply $_value';

  @override
  bool undo() {
    if (_value == 0) return false;
    _cal.value /= _value;
    return true;
  }
}

// divide command
class DivideCommand implements Command {
  final Calculator _cal;
  final double _value;

  DivideCommand(this._cal, this._value);

  @override
  bool execute() {
    if (_value == 0) return false;
    _cal.value /= _value;
    return true;
  }

  @override
  String get label => 'Divide $_value';

  @override
  bool undo() {
    _cal.value *= _value;
    return true;
  }
}

// set value command
class SetValueCommand implements Command {
  final Calculator _cal;
  final double newValue;
  double? oldValue;

  SetValueCommand(this._cal, this.newValue);


  @override
  bool execute() {
    oldValue = _cal.value;
    _cal.value = newValue;
    return true;
  }

  @override
  String get label => 'Set value = $newValue';

  @override
  bool undo() {
    if (oldValue == null) return false;
    _cal.value = oldValue!;
    return true;
  }
}

// macro command
class MacroCommand implements Command {
  final String name;
  final List<Command> _commands;

  MacroCommand(this.name, this._commands);

  @override
  bool execute() {
    for (final cmd in _commands) {
      if (!cmd.execute()) {
        // undo
        for (final r in _commands
            .takeWhile((x) => x != cmd)
            .toList()
            .reversed) {
          r.undo();
        }
        return false;
      }
    }
    return true;
  }

  @override
  String get label => 'Macro: $name';

  @override
  bool undo() {
    for (final cmd in _commands.reversed) {
      if (!cmd.undo()) {
        return false;
      }
    }
    return true;
  }

}

