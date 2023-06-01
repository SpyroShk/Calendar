import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color bgColor;

  Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.bgColor = Colors.green,
  });
}
