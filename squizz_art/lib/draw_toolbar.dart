import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DrawToolbar extends StatefulHookWidget {
  const DrawToolbar({super.key});

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
      child: const Column(
        children: [
          Text("Tools"),
          Padding(padding: EdgeInsets.all(10)),
          Text("Tools will be here soon. We need to decide what all we will have.", textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}