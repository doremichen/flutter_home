///
/// interpreter.dart
/// Interpreter
/// EvalResult
///
/// Created by Adam Chen on 2025/12/22
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../model/ast.dart';
import '../model/parser.dart';
import '../model/tokens.dart';

class EvalResult {
  final double? lastValue;
  final Map<String, double> env;
  final List<Token> tokens;
  final String astPretty;
  final List<String> errors;
  EvalResult({
    required this.lastValue,
    required this.env,
    required this.tokens,
    required this.astPretty,
    required this.errors,
  });
}

class Interpreter {
  EvalResult run(String program) {
    final errors = <String>[];
    try {
      final tokenizer = Tokenizer(program);
      final tokens = tokenizer.tokenize();

      final parser = Parser(tokens);
      final stmts = parser.parseProgram();

      final env = <String, double>{};
      double? last;
      final sb = StringBuffer();

      for (final s in stmts) {
        sb.writeln(s.pretty());
        s.execute(env);
        if (s is ExprStmt) last = s.lastValue;
      }

      return EvalResult(
        lastValue: last,
        env: Map<String, double>.from(env),
        tokens: tokens,
        astPretty: sb.toString(),
        errors: errors,
      );
    } catch (e, st) {
      errors.add(e.toString());
      errors.add(st.toString());
      return EvalResult(
        lastValue: null,
        env: const {},
        tokens: const [],
        astPretty: '',
        errors: errors,
      );
    }
  }
}