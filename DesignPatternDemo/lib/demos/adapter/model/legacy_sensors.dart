///
///
/// target.dart
/// MeasurementReader
///
/// created by Adam Chen on 2025/12/12
/// copyright © 2025 Abb company. All rights reserved.
///
///
import 'dart:math';

/// legacy speed sensor (return mph)
class LegacyMphSpeedSensor {
  final _rnd = Random();

  /// Simulated readings in miles per hour (mph) range
  /// from 10 to 90 mph.
  double readMph() => 10 + _rnd.nextDouble() * 80;
}

/// legacy temperature sensor (return fahrenheit)
class LegacyFahrenheitThermometer {
  final _rnd = Random();

  /// Simulated temperature readings, between 50 and 100°F.
  double readFahrenheit() => 50 + _rnd.nextDouble() * 50;
}