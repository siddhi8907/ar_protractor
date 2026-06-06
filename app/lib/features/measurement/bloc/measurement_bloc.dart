import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/painting.dart';
import 'measurement_event.dart';
import 'measurement_state.dart';
import 'package:angle_calc/angle_calc.dart';

class MeasurementBloc extends Bloc<MeasurementEvent, MeasurementState> {
  MeasurementBloc() : super(MeasurementState.initial()) {
    on<PointAdded>(_onPointAdded);
    on<MeasurementReset>(_onMeasurementReset);
    on<PointDragged>(_onPointDragged);
  }

  void _onPointAdded(PointAdded event, Emitter<MeasurementState> emit) {
    if (state.points.length >= 4) return;

    final updatedPoints = List<Offset>.from(state.points)..add(event.point);

    if (updatedPoints.length < 4) {
      emit(state.copyWith(points: updatedPoints, resetAngle: true));
      return;
    }

    final calculatedAngle = _calculateAngle(updatedPoints);
    emit(state.copyWith(points: updatedPoints, angle: calculatedAngle));
  }

  void _onMeasurementReset(
      MeasurementReset event, Emitter<MeasurementState> emit) {
    emit(MeasurementState.initial());
  }

  double _calculateAngle(List<Offset> points) {
    return angleBetweenLines(
      points[0].dx,
      points[0].dy,
      points[1].dx,
      points[1].dy,
      points[3].dx,
      points[3].dy,
      points[2].dx,
      points[2].dy,
    );
    //note the placement is this because in the package the vecs are
    //p1->p0 & p2 -> p3 but here the second one is p3->p2 so I had to reverse
  }

//for snapping
  void _onPointDragged(PointDragged event, Emitter<MeasurementState> emit) {
    final updatedPoints = List<Offset>.from(state.points);
    Offset fingerPos = event.newPosition;

    for (int i = 0; i < updatedPoints.length; i++) {
      if (i == event.index) continue;

      final Offset otherPoint = updatedPoints[i];

      if ((fingerPos.dy - otherPoint.dy).abs() <= 20.0) {
        fingerPos = Offset(fingerPos.dx, otherPoint.dy);
      }

      if ((fingerPos.dx - otherPoint.dx).abs() <= 20.0) {
        fingerPos = Offset(otherPoint.dx, fingerPos.dy);
      }
    }

    updatedPoints[event.index] = fingerPos;

    double? updatedAngle;
    if (updatedPoints.length == 4) {
      updatedAngle = _calculateAngle(updatedPoints);
    }

    emit(state.copyWith(
      points: updatedPoints,
      angle: updatedAngle,
    ));
  }
}
