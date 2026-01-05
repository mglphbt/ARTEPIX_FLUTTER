import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class LiquidBlob extends StatelessWidget {
  final Color color;
  final double size;
  final double blur;

  const LiquidBlob({
    super.key,
    required this.color,
    required this.size,
    this.blur = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.3),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: blur,
            spreadRadius: 20,
          )
        ],
      ),
    );
  }
}
