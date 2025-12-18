///
/// data.dart
/// Request
/// Response
///
/// Created by Adam Chen on 2025/12/10.
/// Copyright © 2025 Abb company. All rights reserved.
///
enum Category { billing, tech, sales }
enum Severity { low, medium, high }

// request
class Request {
  final Category category;
  final Severity severity;
  final String message;
  final bool hasAuth;

  Request({
    required this.category,
    required this.severity,
    required this.message,
    required this.hasAuth,
  });
}

// response
class Response {
  final String handleBy;
  final String status;
  final String note;

  Response({
    required this.handleBy,
    required this.status,
    required this.note,
  });

  @override
  String toString() => '$status by $handleBy — $note';
}