//
// design_pattern.dart
// DesignPatternDemo
//
// Created by Adam Chen on 2025/12/10.
// Copyright © 2025 Abb company. All rights reserved.
//
import 'package:flutter/material.dart';

class DesignPattern  {
  final String name;
  final String category;
  final String description;
  final Widget? widget;

  DesignPattern({
    required this.name,
    required this.category,
    required this.description,
    this.widget,
  });
}
