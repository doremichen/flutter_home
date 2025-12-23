///
/// iterator.dart
/// MyIterator
/// ForwardIterator
/// ReverseIterator
/// GenreFilterIterator
/// StepIterator
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/genre.dart';
import '../model/song.dart';

abstract class MyIterator<T> {
  // move to next and return true if there is next element
  bool moveNext();
  // return current element
  T get current;
  // reset iterator to initial state
  void reset();
}

// ForwardIterator
class ForwardIterator implements MyIterator<Song> {
  // list of songs
  final List<Song> _songs;
  // current index
  int _index = -1;
  // current song
  Song? _current;

  ForwardIterator(this._songs);

  @override
  get current {
    if (_current == null) {
      throw StateError('No current song');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    // check if there is next element
    if (_index + 1 >= _songs.length) {
      return false;
    }
    // move to next element
    _index++;
    _current = _songs[_index];
    return true;
  }

  @override
  void reset() {
    _index = -1;
    _current = null;
  }
}

// ReverseIterator
class ReverseIterator implements MyIterator<Song> {
  // list of song
  final List<Song> _songs;
  // current index
  int _index;
  // current song
  Song? _current;

  ReverseIterator(this._songs): _index = _songs.length;

  @override
  Song get current {
    if (_current == null) {
      throw StateError('No current song');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    // check if there is next element
    if (_index - 1 < 0) {
      return false;
    }
    // move to next element
    _index--;
    _current = _songs[_index];
    return true;
  }

  @override
  void reset() {
    _index = _songs.length;
    _current = null;
  }
}

// GenreFilterIterator by genre
class GenreFilterIterator implements MyIterator<Song> {
  // list of song
  final List<Song> _songs;
  // current index
  int _index = -1;
  // current song
  Song? _current;
  // genre to filter
  final Genre _genre;

  GenreFilterIterator(this._songs, this._genre);

  @override
  Song get current {
    if (_current == null) {
      throw StateError('No current song');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    // check if there is next element
    while (_index + 1 < _songs.length) {
      _index++;
      _current = _songs[_index];
      if (_current!.genre == _genre) {
        return true;
      }
    }
    return false;
  }

  @override
  void reset() {
    _index = _songs.length;
    _current = null;
  }

}

// StepIterator
class StepIterator implements MyIterator<Song> {
  // list of song
  final List<Song> _songs;
  // current index
  int _index = -1;
  // current song
  Song? _current;
  // step to move
  final int _step;

  StepIterator(this._songs, this._step);

  @override
  Song get current {
    if (_current == null) {
      throw StateError('No current song');
    }
    return _current!;
  }

  @override
  bool moveNext() {
    final nextIndex = _index + _step;
    // check if there is next element
    if (nextIndex >= _songs.length) {
      return false;
    }
    // move to next element
    _index = nextIndex;
    _current = _songs[_index];
    return true;
  }

  @override
  void reset() {
    _index = -1;
    _current = null;
  }

}