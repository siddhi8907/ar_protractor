## ar_angle_painter

A lightweight, high-performance Flutter `CustomPainter` widget designed to visualize angle measurements between lines drawn over a canvas or image background. Perfect for AR apps, measurement utilities, and geometric drawing tools.


## Features

* **Visual Feedback:** Automatically draws distinct color-coded lines (Cyan for Line 1, Pink for Line 2) to clearly separate user inputs.
* **Point Markers:** Highlights tapped coordinates with clean, highly visible amber anchor dots.
* **Smart Text Positioning:** Renders a high-contrast, auto-formatted angle text badge (`Angle: X.XX°`) directly adjacent to your lines for maximum readability.
* **Performance Optimized:** Uses value-based equality checking in `shouldRepaint` to completely skip unnecessary rendering frames, keeping your canvas responsive.


## Installation

Add this local reference to your `pubspec.yaml` during development:

```yaml
dependencies:
  flutter:
    sdk: flutter
  ar_angle_painter:
    path: ../ar_angle_painter
```

## Usage

Simply pass your list of coordinate points and the calculated angle (provided by your state management layer like BLoC) straight into the painter widget inside a CustomPaint layout:

```dart
CustomPaint(
  painter: MeasurementPainter(
    points: myPoints, // List<Offset> of up to 4 tapped points
    angle: myAngle,   // double? calculated angle, null until 4 points placed
  ),
)
```