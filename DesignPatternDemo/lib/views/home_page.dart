///
/// homepage.dart
/// DesignPatternDemo
///
/// Created by Adam Chen on 2025/12/10.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import '../data/patterns_data.dart';

class HomePage extends StatelessWidget {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design Patterns Practice'),),
      body: ListView.separated(
        itemCount: patterns.length,
        separatorBuilder: (_, _) => const Divider(height: 1,),
        itemBuilder: (context, index) {
           final pattern = patterns[index];
           return ListTile(
             title: Text(pattern.name),
             subtitle: Text(pattern.category),
             trailing: const Icon(Icons.arrow_forward_ios),
             onTap: () {

               final page = pattern.widget;
               if (page == null) {
                 const snackBar = SnackBar(
                     content: Text('This pattern has not been implemented yet.'));
                 // show unimplement toast
                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
                 return;
               }

               Navigator.push(context,
                   MaterialPageRoute(builder: (_) => page),);
             }
           );
        },

      )
    );
  }
  
}