///
/// composite_view_model.dart
/// CompositeViewModel
///
/// Created by Adam Chen on 2025/12/1
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import '../model/fs_node.dart';
import '../pattern/composite_node.dart';


/// provide UI to show row information
class VisibleRow {
  final FsNode node;
  final int depth;

  VisibleRow({required this.node, required this.depth});
}


class CompositeViewModel extends ChangeNotifier {
  // root node
  final FolderNode root;

  // --- ui state ---
String selectedId = '';
final Set<String> expandedIds = {};
final List<String> logs = [];
String? _lastToast;

List<String> get logsText => logs;

// constructor
CompositeViewModel() : root = _buildSample() {
    selectedId = root.id;
    expandedIds.add(root.id);
}

  static FolderNode _buildSample() {
    final root = FolderNode(name: 'root');
    final docs = FolderNode(name: 'docs');
    final pics = FolderNode(name: 'pictures');
    final tmp = FolderNode(name: 'tmp');

    docs.add(FileNode(name: 'resume.pdf', size: 120_000));
    docs.add(FileNode(name: 'spec.md', size: 32_000));

    pics.add(FileNode(name: 'vacation.jpg', size: 2_400_000));
    pics.add(FileNode(name: 'avatar.png', size: 180_000));

    tmp.add(FileNode(name: 'draft.txt', size: 4_096));

    root
      ..add(docs)
      ..add(pics)
      ..add(tmp)
      ..add(FileNode(name: 'readme.txt', size: 2_048));
    return root;
  }

  // take last toast
  String? takeLastToast() {
    final m = _lastToast;
    _lastToast = null;
    return m;
  }

  // view row table
  List<VisibleRow> get VisibleRows {
    final acc = <VisibleRow>[];
    void walk(FolderNode folder, int depth) {
        acc.add(VisibleRow(node: folder, depth: depth));
        if (!expandedIds.contains(folder.id)) return;
        for (final child in folder.children) {
          if (child is FolderNode) {
            walk(child, depth + 1);
          } else {
            acc.add(VisibleRow(node: child, depth: depth + 1));
          }
        }
    }
    walk(root, 0);
    return acc;
  }

  // find node by id
  FsNode? findById(String id) => root.findById(id);

  // select node by id
  void select(String id) {
    if (selectedId == id) return;
    selectedId = id;
    final n = findById(id);
    _log('選取：${_label(n)}');
    _lastToast = 'Selected: ${_label(n)}';
    notifyListeners();
  }

  // expend/collapse
  void toggleExpand(String folderId) {
    if (expandedIds.contains(folderId)) {
      expandedIds.remove(folderId);
      _log('收合：${_label(findById(folderId))}');
    } else {
      expandedIds.add(folderId);
      _log('展開：${_label(findById(folderId))}');
    }
    notifyListeners();
  }

  void expandAll() {
    // collect all folders
    void collectFolders(FolderNode f) {
      expandedIds.add(f.id);
      for (final c in f.children) {
        if (c is FolderNode) collectFolders(c);
      }
    }
    collectFolders(root);
    _log('展開全部');
    notifyListeners();
  }

  void collapseAll() {
    expandedIds
      ..clear()
      ..add(root.id);
    _log('收合全部');
    notifyListeners();
  }

  // add file/folder
  void addFile({required String name, required int size}) {
    final target = _targetFolderForInsert();
    if (target == null) {
      _lastToast = '請選擇資料夾或 root 再新增檔案';
      notifyListeners();
      return;
    }
    // add file node
    target.add(FileNode(name: name, size: size));
    expandedIds.add(target.id);
    _log('新增檔案 "$name"（$size bytes）→ ${target.name}');
    _lastToast = 'Added file: $name';
    notifyListeners();
  }

  void addFolder({required String name}) {
    final target = _targetFolderForInsert();
    if (target == null) {
      _lastToast = '請選擇資料夾或 root 再新增資料夾';
      notifyListeners();
      return;
    }
    // folder
    final newFolder = FolderNode(name: name);
    target.add(newFolder);
    expandedIds.add(newFolder.id);
    _log('新增資料夾 "$name" → ${target.name}');
    _lastToast = 'Added folder: $name';
    notifyListeners();
  }

  // remove file or folder
  void removeSelected() {
    if (selectedId == root.id) {
      _lastToast = '無法刪除根資料夾';
      notifyListeners();
      return;
    }

    final ok = root.removeById(selectedId);
    if (ok) {
      _log('刪除：${_label(findById(selectedId))}');
      _lastToast = 'Deleted: ${_label(findById(selectedId))}';
      selectedId = root.id;
    } else {
      _lastToast = '無法刪除：${_label(findById(selectedId))}';
    }
    notifyListeners();
  }

  // rename file/folder
  void renameSelected(String newName) {
    final n = findById(selectedId);
    if (n == null) {
      _lastToast = '無法更名：${_label(n)}';
      notifyListeners();
      return;
    }
    final old = n.name;
    n.name = newName;
    _log('更名：$old → $newName');
    _lastToast = 'Renamed: $old → $newName';
    notifyListeners();
  }

  // --- get current node information ---
  String get selectedName => _label(findById(selectedId));
  int get selectedSize => findById(selectedId)?.size ?? 0;
  bool get isSelectedFolder => findById(selectedId)?.isFolder ?? false;

  void clearLogs() {
    logs.clear();
    _lastToast = 'Logs cleared';
    notifyListeners();
  }

  // --- helper ----
  void _log(String m) => logs.add(m);

  String _label(FsNode? n) =>
      n == null ? '(null)' : '${n.isFolder ? 'Folder' : 'File'}("${n.name}")';

  FolderNode? _targetFolderForInsert() {
     final n = findById(selectedId);
     if (n == null) return null;
     if (n is FolderNode) return n;
     // find parent folder
    FolderNode? parent;
    void findParent(FolderNode current) {
      for (final child in current.children) {
        if (child.id == selectedId) {
          parent = current;
          return;
        }
        if (child is FolderNode) {
          findParent(child);
        }
      }
    }
    findParent(root);
    return parent;
  }

}