import 'package:flutter/painting.dart';
import 'package:equatable/equatable.dart';

abstract class MeasurementEvent extends Equatable {
  const MeasurementEvent();
}

class PointAdded extends MeasurementEvent {
  final Offset point;
  const PointAdded(this.point);

  @override
  List<Object> get props => [point];
}

class MeasurementReset extends MeasurementEvent {
  const MeasurementReset();

  @override
  List<Object> get props => [];
}

class PointDragged extends MeasurementEvent {
  final int index;
  final Offset newPosition;

  const PointDragged({required this.index, required this.newPosition});

  @override
  List<Object?> get props => [index, newPosition];
}
