import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ColorSelector extends HookWidget {
  final ValueNotifier<Color> color;

  const ColorSelector({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    List<Color> allColors = [...Colors.primaries, Colors.black, Colors.white];
    return Column(
      children: [
        Wrap(
          spacing: 3,
          runSpacing: 3,
          children: [
            for (Color c in allColors)
              GestureDetector(
                onTap: () => color.value = c,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: c,
                    border: Border.all(
                      color: color.value == c ? Colors.blue : Colors.grey,
                      width: 2
                    )
                  ),
                ),
              )
          ],
        )
      ],
    );
  }
}