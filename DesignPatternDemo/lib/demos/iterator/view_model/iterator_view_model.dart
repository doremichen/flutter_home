///
/// iterator_demo.dart
/// IteratorViewModel
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';

import '../model/genre.dart';
import '../model/song.dart';
import '../pattern/iterator.dart';
import '../pattern/play_list_agrregate.dart';

enum IteratorKind {forward, reverse, filterGenre, step}

class IteratorViewModel extends ChangeNotifier {
  // build play list
  final PlaylistAggregate playList = PlaylistAggregate.buildSamplePlaylist();
  // MyIterator
  MyIterator<Song>? _iterator;

  // UI state
  IteratorKind _iteratorKind = IteratorKind.forward;
  IteratorKind get iteratorKind => _iteratorKind;
  Genre _filterGenre = Genre.rock;
  Genre get filterGenre => _filterGenre;
  int step = 2;

  // output and statistics
  final List<Song> yielded = [];
  int yieldedCount = 0;
  bool reachedEnd = false;

  // toast/log
  String? lastToast;
  List<String> logs = [];

  IteratorViewModel() {
    _rebuildIterator();
  }

  void _rebuildIterator() {
    switch (_iteratorKind) {
      case IteratorKind.forward:
        _iterator = playList.createForwardIterator();
        break;
      case IteratorKind.reverse:
        _iterator = playList.createReverseIterator();
        break;
      case IteratorKind.filterGenre:
        _iterator = playList.createGenreFilterIterator(_filterGenre);
        break;
      case IteratorKind.step:
        _iterator = playList.createStepIterator(step);
        break;
    }
    // reset output state
    yielded.clear();
    yieldedCount = 0;
    reachedEnd = false;
    _iterator!.reset();
    logs.add('[Iterator] rebuilt: $_iteratorKind');
    notifyListeners();
  }

  // UI set
  void selectKind(IteratorKind kind) {
    _iteratorKind = kind;
    _rebuildIterator();
  }

  void selectGenre(Genre genre) {
    _filterGenre = genre;
    if (_iteratorKind == IteratorKind.filterGenre) {
      _rebuildIterator();
    } else {
      notifyListeners();
    }
  }

  void setStep(int v) {
    step = v;
    if (_iteratorKind == IteratorKind.step) {
      _rebuildIterator();
    } else {
      notifyListeners();
    }
  }

  // --- operate ---
  void nextOne() {
    // is reach end?
    if (reachedEnd) {
      lastToast = 'Reached end';
      notifyListeners();
      return;
    }
    // move to next
    if (_iterator!.moveNext()) {
      final s = _iterator!.current;
      yielded.add(s);
      yieldedCount = yielded.length;
      lastToast = '-> ${s.title}';
      logs.add('[Next] ${s.toString()}');
    } else {
      reachedEnd = true;
      lastToast = 'Reached end';
      logs.add('[Next] Reached end');
    }
    notifyListeners();
  }

  void nextBatch(int n) {
    for (int i = 0; i < n; i++) {
      // is reach end?
      if (reachedEnd) {
        break;
      }
      final ok = _iterator!.moveNext();
      if (!ok) {
        reachedEnd = true;
        break;
      }
      final s = _iterator!.current;
      yielded.add(s);
      logs.add('[Batch] ${s.toString()}');
    }
    yieldedCount = yielded.length;
    lastToast = reachedEnd ? 'End' : 'Batch $n';
    notifyListeners();
  }

  void reset() {
    _iterator!.reset();
    yielded.clear();
    yieldedCount = 0;
    reachedEnd = false;
    lastToast = 'Reset';
    logs.add('[Reset]');
    notifyListeners();
  }

  void shufflePlaylist() {
    playList.shuffle();
    logs.add('[Playlist] shuffled.');
    _rebuildIterator();
  }

  void addSampleSong() {
    final s = Song(
      title: 'New Piece ${playList.songsLength + 1}',
      artist: 'Guest Artist',
      durationSec: 210,
      genre: Genre.values[playList.songsLength % Genre.values.length],
    );
    playList.add(s);
    logs.add('[Playlist] added: ${s.toString()}');
    _rebuildIterator();
  }

  void clearLogs() {
    logs.clear();
    lastToast = 'Logs cleared';
    notifyListeners();
  }
}