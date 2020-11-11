import 'dart:math' as math;

import 'package:flutter/material.dart';

class ShapePainter extends CustomPainter {
  ShapePainter({
    @required this.sides,
    @required this.shapeSize,
    @required this.color,
    this.shapeAngle = 0,
  });

  final int sides;
  final double shapeSize;
  final Color color;
  final double shapeAngle;

  @override
  void paint(Canvas canvas, Size size) {
    //make degree to radian
    final double sA = (shapeAngle * math.pi) / 180;

    var paint1 = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var paint2 = Paint()
      ..color = Colors.grey[700]
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();

    var angle = (math.pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    Offset startPoint =
        Offset(shapeSize * math.cos(sA), shapeSize * math.sin(sA));

    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    for (int i = 1; i <= sides; i++) {
      double x = shapeSize * math.cos(sA + angle * i) + center.dx;
      double y = shapeSize * math.sin(sA + angle * i) + center.dy;
      path.lineTo(x, y);
    }
    path.close();

    canvas.drawPath(path, paint1);
    canvas.drawPath(path, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
