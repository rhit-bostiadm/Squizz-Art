import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:squizz_art/drawing.dart';

class DrawCanvas extends StatefulWidget {
  final double height;
  final double width;
  final ValueNotifier<Drawing?> currDrawing;
  final ValueNotifier<List<Drawing>> drawings;
  final ValueNotifier<List<Drawing>> allCurrentDrawings;
  final ValueNotifier<Color> color;
  final ValueNotifier<String> tool;
  final ValueNotifier<double> size;
  final GlobalKey gKey;
  final IO.Socket socket;

  const DrawCanvas(
      {super.key,
      required this.height,
      required this.width,
      required this.currDrawing,
      required this.drawings,
      required this.allCurrentDrawings,
      required this.color,
      required this.tool,
      required this.size,
      required this.gKey,
      required this.socket});

  @override
  State<DrawCanvas> createState() => _DrawCanvasState();
}

class _DrawCanvasState extends State<DrawCanvas> {
  final currDrawingStream = StreamController<String>.broadcast();
  final drawingsStream = StreamController<String>.broadcast();
  bool retrievedInitialData = false;
  List<Drawing> localCurrentDrawings = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    retrievedInitialData = false;
  }

  @override
  void dispose() {
    widget.socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.socket.on('drawings', (data) => drawingsStream.sink.add(data));
    widget.socket.on('allDrawings', (data) => getAllDrawings(data));
    widget.socket.on('delete', (data) {
      widget.currDrawing.value = null;
      widget.drawings.value = [];
      widget.allCurrentDrawings.value = [];
    });
    widget.socket.on('connected', (data) {
      if (widget.drawings.value.isNotEmpty) {
        widget.socket.emit('allDrawings', jsonEncode(widget.drawings.value));
      }
    });

    widget.socket.onConnect((_) {
      retrievedInitialData = false;
      widget.socket.emit('connected');
    });

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
    return StreamBuilder(
      stream: drawingsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic>? drawingMap = jsonDecode(snapshot.data!);
          widget.drawings.value.add(Drawing.fromJson(drawingMap!));
        }

        return SizedBox(
            height: widget.height,
            width: widget.width,
            child: CustomPaint(
              painter: DrawPainter(
                drawings: widget.drawings.value
              ),
            ),
        );
      }
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
        if (widget.tool.value == "rectangle") {
          widget.currDrawing.value = Drawing(points: [offset], color: widget.color.value, size: widget.size.value, tool: "rectangle");
        }
        if (widget.tool.value == "circle") {
          widget.currDrawing.value = Drawing(points: [offset], color: widget.color.value, size: widget.size.value, tool: "circle");
        }
      },
      onPointerMove: (e) {
        final render = widget.gKey.currentContext?.findRenderObject() as RenderBox;
        final offset = render.globalToLocal(e.position);
        final points = List<Offset>.from(widget.currDrawing.value?.points ?? []);
        points.add(offset);

        if (widget.tool.value == "pencil") { 
          widget.currDrawing.value = Drawing(points: points, color: widget.color.value, size: widget.size.value, tool: "pencil");
        }
        if (widget.tool.value == "eraser") {
          widget.currDrawing.value = Drawing(points: points, color: Theme.of(context).canvasColor, size: widget.size.value);
        }
        if (widget.tool.value == "rectangle") {
          widget.currDrawing.value = Drawing(points: points, color: widget.color.value, size: widget.size.value, tool: "rectangle");
        }
        if (widget.tool.value == "circle") {
          widget.currDrawing.value = Drawing(points: points, color: widget.color.value, size: widget.size.value, tool: "circle");
        }
      },
      onPointerUp: (e) {
        widget.drawings.value = List<Drawing>.from(widget.drawings.value);
        widget.drawings.value.add(widget.currDrawing.value!);
        widget.socket.emit('drawings', jsonEncode(widget.currDrawing.value?.toJson()));
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

  void getAllDrawings(data) {
    if (retrievedInitialData) {
      return;
    }

    retrievedInitialData = true;
    List drawingsMap = List.empty(growable: true);
    drawingsMap = jsonDecode(data);
    widget.drawings.value = drawingsMap.map((json) => Drawing.fromJson(json as Map<String, dynamic>)).toList();
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
      if (drawing.tool == "circle") {
        Rect rect = Rect.fromPoints(points.first, points.last);
        canvas.drawOval(rect, paint);
      }
      if (drawing.tool == "rectangle") {
        Rect rect = Rect.fromPoints(points.first, points.last);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}