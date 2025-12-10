
// Copyright (c) 2025, Adam chen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// A widget that displays the main game screen.
///
/// This page is the primary user interface for the reaction time game.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import '../view_models/game_view_model.dart';
import '../widgets/round_tile.dart';

class GamePage extends StatelessWidget {

  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
        return Consumer<GameViewModel>(
            builder: (context, model, child) {
              // Toast：透過 post-frame 檢查有沒有新訊息
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final msg = model.takeLastToast();
                if (msg != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
                  );
                }
              });
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Reaction Time Game'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Clear all History?'),
                                content: const Text('Are you sure?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Clear'),
                                  ),
                                ],
                              );
                            }
                        );

                        if (confirm == true) {
                          await model.clear();
                          const SnackBar(content: Text('已清除'), duration: Duration(seconds: 1));
                        }
                      },
                    )
                  ],
                ),
                body: Column(
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          switch(model.phase) {
                            case GamePhase.idle:
                              case GamePhase.finished:
                              model.start();
                              break;
                            case GamePhase.prompted:
                            case GamePhase.waiting:
                              model.onTab();
                              break;
                          }
                        },
                        child: Text(model.buttonLabel),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _phaseText(model.phase),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const Divider(height: 24),
                    Expanded(
                      child: ListView.separated(
                        itemCount: model.history.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final round = model.history.reversed.toList()[index]; // 最新在上
                          return RoundTile(round: round);
                        }
                      ),
                    ),
                  ],
                ),
              );
            }
        );
  }

  String _phaseText(GamePhase phase) {
    return switch (phase) {
      GamePhase.idle => '按下 Start Round 開始',
      GamePhase.waiting => '等待提示中…',
      GamePhase.prompted => '快按 Tap！',
      GamePhase.finished => '回合結束',
    };
  }

}
