///
/// text_document.dart
/// TextDocument
/// DocumentMemento
///
/// Created by Adam Chen on 2025/12/23
/// Copyright © 2025 Abb company. All rights reserved
///
class DocumentMemento {
  final String content;
  final int caret;
  final DateTime at;
  final String label;


  const DocumentMemento({
    required this.content,
    required this.caret,
    required this.at,
    required this.label});

  @override
  String toString() => '[$label] len=${content.length}, caret=$caret @ ${at.toIso8601String()}';
}

class TextDocument {
  String _content;
  int _caret;

  TextDocument({String intial = '', int caret = 0})
  : _content = intial,
    _caret = caret;

  String get content => _content;
  int get caret => _caret;

  // create document memento
  DocumentMemento createMemento(String label) {
    return DocumentMemento(
      content: _content,
      caret: _caret,
      at: DateTime.now(),
      label: label,
    );
  }

  // restore document from memento
  void restore(DocumentMemento memento) {
    _content = memento.content;
    _caret = memento.caret.clamp(0, _content.length);
  }

  // --- basic operator ---
  void setContent(String s) {
    _content = s;
    _caret = _caret.clamp(0, _content.length);
  }

  void append(String text) {
    final left = _content.substring(0, _caret);
    final right = _content.substring(_caret);
    _content = '$left$text$right';
    _caret += text.length;
  }

  void deleteLast(int count) {
    if (_content.isEmpty || count <= 0) return;
    final cut = count.clamp(0, _caret);
    final left = _content.substring(0, _caret - cut);
    final right = _content.substring(_caret);
    _content = '$left$right';
    _caret -= cut;
  }

  void moveCaret(int pos) {
    _caret = pos.clamp(0, _content.length);
  }

  @override
  String toString() => 'TextDocument(len=${_content.length}, caret=$_caret)';


}