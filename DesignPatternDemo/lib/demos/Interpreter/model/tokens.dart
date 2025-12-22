
///
/// tokens.dart
/// TokenType
/// Token
/// Tokenizer
///
/// Created by Adam Chen on 2025/12/22
/// Copyright © 2025 Abb company. All rights reserved.
///
enum TokenType {
  number,
  identifier,
  plus, minus, star, slash,
  lparen, rparen, comma, equals, semicolon,
  eof,
}

class Token {
  final TokenType type;
  final String lexeme;
  final int pos;
  Token(this.type, this.lexeme, this.pos);
  @override
  String toString() => '${type.name}("$lexeme",@$pos)';
}

class Tokenizer {
  final String src;
  int _i = 0;
  Tokenizer(this.src);

  List<Token> tokenize() {
    final out = <Token>[];
    while (!_isEnd) {
      final c = _peek;
      if (_isSpace(c)) { _advance(); continue; }
      if (_isDigit(c)) { out.add(_number()); continue; }
      if (_isAlpha(c)) { out.add(_identifier()); continue; }

      switch (c) {
        case '+': out.add(_simple(TokenType.plus)); break;
        case '-': out.add(_simple(TokenType.minus)); break;
        case '*': out.add(_simple(TokenType.star)); break;
        case '/': out.add(_simple(TokenType.slash)); break;
        case '(': out.add(_simple(TokenType.lparen)); break;
        case ')': out.add(_simple(TokenType.rparen)); break;
        case ',': out.add(_simple(TokenType.comma)); break;
        case '=': out.add(_simple(TokenType.equals)); break;
        case ';': out.add(_simple(TokenType.semicolon)); break;
        default:
          throw FormatException('Unknown char "$c" at $_i');
      }
    }
    out.add(Token(TokenType.eof, '', _i));
    return out;
  }

  bool get _isEnd => _i >= src.length;
  String get _peek => src[_i];
  String _advance() => src[_i++];

  bool _isSpace(String c) => c.trim().isEmpty;
  bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
  bool _isAlpha(String c) {
    final code = c.codeUnitAt(0);
    final isLetter = (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
    return isLetter || c == '_';
  }

  Token _simple(TokenType t) => Token(t, _advance(), _i - 1);

  Token _number() {
    final start = _i;
    while (!_isEnd && _isDigit(_peek)) {
      _advance();
    }
    if (!_isEnd && _peek == '.') {
      _advance();
      while (!_isEnd && _isDigit(_peek)) {
        _advance();
      }
    }
    final lex = src.substring(start, _i);
    return Token(TokenType.number, lex, start);
  }

  Token _identifier() {
    final start = _i;
    while (!_isEnd && (_isAlpha(_peek) || _isDigit(_peek))) {
      _advance();
    }
    final lex = src.substring(start, _i);
    return Token(TokenType.identifier, lex, start);
  }

}