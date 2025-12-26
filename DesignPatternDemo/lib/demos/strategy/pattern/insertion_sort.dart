///
/// insertion_sort.dart
/// InsertionSort
///
/// Created by Adam Chen on 2025/12/26
/// Copyright © 2025 Abb company. All rights reserved
/// 
import '../interface/sort_strategy.dart';

class InsertionSort implements SortStrategy {
  @override
  String get name => 'InsertionSort';

  @override
  SortResult sort(List<int> data) {
    final logs = <String>[];
    final a = List<int>.from(data);
    logs.add('InsertionSort: input=$data');

    for (int i = 1; i < a.length; i++) {
      final key = a[i];
      int j = i - 1;
      logs.add('i=$i, key=$key');
      while (j >= 0 && a[j] > key) {
        logs.add('  move a[$j]=${a[j]} to a[${j + 1}]');
        a[j + 1] = a[j];
        j--;
      }
      a[j + 1] = key;
      logs.add('  insert key at ${j + 1} -> $a');
    }

    logs.add('InsertionSort: output=$a');
    return SortResult(a, logs);
  }

}