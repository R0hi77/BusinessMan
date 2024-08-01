import 'package:flutter/material.dart';

class Circle {
  final double radius;
  final Color color;

  Circle({required this.radius, required this.color});
}

class CirclePainter extends CustomPainter {
  final Circle circle;

  CirclePainter({required this.circle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = circle.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), circle.radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CircleWidget extends StatelessWidget {
  final Circle circle;

  CircleWidget({required this.circle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(circle.radius * 2, circle.radius * 2),
      painter: CirclePainter(circle: circle),
    );
  }
}