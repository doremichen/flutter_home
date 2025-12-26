///
/// quick_sort.dart
/// QuickSort
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/sort_strategy.dart';

class QuickSort implements SortStrategy {
  @override
  String get name => 'QuickSort';

  @override
  SortResult sort(List<int> data) {
    final logs = <String>[];
    final arr = List<int>.from(data);

    List<int> _quick(List<int> a, int depth) {
      if (a.length <= 1) return a;
      final pivot = a[a.length ~/ 2];
      final less = <int>[];
      final equal = <int>[];
      final greater = <int>[];

      for (final v in a) {
        if (v < pivot) {
          less.add(v);
        } else if (v > pivot) {
          greater.add(v);
        } else {
          equal.add(v);
        }
      }

      logs.add('${'  ' * depth}pivot=$pivot, less=$less, equal=$equal, greater=$greater');
      final left = _quick(less, depth + 1);
      final right = _quick(greater, depth + 1);
      final merged = [...left, ...equal, ...right];
      logs.add('${'  ' * depth}merged -> $merged');
      return merged;
    }

    final out = _quick(arr, 0);
    logs.insert(0, 'QuickSort: input=${data}');
    logs.add('QuickSort: output=$out');
    return SortResult(out, logs);
  }

}