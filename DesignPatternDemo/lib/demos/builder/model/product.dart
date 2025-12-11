///
/// product.dart
/// Meal
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///

class Meal {
  String? main;
  String? side;
  String? drink;
  String? dessert;

  // toString
  @override
  String toString() {
    return 'Meal(main: $main, side: $side, drink: $drink, dessert: $dessert)';
  }

  // map<String, String?>
  Map<String, String?> toMap() => {
    '主餐': main,
    '配菜': side,
    '飲料': drink,
    '甜點': dessert,
  };

}
