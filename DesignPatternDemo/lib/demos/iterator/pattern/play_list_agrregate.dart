///
/// play_list_aggregate.dart
/// PlaylistAggregate
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/genre.dart';
import '../model/song.dart';
import 'iterator.dart';

class PlaylistAggregate {
  // list of song
  final List<Song> _songs;

  PlaylistAggregate(this._songs);

  // get length of songs
  int get songsLength => _songs.length;

  // add
  void add(Song s) => _songs.add(s);

  // shuffle
  void shuffle() => _songs.shuffle();

  // createXXXIterator
  // MyIterator
  MyIterator<Song> createForwardIterator() => ForwardIterator(_songs);
  MyIterator<Song> createReverseIterator() => ReverseIterator(_songs);
  MyIterator<Song> createGenreFilterIterator(Genre genre) => GenreFilterIterator(_songs, genre);
  MyIterator<Song> createStepIterator(int step) => StepIterator(_songs, step);

  // buildSamplePlaylist
  static PlaylistAggregate buildSamplePlaylist() {
    final songs = <Song>[
      Song(title: 'Run Free', artist: 'Edge Band', durationSec: 215, genre: Genre.rock),
      Song(title: 'Sunrise', artist: 'Aurora', durationSec: 198, genre: Genre.pop),
      Song(title: 'Blue Note', artist: 'JJ Trio', durationSec: 252, genre: Genre.jazz),
      Song(title: 'Moonlight', artist: 'Pianissimo', durationSec: 305, genre: Genre.classical),
      Song(title: 'Thunder', artist: 'Edge Band', durationSec: 231, genre: Genre.rock),
      Song(title: 'Candy', artist: 'Aurora', durationSec: 180, genre: Genre.pop),
      Song(title: 'Autumn Leaves', artist: 'JJ Trio', durationSec: 264, genre: Genre.jazz),
      Song(title: 'Symphony No.5', artist: 'Pianissimo', durationSec: 420, genre: Genre.classical),
    ];
    return PlaylistAggregate(songs);
  }
}