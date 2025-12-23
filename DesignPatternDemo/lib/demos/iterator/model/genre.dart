///
/// genre.dart
/// Genre
/// GenreLabel
///
/// Created by Adam Chen on 2025/12/22
/// Copyright © 2025 Abb company. All rights reserved.
///
enum Genre { rock, pop, jazz, classical }

extension GenreLabel on Genre {
  String get label => switch (this) {
    Genre.rock => 'Rock',
    Genre.pop => 'Pop',
    Genre.jazz => 'Jazz',
    Genre.classical => 'Classical',
  };
}
