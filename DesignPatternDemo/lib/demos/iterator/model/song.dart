///
/// song.dart
/// Song
///
/// Created by Adam Chen on 2025/12/22
/// Copyright © 2025 Abb company. All rights reserved
///
import 'genre.dart';

class Song {
  final String title;
  final String artist;
  final int durationSec;
  final Genre genre;

  Song({required this.title,
    required this.artist,
    required this.durationSec,
    required this.genre});

  @override
  String toString() =>
      '{title: $title, artist: $artist, durationSec: $durationSec, genre: ${genre.label}}';
}
