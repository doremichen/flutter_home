///
/// measurement.dart
/// Measurement
///
/// Created by Adam Chen on 2025/12/12.
/// Copyright © 2025 Abb company. All rights reserved.
///
class Measurement {
  final String kind;  // 'speed' / 'temperature'
  final double original_value;
  final double new_value;
  final String unit;  // 'km/h' / '°C'
  final DateTime at;

  Measurement({
    required this.kind,
    required this.original_value,
    required this.new_value,
    required this.unit,
    DateTime? date_time,
  }) : at = date_time ?? DateTime.now();

  @override
  String toString() => '$kind: ${original_value.toStringAsFixed(2)} -> ${new_value.toStringAsFixed(2)} $unit @ ${at.toIso8601String()}';

}