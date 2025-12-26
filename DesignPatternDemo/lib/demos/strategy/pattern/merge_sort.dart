///
/// merge_sort.dart
/// MergeSort
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
///
import '../interface/sort_strategy.dart';

class MergeSort implements SortStrategy {
  @override
  String get name => 'MergeSort';

  @override
  SortResult sort(List<int> data) {
    final logs = <String>[];
    final arr = List<int>.from(data);

    List<int> _merge(List<int> left, List<int> right, int depth) {
      final res = <int>[];
      var i = 0, j = 0;
      logs.add('${'  ' * depth}merge: left=$left, right=$right');
      while (i < left.length && j < right.length) {
        if (left[i] <= right[j]) {
          res.add(left[i++]);
        } else {
          res.add(right[j++]);
        }
      }
      while (i < left.length) res.add(left[i++]);
      while (j < right.length) res.add(right[j++]);
      logs.add('${'  ' * depth}merged -> $res');
      return res;
    }

    List<int> _mergeSort(List<int> a, int depth) {
      if (a.length <= 1) return a;
      final mid = a.length ~/ 2;
      final left = _mergeSort(a.sublist(0, mid), depth + 1);
      final right = _mergeSort(a.sublist(mid), depth + 1);
      return _merge(left, right, depth);
    }

    final out = _mergeSort(arr, 0);
    logs.insert(0, 'MergeSort: input=${data}');
    logs.add('MergeSort: output=$out');
    return SortResult(out, logs);
  }

}