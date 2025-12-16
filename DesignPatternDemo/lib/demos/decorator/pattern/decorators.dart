///
/// decorator.dart
/// BeverageDecorator
/// MilkDecorator
/// MochaDecorator
/// WhipDecorator
/// SoyDecorator
/// SugarDecorator
///
///
/// Created by Adam Chen on 2025/12/16.
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../model/beverage.dart';

/// abstract decorators
abstract class BeverageDecorator implements Beverage {
    final Beverage baseBeverage;
    BeverageDecorator(this.baseBeverage);

    @override
    double cost() => baseBeverage.cost();

    @override
    String describe() => baseBeverage.describe();
}

/// Milk decorator
class MilkDecorator extends BeverageDecorator {

  MilkDecorator(super.baseBeverage);

  @override
  String get name => 'Milk';

  @override
  double cost() {
    return super.cost() + 10.0;
  }

  @override
  String describe() {
    return '${super.describe()} + $name';
  }

}

/// Mocha decorator
class MochaDecorator extends BeverageDecorator {
  MochaDecorator(super.baseBeverage);

  @override
  String get name => 'Mocha';

  @override
  double cost() {
    return super.cost() + 15.0;
  }

  @override
  String describe() {
    return '${super.describe()} + $name';
  }

}

// Whip decorator
class WhipDecorator extends BeverageDecorator {
  WhipDecorator(super.baseBeverage);

  @override
  String get name => 'Whip';

  @override
  double cost() {
    return super.cost() + 12.0;
  }

  @override
  String describe() {
    return '${super.describe()} + $name';
  }

}

// Soy decorator
class SoyDecorator extends BeverageDecorator {
  SoyDecorator(super.baseBeverage);

  @override
  String get name => 'Soy';

  @override
  double cost() {
    return super.cost() + 8.0;
  }

  @override
  String describe() {
    return '${super.describe()} + $name';
  }


}


// Sugar decorator
class SugarDecorator extends BeverageDecorator {
  SugarDecorator(super.baseBeverage);

  @override
  String get name => 'Sugar';


  @override
  double cost() {
    return super.cost() + 2.0;
  }

  @override
  String describe() {
    return '${super.describe()} + $name';
  }
}