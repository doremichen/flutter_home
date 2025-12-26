///
/// observable_adapter
/// ObservableAdapter
///
/// Created by Adam Chen on 2025/12/24
/// Copyright © 2025 Abb company. All rights reserved
///
abstract class ObservableAdapter<T> {
  // observer data
  Stream<T> get stream;

  // send new event
  void add(T value);

  // clear
  void clear();

  // dispose
  void dispose();
}