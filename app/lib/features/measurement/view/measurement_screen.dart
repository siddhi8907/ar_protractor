import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';

class MeasurementScreen extends StatefulWidget {
  final String imagePath;
  const MeasurementScreen({super.key, required this.imagePath});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  // FIX 1 & 5: Kept inside the State class to handle tracking updates safely
  final List<Offset> _points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Display'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                setState(() => _points.clear()), // Clear canvas utility
            tooltip: 'Reset Lines',
          )
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            // Cap at 4 items total to restrict drawing to exactly two lines
            if (_points.length >= 4) return;

            // FIX 1 & 2: Safely grow the list array and trigger a UI redraw frame
            setState(() {
              if (_points.length == 3 &&
                  (details.localPosition - _points[1]).distance <= 25.0) {
                _points.add(_points[1]);
              } else {
                _points.add(details.localPosition);
              }
            });
          },
          child: Stack(
            fit: StackFit.loose,
            children: [
              Image.file(
                File(widget.imagePath),
                fit: BoxFit.contain,
              ),
              Positioned.fill(
                child: CustomPaint(
                  // FIX 3: Used the required named parameter assignment format
                  painter: MeasurementPainter(points: List.from(_points)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
} // FIX 4: Correctly closed the State class block here

// FIX 4: Moved the CustomPainter class to the root level of your file
class MeasurementPainter extends CustomPainter {
  final List<Offset> points;

  MeasurementPainter({required this.points});

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

    // Draw active marker dots for every captured coordinate point
    for (var point in points) {
      canvas.drawCircle(point, 6.0, dotPaint);
    }

    // Connect Line 1 when points 1 and 2 exist
    if (points.length >= 2) {
      canvas.drawLine(points[0], points[1], line1Paint);
    }

    // Connect Line 2 when points 3 and 4 exist
    if (points.length >= 4) {
      canvas.drawLine(points[2], points[3], line2Paint);

      _drawText(canvas, 'Angle: ${angle(points).toStringAsFixed(2)} degrees',
          points[1]);
    }
  }

  void _drawText(Canvas canvas, String text, Offset position) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color.fromARGB(255, 93, 47, 219),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          backgroundColor: Colors.black87, // High contrast layout frame
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Shift text position slightly upward (-15 pixels on Y axis) so it floats above the line path
    Offset offsetPosition = position + const Offset(0, 15);
    textPainter.paint(canvas, offsetPosition);
  }

  double angle(List<Offset> points) {
    double num = (points[0].dx - points[1].dx) * (points[2].dx - points[3].dx) +
        (points[0].dy - points[1].dy) * (points[2].dy - points[3].dy);

    double den =
        ((points[0] - points[1]).distance) * ((points[2] - points[3]).distance);

    double radians = acos(num / den);
    double degrees = radians * (180 / pi);
    return degrees;
  }

  @override
  bool shouldRepaint(covariant MeasurementPainter oldDelegate) {
    // FIX 5: Compares different instances safely due to the List.from snapshot usage
    return oldDelegate.points.length != points.length;
  }
}
