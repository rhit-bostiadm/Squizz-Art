import 'package:flutter/material.dart';
import 'package:squizz_art/draw_canvas.dart';
import 'package:squizz_art/draw_toolbar.dart';
import 'package:squizz_art/drawing.dart';
import 'package:squizz_art/server.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DrawPage extends HookWidget {
  const DrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    Server server = Server();
    server.setupServer();

    ValueNotifier<Drawing?> currDrawing = useState(null);
    ValueNotifier<List<Drawing>> drawings = useState([]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Row(
          children: [
            Image(image: AssetImage("squizzart.png"), width: 125,),
          ],
        )
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([]),
            builder: (context, _) {
              return DrawCanvas(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                currDrawing: currDrawing,
                drawings: drawings,
              );
            }
          ),
          const Positioned(
            top: 10,
            child: DrawToolbar(),
          )
        ],
      ),
    );
  }
}