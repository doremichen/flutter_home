// Copyright (c) 2025, Adam Chen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// A widget that displays a summary of a single game round.
///
/// This is typically used in a list to show historical round data,
/// such as the reaction time and score.
import 'package:flutter/material.dart';

import '../model/round.dart';

class RoundTile extends StatelessWidget {

  final Round round;

  const RoundTile({super.key, required this.round});

  Color _resultColor(RoundResult? result) {
    return switch (result) {
      RoundResult.early => Colors.green,
      RoundResult.success => Colors.orange,
      RoundResult.late => Colors.red,
      _ => Colors.grey,
    };
  }


  @override
  Widget build(BuildContext context) {
    final reactionText = round.reactionMs == null ? '-' : '${round.reactionMs}ms';
    final resultText =  switch (round.result) {
      RoundResult.early => 'early',
      RoundResult.success => 'success',
      RoundResult.late => 'late',
      _ => 'unknown',
    };

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _resultColor(round.result),
        child: Text('${round.score}'),
      ),
      title: Text('Result: $resultText', style: TextStyle(color: _resultColor(round.result))),
      subtitle: Text('Reaction: $reactionText'),
      trailing: Text('Score: ${round.score}', style: const TextStyle(fontWeight: FontWeight.bold)),
    );



  }

}
