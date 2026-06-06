import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/painting.dart';
import 'measurement_event.dart';
import 'measurement_state.dart';

class MeasurementBloc extends Bloc<MeasurementEvent, MeasurementState> {
  MeasurementBloc() : super(MeasurementState.initial()) {
    on<PointAdded>(_onPointAdded);
    on<MeasurementReset>(_onMeasurementReset);
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
    final v1 = Offset(points[0].dx - points[1].dx, points[0].dy - points[1].dy);
    final v2 = Offset(points[2].dx - points[3].dx, points[2].dy - points[3].dy);

    final dot = v1.dx * v2.dx + v1.dy * v2.dy;
    final mag1 = sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
    final mag2 = sqrt(v2.dx * v2.dx + v2.dy * v2.dy);

    if (mag1 == 0 || mag2 == 0) return 0.0;

    return acos((dot / (mag1 * mag2)).clamp(-1.0, 1.0)) * (180.0 / pi);
  }
}
