///
/// parser.dart
/// Parser
///
///
/// Created by Adam Chen on 2025/12/22
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'ast.dart';
import 'tokens.dart';

class Parser {
  final List<Token> tokens;
  int _i = 0;
  Parser(this.tokens);

  Token get _current => tokens[_i];
  bool get _isEnd => _current.type == TokenType.eof;
  Token _advance() {
    if (_isEnd) return tokens.last;
    return tokens[_i++];
  }
  bool _match(TokenType t) {
    if (_current.type == t)
    {
      _advance();
      return true;
    }
    return false;
  }
  Token _expect(TokenType t, String msg) {
    if (_current.type == t) return _advance();
    throw FormatException('$msg at ${_current.pos}');
  }

  List<Stmt> parseProgram() {
    final out = <Stmt>[];
    while (!_isEnd) {
      if (_current.type == TokenType.semicolon) {
        _advance();
        continue;
      }
      out.add(parseStatement());
      if (_match(TokenType.semicolon)) {
        /* optional separator */
      } else if (_isEnd) {
        break;
      } else {
        // if no eof or semicolon, error
        throw FormatException('Expect ";" after statement at ${_current.pos}');
      }
    }
    return out;
  }

  Stmt parseStatement() {
    // lookahead: identifier '=' → assignment
    if (_current.type == TokenType.identifier) {
      final save = _i;
      final id = _advance();
      if (_match(TokenType.equals)) {
        final expr = parseExpression();
        return AssignStmt(id.lexeme, expr);
      }
      // fallback: expression → statement
      _i = save;
    }
    final expr = parseExpression();
    return ExprStmt(expr);
  }

  Expr parseExpression() => _parseAdd();

  Expr _parseAdd() {
    var left = _parseMul();
    while (_current.type == TokenType.plus || _current.type == TokenType.minus) {
      final op = _advance().lexeme;
      final right = _parseMul();
      left = BinaryExpr(op, left, right);
    }
    return left;
  }

  Expr _parseMul() {
    var left = _parseUnary();
    while (_current.type == TokenType.star || _current.type == TokenType.slash) {
      final op = _advance().lexeme;
      final right = _parseUnary();
      left = BinaryExpr(op, left, right);
    }
    return left;
  }

  Expr _parseUnary() {
    if (_current.type == TokenType.plus || _current.type == TokenType.minus) {
      final op = _advance().lexeme;
      final rhs = _parseUnary();
      return UnaryExpr(op, rhs);
    }
    return _parsePrimary();
  }

  Expr _parsePrimary() {
    if (_current.type == TokenType.number) {
      final t = _advance();
      return NumberLiteral(double.parse(t.lexeme));
    }
    if (_current.type == TokenType.identifier) {
      final id = _advance();
      // func call?
      if (_match(TokenType.lparen)) {
        final args = <Expr>[];
        if (_current.type != TokenType.rparen) {
          args.add(parseExpression());
          while (_match(TokenType.comma)) {
            args.add(parseExpression());
          }
        }
        _expect(TokenType.rparen, 'Expect ")" after arguments');
        return FuncCall(id.lexeme, args);
      }
      return VariableRef(id.lexeme);
    }
    if (_match(TokenType.lparen)) {
      final inner = parseExpression();
      _expect(TokenType.rparen, 'Expect ")" after expression');
      return inner;
    }
    throw FormatException('Unexpected token ${_current} at ${_current.pos}');
  }
}