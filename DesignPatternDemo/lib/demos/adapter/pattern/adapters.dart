///
/// adapter.dart
/// Adapter
///
/// created by Adam Chen on 2025/12/12.
/// copyright © 2025 Abb company. All rights reserved.
///
import '../model/legacy_sensors.dart';
import '../model/measurement.dart';
import '../model/target.dart';

/// speed adapter：mph -> km/h
class SpeedAdapter implements MeasurementReader {
  final LegacyMphSpeedSensor _sensor;

  SpeedAdapter(this._sensor);

  @override
  Measurement read() {
    final mph = _sensor.readMph();
    final kmh = mph * 1.60934; // convert value
    return Measurement(kind: 'speed', value: kmh, unit: 'km/h');
  }

  String get label => 'Speed (mph → km/h)';
  String get formula => 'km/h = mph × 1.60934';
}

/// temperature adapter：°F -> °C
class TemperatureAdapter implements MeasurementReader {
  final LegacyFahrenheitThermometer _thermo;

  TemperatureAdapter(this._thermo);

  @override
  Measurement read() {
    final f = _thermo.readFahrenheit();
    final c = (f - 32) * 5 / 9; // convert formula
    return Measurement(kind: 'temperature', value: c, unit: '°C');
  }

  String get label => 'Temperature (°F → °C)';
  String get formula => '°C = (°F − 32) × 5/9';
}