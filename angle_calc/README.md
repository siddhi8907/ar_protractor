# angle_calc

A pure Dart mathematical utility package for calculating geometric angles between vectors and lines using 2D coordinate points. 

Because this package contains zero UI or framework dependencies, it is lightweight, lightning-fast, and can be used across Flutter apps, command-line interfaces (CLI), or server-side Dart backends.

---

## Features

* **4-Point Line Angle Calculation:** Computes the interior angle formed by two independent line segments (p2 --> p1 and p3 --> p4) in a 2D space.
* **Direct Vector Calculations:** Directly computes angles between raw geometric vectors using their x and y components.
* **Zero Dependencies:** Pure Dart implementation with no external package requirements or framework footprints.
* **Built-in Safety Guardrails:** Automatically handles edge cases like division-by-zero errors (stacked points) and clamps floating-point rounding errors to prevent execution crashes.

---

## Installation

Add this package to your `pubspec.yaml` file:

```yaml
dependencies:
  angle_calc:
    path: ../angle_calc