// Copyright (c) 2025, Adam chen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Represents a single round in the game.
///
/// This class can hold details about a round, such as its number,
/// the players involved, scores, and any other relevant data.

enum RoundResult { early, success, late}

class Round {
  final int id;
  final DateTime? startAt;
  final DateTime? promptAt;
  final DateTime? tapAt;
  final int? reactionMs;
  final RoundResult? result;
  final int score;

  const Round({
    required this.id,
    required this.startAt,
    this.promptAt,
    this.tapAt,
    this.reactionMs,
    this.result,
    this.score = 0,
  });

  Round copyWith({
    DateTime? promptAt,
    DateTime? tapAt,
    int? reactionMs,
    RoundResult? result,
    int? score,
  }) {
    return Round(
        id: id,
        startAt: startAt,
        promptAt: promptAt ?? this.promptAt,
        tapAt: tapAt ?? this.tapAt,
        reactionMs: reactionMs ?? this.reactionMs,
        result: result ?? this.result,
        score: score ?? this.score,
    );
  }

  @override
  String toString() {
    return 'Round#$id result=$result reaction=${reactionMs ?? '-'}ms score=$score';
  }
}
