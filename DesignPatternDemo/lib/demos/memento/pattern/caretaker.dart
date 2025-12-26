///
/// caretaker.dart
/// HistoryManager
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/text_document.dart';

class HistoryManager {
   final List<DocumentMemento> _undoStack = [];
   final List<DocumentMemento> _redoStack = [];
   final List<DocumentMemento> history = [];

   // save state to undo stack
   void checkpoint(DocumentMemento m) {
     _redoStack.clear();
     _undoStack.add(m);
     history.add(m);
   }

   // undo: return the previous memento in undo stack
   DocumentMemento? undo() {
     if (_undoStack.length <= 1) return null;
     final current = _undoStack.removeLast();
     _redoStack.add(current);
     return _undoStack.last;  // new current
   }

   // redo: return the next memento in redo stack
   DocumentMemento? redo() {
     if (_redoStack.isEmpty) return null;
     final next = _redoStack.removeLast();
     _undoStack.add(next);
     return next;  // new current
   }

   // get current memento
   DocumentMemento? get current => _undoStack.isEmpty ? null : _undoStack.last;

   void clear() {
     _undoStack.clear();
     _redoStack.clear();
     history.clear();
   }

   int get undoCount => _undoStack.length > 0 ? _undoStack.length - 1 : 0;
   int get redoCount => _redoStack.length;
}