///
/// data.dart
/// Data
///
/// Created by Adam Chen on 2025/12/18
/// Copyright © 2025 Abb company. All rights reserved.
///
class Data {
  final String key;
  final String content;
  final DateTime at;
  final String source; // 'real' | 'cache' | 'forbidden'

  // constructor
  Data({required this.key,
    required this.content,
    required this.at,
    required this.source});

  @override
  String toString() => '[$key] $content | $source @ ${at.toIso8601String()}';
}