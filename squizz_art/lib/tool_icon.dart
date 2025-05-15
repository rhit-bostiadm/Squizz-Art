import 'package:flutter/material.dart';

class ToolIcon extends StatelessWidget {
  final IconData? iconData;
  final bool active;
  final VoidCallback onTap;
  final Widget? squizz;

  const ToolIcon({super.key, this.iconData, required this.active, required this.onTap, this.squizz});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: active ? Colors.blue : Colors.grey,
            width: 3
          )
        ),
        child: iconData != null ? Icon(
          iconData,
          color: active ? Colors.blue : Colors.grey,
          size: 25,
        ) : squizz,
      ),
    );
  }
}