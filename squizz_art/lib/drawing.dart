import 'package:flutter/material.dart';

class Drawing {
  final List<Offset> points;
  final Color color;
  final double size;
  final String tool;

  Drawing({required this.points, this.color = Colors.black, this.size = 10, this.tool = "pencil"});
}