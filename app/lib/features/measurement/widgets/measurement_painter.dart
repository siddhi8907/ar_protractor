import 'package:flutter/material.dart';

class MeasurementPainter extends CustomPainter {
  final List<Offset> points;
  final double? angle;

  MeasurementPainter({required this.points, this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final line1Paint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final line2Paint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (var point in points) {
      canvas.drawCircle(point, 6.0, dotPaint);
    }

    if (points.length >= 2) {
      canvas.drawLine(points[0], points[1], line1Paint);
    }

    if (points.length >= 4) {
      canvas.drawLine(points[2], points[3], line2Paint);

      if (angle != null) {
        _drawText(canvas, 'Angle: ${angle!.toStringAsFixed(2)}°', points[1]);
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset position) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, position + const Offset(0, 15));
  }

  @override
  bool shouldRepaint(covariant MeasurementPainter oldDelegate) {
    return oldDelegate.points.length != points.length ||
        oldDelegate.angle != angle;
  }
}
