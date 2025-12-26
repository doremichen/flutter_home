///
/// sort_strategy.dart
/// SortResult
/// SortStrategy
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
class SortResult {
  // result after sorting
  final List<int> output;
  // log of sorting process
  final List<String> logs;

  SortResult(this.output, this.logs);
}

abstract class SortStrategy {
  String get name;
  SortResult sort(List<int> data);
}