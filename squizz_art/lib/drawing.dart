import 'package:flutter/material.dart';

class Drawing {
  final List<Offset> points;
  final Color color;
  final double size;
  final String tool;

  Drawing({required this.points, this.color = Colors.black, this.size = 10, this.tool = "pencil"});

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> pointsMap =
        points.map((offset) => {'dx': offset.dx, 'dy': offset.dy}).toList();
    return {
      'points': pointsMap,
      'color': color.value.toRadixString(16),
      'size': size,
      'tool': tool
    };
  }

  factory Drawing.fromJson(Map<String, dynamic> json) {
    List<Offset> points =
        (json['points'] as List).map((e) => Offset(double.parse(e['dx'].toString()), double.parse(e['dy'].toString()))).toList();
    return Drawing(
      points: points,
      color: Color(int.parse((json['color'] as String), radix: 16)),
      size: double.parse(json['size'].toString()),
      tool: "pencil" // change this
    );
  }
}