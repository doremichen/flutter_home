///
/// parser.dart
/// Expr
/// NumberLiteral
/// VariableRef
/// UnaryExpr
/// BinaryExpr
/// FuncCall
/// Stmt
/// AssignStmt
/// ExprStmt
///
/// Created by Adam Chen on 2025/12/22
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'dart:math';

abstract class Expr {
  double eval(Map<String, double> env);
  String pretty();
}

// NumberLiteral
class NumberLiteral implements Expr {
  final double value;
  NumberLiteral(this.value);
  @override double eval(Map<String, double> env) => value;
  @override String pretty() => 'Number($value)';
}

// VariableRef
class VariableRef implements Expr {
  final String name;
  VariableRef(this.name);
  @override double eval(Map<String, double> env) {
    final v = env[name];
    if (v == null) throw StateError('Undefined variable "$name"');
    return v;
  }
  @override String pretty() => 'Var($name)';
}

// UnaryExpr
class UnaryExpr implements Expr {
  final String op; // '+' or '-'
  final Expr rhs;
  UnaryExpr(this.op, this.rhs);
  @override double eval(Map<String, double> env) {
    final v = rhs.eval(env);
    return op == '-' ? -v : v;
  }
  @override String pretty() => 'Unary("$op", ${rhs.pretty()})';
}

// BinaryExpr
class BinaryExpr implements Expr {
  final String op; // + - * /
  final Expr left;
  final Expr right;
  BinaryExpr(this.op, this.left, this.right);
  @override double eval(Map<String, double> env) {
    final a = left.eval(env), b = right.eval(env);
    switch (op) {
      case '+': return a + b;
      case '-': return a - b;
      case '*': return a * b;
      case '/': return a / b;
      default: throw StateError('Unknown op "$op"');
    }
  }
  @override String pretty() => 'Binary("$op", ${left.pretty()}, ${right.pretty()})';
}

// FuncCall
class FuncCall implements Expr {
  final String name;
  final List<Expr> args;
  FuncCall(this.name, this.args);
  @override double eval(Map<String, double> env) {
    final vals = args.map((e) => e.eval(env)).toList();
    switch (name) {
      case 'max': return vals.reduce(max);
      case 'min': return vals.reduce(min);
      case 'abs': return vals.isEmpty ? 0 : (vals.first).abs();
      default: throw StateError('Unknown function "$name"');
    }
  }
  @override String pretty() => 'Call($name, [${args.map((e)=>e.pretty()).join(', ')}])';
}

// --- statement ---
abstract class Stmt {
  void execute(Map<String, double> env);
  String pretty();
}

// AssignStmt
class AssignStmt implements Stmt {
  final String name;
  final Expr expr;
  AssignStmt(this.name, this.expr);
  @override void execute(Map<String, double> env) {
    env[name] = expr.eval(env);
  }
  @override String pretty() => 'Assign($name = ${expr.pretty()})';
}

// ExprStmt
class ExprStmt implements Stmt {
  final Expr expr;
  double? lastValue;
  ExprStmt(this.expr);
  @override void execute(Map<String, double> env) {
    lastValue = expr.eval(env);
  }
  @override String pretty() => 'Expr(${expr.pretty()})';
}