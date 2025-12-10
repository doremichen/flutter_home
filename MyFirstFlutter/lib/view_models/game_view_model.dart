// Copyright (c) 2025, Adam chen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// A view model that manages the state and logic of the game.
///
/// This class handles the game's flow, tracks the current phase (e.g., idle,
/// waiting, prompted, finished), and notifies listeners of any changes.
library;

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../model/round.dart';
import '../services/scoring.dart';
import '../repositories/score_repository.dart';


///
/// Represents the current phase of the game.
///
enum GamePhase { idle, waiting, prompted, finished }

class GameViewModel extends ChangeNotifier {
  final ScoreRepository _scoreRepository;
  final ScoreStrategy _scoreStrategy;
  final Random _random = new Random();

  // history
  List<Round> _history = [];
  List<Round> get history => _history;

  GamePhase _phase = GamePhase.idle;
  GamePhase get phase => _phase;

  Round? _currentRound;
  Round? get currentRound => _currentRound;

  int _nextId = 1;
  Timer? _timer;

  /// provide ui to show toast
  String? _lastToast;
  String? takeLastToast() {
    final t = _lastToast;
    _lastToast = null;
    return t;
  }

  GameViewModel(this._scoreRepository, this._scoreStrategy) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    _history = await _scoreRepository.getRounds();
    notifyListeners();
  }

  String get buttonLabel {
    switch (_phase) {
      case GamePhase.idle:
        return 'Start';
      case GamePhase.waiting:
        return 'Waiting...';
      case GamePhase.prompted:
        return 'Tap';
      case GamePhase.finished:
        return 'Restart';
    }
  }

  bool get canTab => _phase == GamePhase.prompted || _phase == GamePhase.waiting;

  Future<void> start() async {
    _cancelTimer();
    _currentRound = Round(id: _nextId++, startAt: DateTime.now());
    _phase = GamePhase.waiting;
    notifyListeners();

    final delayMs = 800 + _random.nextInt(1000); // 800–1800ms
    _timer = Timer(Duration(milliseconds: delayMs), () {
      _currentRound = _currentRound?.copyWith(promptAt: DateTime.now());
      _phase = GamePhase.prompted;
      notifyListeners();
    });
  }

  Future<void> onTab() async {
    if (!canTab) return;
    // now
    final now = DateTime.now();
    // wait for prompt
    if (_phase == GamePhase.waiting) {
      _currentRound = _currentRound?.copyWith(
          tapAt: now,
          reactionMs: 0,
          result: RoundResult.early,
      );
      await _finishRound();
      return;
    }

    if (_phase == GamePhase.prompted) {
      final ms = now.difference(_currentRound!.promptAt!).inMilliseconds;
      final result = ms <= 400 ? RoundResult.success : RoundResult.late;

      _currentRound = _currentRound?.copyWith(
          tapAt: now,
          reactionMs: ms,
          result: result,
      );
      await _finishRound();
    }
  }


  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _finishRound() async {
    _cancelTimer();
    final computedScore = _scoreStrategy.calculateScore(_currentRound!);
    _currentRound = _currentRound?.copyWith(score: computedScore);
    _phase = GamePhase.finished;
    await _scoreRepository.save(_currentRound!);

    // update history from repository
    await _loadHistory();
    _lastToast = switch (_currentRound!.result) {
      RoundResult.early => 'Too early! +0',
      RoundResult.success => 'Great! ${_currentRound!.reactionMs}ms, +${_currentRound!.score}',
      RoundResult.late => 'Late: ${_currentRound!.reactionMs}ms, +${_currentRound!.score}',
      _ => 'Round finished',
    };

    _currentRound = null;

    notifyListeners();
  }

  Future<void> clear() async {
    await _scoreRepository.clear();
    _history = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
