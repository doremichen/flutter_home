///
/// composite_node.dart
/// FileNode
/// FolderNode
///
/// Created by Adam Chen on 2025/12/16.
/// Copyright © 2025 Abb company. All rights reserved.
///
import '../model/fs_node.dart';

/// Leaf Node
class FileNode extends FsNode {
  int _size;
  FileNode({required String name, required int size})
      : _size = size, super(name: name);

  @override
  bool get isFolder => false;

  @override
  int get size => _size;
  void setSize(int size) => _size = size;

  @override
  String toString() => 'File("$name", size=$size)';
}

class FolderNode extends FsNode {

  final List<FsNode> children = [];

  FolderNode({required String name}) : super(name: name);

  @override
  bool get isFolder => true;

  @override
  int get size => children.fold<int>(0, (sum, n) => sum + n.size);

  void add(FsNode file) {
    children.add(file);
  }

  bool removeById(String nodeId) {
    // try to remove direct
    final index = children.indexWhere((n) => n.id == nodeId);
    if (index >= 0) {
      children.removeAt(index);
      return true;
    }

    // loop through children
    for (final child in children) {
      if (child is FolderNode) {
          if (child.removeById(nodeId)) {
            return true;
          }
      }
    }
    return false;
  }

  FsNode? findById(String id) {
    if (id == this.id) return this;
    for (final child in children) {
      if (child is FolderNode) {
        final found = child.findById(id);
        if (found != null) return found;
      } else if (child.id == id) {
        return child;
      }
    }
    return null;
  }

  @override
  String toString() => 'Folder("$name", size=$size)';
}