///
/// meal_builder.dart
/// MealBuilder
/// HealthyMealBuilder
/// FastFoodMealBuilder
/// VeganMealBuilder
///
/// Created by Adam Chen on 2025/12/11.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/cupertino.dart';

import '../model/product.dart';

abstract class MealBuilder {
  final List<String> logs = [];

  @protected
  void log(String msg) => logs.add(msg);

  /// reset new meal
  void reset();

  /// step
  void buildMain();
  void buildSide();
  void buildDrink();
  void buildDessert();

  /// get result
  Meal getResult();
}

class HealthyMealBuilder implements MealBuilder {
  Meal _meal = Meal();

  @override
  final List<String> logs = [];


  @override
  void buildDessert() {
    _meal.dessert = '優格';
    log('甜點 = 優格');
  }

  @override
  void buildDrink() {
    _meal.drink = '無糖綠茶';
    log('飲料 = 無糖綠茶');
  }

  @override
  void buildMain() {
    _meal.main = '烤雞胸';
    log('主餐 = 烤雞胸');
  }

  @override
  void buildSide() {
    _meal.side = '綜合沙拉';
    log('配菜 = 綜合沙拉');
  }

  @override
  Meal getResult() => _meal;

  @override
  void log(String msg) {
    logs.add('[Healthy] $msg');
  }

  @override
  void reset() {
    _meal = Meal();
    logs.clear();
    log('重置餐點');
  }
}

class FastFoodMealBuilder implements MealBuilder {
  Meal _meal = Meal();
  @override
  final List<String> logs = [];

  @override
  void log(String message) => logs.add('[FastFood] $message');

  @override
  void reset() {
    _meal = Meal();
    logs.clear();
    log('重置餐點');
  }

  @override
  void buildMain() {
    _meal.main = '雙層牛肉堡';
    log('主餐 = 雙層牛肉堡');
  }

  @override
  void buildSide() {
    _meal.side = '大薯';
    log('配菜 = 大薯');
  }

  @override
  void buildDrink() {
    _meal.drink = '可樂';
    log('飲料 = 可樂');
  }

  @override
  void buildDessert() {
    _meal.dessert = '冰淇淋';
    log('甜點 = 冰淇淋');
  }

  @override
  Meal getResult() => _meal;
}

class VeganMealBuilder implements MealBuilder {
  Meal _meal = Meal();
  @override
  final List<String> logs = [];

  @override
  void log(String message) => logs.add('[Vegan] $message');

  @override
  void reset() {
    _meal = Meal();
    logs.clear();
    log('重置餐點');
  }

  @override
  void buildMain() {
    _meal.main = '藜麥豆腐排';
    log('主餐 = 藜麥豆腐排');
  }

  @override
  void buildSide() {
    _meal.side = '烤時蔬';
    log('配菜 = 烤時蔬');
  }

  @override
  void buildDrink() {
    _meal.drink = '燕麥奶';
    log('飲料 = 燕麥奶');
  }

  @override
  void buildDessert() {
    _meal.dessert = '水果盅';
    log('甜點 = 水果盅');
  }

  @override
  Meal getResult() => _meal;
}