///
/// fs_node.dart
/// FsNode
///
/// Created by Adam Chen on 2025/12/16.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'dart:math';

abstract class FsNode {
   final String id;
   String name;

   FsNode({required this.name}): id = _genId();

   // node size
   int get size;
   // check if folder
   bool get isFolder;

   static String _genId() => '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 20)}';
}