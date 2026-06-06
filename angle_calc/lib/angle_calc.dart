library angle_calc;

import 'dart:math';

/// Calculates the angle in degrees between two vectors defined by 4 points.
/// Line 1: p2 → p1, Line 2: p3 → p4
double angleBetweenLines(
  double p1x,
  double p1y,
  double p2x,
  double p2y,
  double p3x,
  double p3y,
  double p4x,
  double p4y,
) {
  final v1x = p1x - p2x;
  final v1y = p1y - p2y;
  final v2x = p4x - p3x;
  final v2y = p4y - p3y;
  return angleBetweenVectors(v1x, v1y, v2x, v2y);
}

/// Calculates the angle in degrees between two vectors
double angleBetweenVectors(double v1x, double v1y, double v2x, double v2y) {
  final dot = v1x * v2x + v1y * v2y;
  final mag1 = sqrt(v1x * v1x + v1y * v1y);
  final mag2 = sqrt(v2x * v2x + v2y * v2y);
  if (mag1 == 0 || mag2 == 0) return 0.0;
  return acos((dot / (mag1 * mag2)).clamp(-1.0, 1.0)) * (180.0 / pi);
}

/// Converts degrees to radians
double degreesToRadians(double degrees) => degrees * (pi / 180.0);

/// Converts radians to degrees
double radiansToDegrees(double radians) => radians * (180.0 / pi);
