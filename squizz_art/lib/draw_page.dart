import 'package:flutter/material.dart';
import 'package:squizz_art/draw_canvas.dart';
import 'package:squizz_art/draw_toolbar.dart';
import 'package:squizz_art/drawing.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DrawPage extends HookWidget {
  const DrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<Drawing?> currDrawing = useState(null);
    ValueNotifier<List<Drawing>> drawings = useState([]);
    ValueNotifier<Color> color = useState(Colors.black);
    ValueNotifier<String> tool = useState("pencil");
    ValueNotifier<double> size = useState(10);
    GlobalKey gKey = GlobalKey();
    DrawCanvas canvas = DrawCanvas(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                currDrawing: currDrawing,
                drawings: drawings,
                color: color,
                tool: tool,
                size: size,
                gKey: gKey,
              );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Row(
          children: [
            Image(image: AssetImage("images/squizzart.png"), width: 125,),
          ],
        )
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([]),
            builder: (context, _) {
              return canvas;
            }
          ),
          Positioned(
            top: 10,
            child: DrawToolbar(
              color: color,
              tool: tool,
              size: size,
              canvas: canvas,
              gKey: gKey,
            ),
          )
        ],
      ),
    );
  }
}