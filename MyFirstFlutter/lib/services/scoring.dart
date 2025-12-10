// Copyright (c) 2025, Adam Chen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Defines the strategy for calculating scores based on reaction time.
///
/// This abstract class serves as an interface for different scoring implementations.

// import model/round.dart
import '../model/round.dart';

abstract class ScoreStrategy {
  int calculateScore(Round r);
}

/// Basic strategy that assigns a score based on reaction time.
///
/// Early: 0
/// Success: max(10, 400 - reactionMs)
/// Late: 10

class NormalScoreStrategy implements ScoreStrategy {
  // maxBase 400
  static const maxBase = 400;
  @override
  int calculateScore(Round r) {
    if (r.result == RoundResult.early) {
      return 0;
    }
    if (r.result == RoundResult.success) {
      final ms = r.reactionMs ?? maxBase;
      final s = (maxBase - ms).clamp(10, maxBase);
      return s;
    }
    if (r.result == RoundResult.late) {
      return 10;
    }
    return 10;
  }

}
