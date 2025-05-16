import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:squizz_art/drawing.dart';

class DrawCanvas extends StatefulWidget {
  final double height;
  final double width;
  final ValueNotifier<Drawing?> currDrawing;
  final ValueNotifier<List<Drawing>> drawings;
  final ValueNotifier<Color> color;
  final ValueNotifier<String> tool;
  final ValueNotifier<double> size;
  final GlobalKey gKey;

  const DrawCanvas({super.key, required this.height, required this.width, required this.currDrawing, required this.drawings, required this.color, required this.tool, required this.size, required this.gKey});

  @override
  State<DrawCanvas> createState() => _DrawCanvasState();
}

class _DrawCanvasState extends State<DrawCanvas> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.gKey,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Stack(
          children: [
            buildAll(),
            buildCurrent(context)
          ]
        ),
      )
    );
  }

  Widget buildAll() {
    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: CustomPaint(
          painter: DrawPainter(
            drawings: widget.drawings.value
          ),
        ),
      ),
    );
  }

  Widget buildCurrent(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        final render = context.findRenderObject() as RenderBox;
        final offset = render.globalToLocal(e.position);
        if (widget.tool.value == "pencil") {
          widget.currDrawing.value = Drawing(points: [offset], color: widget.color.value, size: widget.size.value);
        }
        if (widget.tool.value == "eraser") {
          widget.currDrawing.value = Drawing(points: [offset], color: Theme.of(context).canvasColor, size: widget.size.value);
        }
        if (widget.tool.value == "squizz") {
          widget.currDrawing.value = Drawing(points: [offset], color: widget.color.value, size: widget.size.value, tool: "squizz");
        }
      },
      onPointerMove: (e) {
        final render = context.findRenderObject() as RenderBox;
        final offset = render.globalToLocal(e.position);
        final points = List<Offset>.from(widget.currDrawing.value?.points ?? []);
        points.add(offset);
        if (widget.tool.value == "pencil") { 
          widget.currDrawing.value = Drawing(points: points, color: widget.color.value, size: widget.size.value, tool: "pencil");
        }
        if (widget.tool.value == "eraser") {
          widget.currDrawing.value = Drawing(points: points, color: Theme.of(context).canvasColor, size: widget.size.value);
        }
      },
      onPointerUp: (e) {
        widget.drawings.value = List<Drawing>.from(widget.drawings.value);
        widget.drawings.value.add(widget.currDrawing.value!);
      },
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: CustomPaint(
          painter: DrawPainter(
            drawings: widget.currDrawing.value == null ? [] : [widget.currDrawing.value!]
          ),
        ),
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  final List<Drawing> drawings;

  DrawPainter({required this.drawings});

  @override
  void paint(Canvas canvas, Size size) {
    for (Drawing drawing in drawings) {
      final points = drawing.points;
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length-1; i++) {
        final p1 = points[i];
        final p2 = points[i+1];
        path.quadraticBezierTo(p1.dx, p1.dy, (p1.dx+p2.dx)/2, (p1.dy+p2.dy)/2);
      }
      Paint paint = Paint();
      paint.color = drawing.color;
      paint.strokeWidth = drawing.size;
      paint.strokeCap = StrokeCap.round;
      paint.style = PaintingStyle.stroke;
      if (drawing.tool == "pencil") {
        canvas.drawPath(path, paint);
      }
      if (drawing.tool == "squizz") {
        ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(fontFamily: "ComicSans",fontSize: drawing.size,));
        pb.pushStyle(ui.TextStyle(color: drawing.color));
        pb.addText("Squizz");
        ui.Paragraph pg = pb.build();
        pg.layout(const ui.ParagraphConstraints(width: 1000));
        Offset center = ui.Offset(drawing.points.first.dx-drawing.size, drawing.points.first.dy-drawing.size);
        canvas.drawParagraph(pg, center);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}