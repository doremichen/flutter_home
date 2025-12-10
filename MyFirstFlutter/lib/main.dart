// Copyright (c) 2025, Adam chen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The main entry point for the Flutter application.
///
/// This file initializes the application and sets up the root widget.
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/repositories/score_repository.dart';
import 'package:my_first_flutter_app/services/scoring.dart';
import 'package:my_first_flutter_app/view_models/game_view_model.dart';
import 'package:my_first_flutter_app/views/game_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ReactionApp());
}

class ReactionApp extends StatelessWidget {

  const ReactionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ScoreRepository>(create: (_) => InMemoryScoreRepository()),
        Provider<ScoreStrategy>(create: (_) => NormalScoreStrategy()),
        ChangeNotifierProvider<GameViewModel>(
          create: (context) => GameViewModel(
            context.read<ScoreRepository>(),
            context.read<ScoreStrategy>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Reaction Time Game',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: const GamePage(),
      ),
    );
  }
  
}
