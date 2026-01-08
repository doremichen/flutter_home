///
/// memento_view_model.dart
/// MementoViewModel
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/text_document.dart';
import 'package:flutter/material.dart';

import '../pattern/caretaker.dart';

class MementoViewModel extends ChangeNotifier {
  // Text document
  final TextDocument document = TextDocument(intial: '');
  // History manager
  final HistoryManager _historyManager = HistoryManager();

  // UI binding
  String stagedText = '';
  int stagedCaret = 0;
  String? lastToast;
  List<String> logs = [];
  List<DocumentMemento> get history => _historyManager.history;
  DocumentMemento? get current => _historyManager.current;

  MementoViewModel() {
    _checkpoint('Initial');
  }

  // --- Basic Operator ---
  void setStagedText(String t) {
    stagedText = t;
    // update stage caret
    if (stagedCaret > t.length) {
      stagedCaret = t.length;
    }

    notifyListeners();
  }

  void setStagedCaret(int pos) {
    stagedCaret = pos.clamp(0, document.content.length);
    notifyListeners();
  }

  void applySetContent() {
    // check point
    _checkpoint('Before: SetContent');
    // apply
    document.setContent(stagedText);
    document.moveCaret(stagedCaret);
    _checkpoint('After: SetContent');
    lastToast = 'Applied content';
    logs.add('[SetContent] len=${document.content.length}, caret=${document.caret}');
    notifyListeners();
  }

  void appendSample(String text) {
    // check point
    _checkpoint('Before: Append "$text"');
    // apply
    document.append(text);
    _checkpoint('After: Append');
    lastToast = 'Appended "$text"';
    logs.add('[Append] "$text" → caret=${document.caret}');
    notifyListeners();

  }

  void deleteLast(int count) {
    // check point
    _checkpoint('Before: Delete $count');
    // apply
    document.deleteLast(count);
    _checkpoint('After: Delete $count');
    lastToast = 'Deleted last $count characters';
    logs.add('[DeleteLast] $count → caret=${document.caret}');
    notifyListeners();
  }

  void moveCaret(int pos) {
    // check point
    _checkpoint('Before: MoveCaret $pos');
    // apply
    document.moveCaret(pos);
    _checkpoint('After: MoveCaret $pos');
    lastToast = 'Caret=${document.caret}';
    logs.add('[MoveCaret] → ${document.caret}');
    notifyListeners();
  }

  // --- undo/redo ----
  void undo() {
    final snap = _historyManager.undo();
    if (snap == null) {
      lastToast = 'No more undo';
      notifyListeners();
      return;
    }
    document.restore(snap);
    lastToast = 'Undo → ${snap.label}';
    logs.add('[Undo] → ${snap.toString()}');
    notifyListeners();
  }

  void redo() {
    final snap = _historyManager.redo();
    if (snap == null) {
      lastToast = 'No more redo';
      notifyListeners();
      return;
    }
    document.restore(snap);
    lastToast = 'Redo → ${snap.label}';
    logs.add('[Redo] → ${snap.toString()}');
    notifyListeners();
  }

  // --- save check point ---
  void saveCheckpoint(String label) {
    _checkpoint(label);
    lastToast = 'Checkpoint: $label';
    logs.add('[Checkpoint] $label');
    notifyListeners();
  }

  void clearHistory() {
    _historyManager.clear();
    lastToast = 'History cleared';
    logs.clear();
    notifyListeners();
  }

  void clearLogs() {
    logs.clear();
    notifyListeners();
  }

  void clearAll() {
    document.setContent('');
    document.moveCaret(0);
    _historyManager.clear();
    _checkpoint('Initial');
    stagedText = '';
    stagedCaret = 0;
    lastToast = 'History cleared';
    logs.clear();
    notifyListeners();
  }

  void _checkpoint(String s) {
    final snap = document.createMemento(s);
    _historyManager.checkpoint(snap);
  }

}