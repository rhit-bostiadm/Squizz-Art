import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:squizz_art/color_selector.dart';
import 'package:squizz_art/tool_icon.dart';

class DrawToolbar extends StatefulHookWidget {
  final ValueNotifier<Color> color;
  final ValueNotifier<String> tool;
  final ValueNotifier<double> size;

  const DrawToolbar({super.key, required this.color, required this.tool, required this.size});

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
          const Padding(padding: EdgeInsets.all(5)),
          const Text("Brush/Eraser Size",style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ComicSans',fontSize: 20)),
          Slider(
            value: widget.size.value,
            min: 1,
            max: 100,
            onChanged: (s) {widget.size.value = s;})
        ],
      ),
    );
  }
}