import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

class MeasurementState extends Equatable {
  final List<Offset> points;
  final double? angle;

  const MeasurementState({
    required this.points,
    this.angle,
  });

  factory MeasurementState.initial() {
    return const MeasurementState(
      points: [],
      angle: null,
    );
  }

  MeasurementState copyWith({
    List<Offset>? points,
    double? angle,
    bool resetAngle = false,
  }) {
    return MeasurementState(
      points: points ?? this.points,
      angle: resetAngle ? null : (angle ?? this.angle),
    );
  }

  @override
  List<Object?> get props => [points, angle];
}
