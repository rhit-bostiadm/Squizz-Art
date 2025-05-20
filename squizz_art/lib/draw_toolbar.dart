import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:squizz_art/color_selector.dart';
import 'package:squizz_art/draw_canvas.dart';
import 'package:squizz_art/tool_icon.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:ui' as ui;

class DrawToolbar extends StatefulHookWidget {
  final ValueNotifier<Color> color;
  final ValueNotifier<String> tool;
  final ValueNotifier<double> size;
  final DrawCanvas canvas;
  final GlobalKey gKey;

  const DrawToolbar({super.key, required this.color, required this.tool, required this.size, required this.canvas, required this.gKey});

  @override
  State<StatefulWidget> createState() => _DrawToolbarState();
}

class _DrawToolbarState extends State<DrawToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 450,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 50),
        borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
      ),
      child: Column(
        children: [
          const Text("Tools",style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicSans',fontSize: 20)),
          const Padding(padding: EdgeInsets.all(5)),
          Wrap(
            spacing: 5,
            children: [
              ToolIcon(
                iconData: Icons.edit,
                active: widget.tool.value == "pencil",
                onTap: () => widget.tool.value = "pencil"
              ),
              ToolIcon(
                iconData: FontAwesomeIcons.eraser,
                active: widget.tool.value == "eraser",
                onTap: () => widget.tool.value = "eraser"
              ),
              ToolIcon(
                squizz: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Squizz",
                    style: TextStyle(
                      color: widget.tool.value == "squizz" ? Colors.blue : Colors.grey,
                      fontFamily: "ComicSans",
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  )
                ),
                active: widget.tool.value == "squizz",
                onTap: () => widget.tool.value = "squizz",
              )
            ],
          ),
          const Divider(),
          const Text("Color",style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicSans',fontSize: 20)),
          const Padding(padding: EdgeInsets.all(5)),
          ColorSelector(color: widget.color),
          const Divider(),
          const Text("Brush/Eraser Size",style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicSans',fontSize: 20)),
          const Padding(padding: EdgeInsets.all(5)),
          Slider(
            value: widget.size.value,
            min: 1,
            max: 100,
            onChanged: (s) {widget.size.value = s;}
          ),
          const Divider(),
          const Text("Options",style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicSans',fontSize: 20)),
          const Padding(padding: EdgeInsets.all(5)),
          Wrap(
            spacing: 5,
            children: [
              GestureDetector(
                onTap: () => saveFile(),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 3
                    )
                  ),
                  child: const Icon(
                    Icons.save,
                    color: Colors.blue,
                    size: 25,
                  )
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete drawing?"),
                        content: const Text("Are you sure you want to discard this drawing?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Cancel")
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              widget.canvas.socket.emit('delete');
                            },
                            child: const Text("Delete")
                          )
                        ],
                      );
                    }
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 3
                    )
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 25,
                  )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void saveFile() async {
    RenderRepaintBoundary bound = widget.gKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await bound.toImage();
    ByteData? bd = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? bytes = bd?.buffer.asUint8List();
    html.AnchorElement ae = html.AnchorElement();
    ae.href = '${Uri.dataFromBytes(bytes as List<int>,mimeType: 'image/png')}';
    ae.download = 'SquizzArt${DateTime.now()}.png';
    ae.style.display = 'none';
    ae.click();
  }
}