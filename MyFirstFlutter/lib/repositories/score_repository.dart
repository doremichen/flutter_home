// Copyright (c) 2025, Adam chen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// An abstract repository for managing game round scores.
///
/// This defines a contract for implementations that handle the persistence
/// of [Round] data, such as saving, retrieving, and clearing scores.
library;

// import model/round.dar
import '../model/round.dart';

abstract class ScoreRepository {
  Future<void> save(Round r);
  Future<List<Round>> getRounds();
  Future<void> clear();
}

///
/// An in-memory implementation of [ScoreRepository].
///
class InMemoryScoreRepository implements ScoreRepository {
  final List<Round> _rounds = [];

  @override
  Future<void> clear() async => _rounds.clear();

  @override
  Future<List<Round>> getRounds() async => List.unmodifiable(_rounds);

  @override
  Future<void> save(Round r) async {
    _rounds.add(r);
  }
  
}