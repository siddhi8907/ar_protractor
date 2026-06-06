import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/measurement_bloc.dart';
import '../bloc/measurement_event.dart';
import '../bloc/measurement_state.dart';
import '../widgets/measurement_painter.dart';

class MeasurementScreen extends StatelessWidget {
  final String imagePath;
  const MeasurementScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MeasurementBloc(),
      child: _MeasurementView(imagePath: imagePath),
    );
  }
}

class _MeasurementView extends StatelessWidget {
  final String imagePath;
  const _MeasurementView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Protractor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<MeasurementBloc>().add(const MeasurementReset()),
            tooltip: 'Reset',
          )
        ],
      ),
      body: Center(
        child: BlocBuilder<MeasurementBloc, MeasurementState>(
          builder: (context, state) {
            return GestureDetector(
              onTapDown: (details) {
                // Snapping logic — if 4th point is close to point[1], snap to it
                Offset tapped = details.localPosition;
                if (state.points.length == 3) {
                  if ((tapped - state.points[1]).distance <= 25.0) {
                    tapped = state.points[1];
                  }
                }
                context.read<MeasurementBloc>().add(PointAdded(tapped));
              },
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Image.file(File(imagePath), fit: BoxFit.contain),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: MeasurementPainter(
                          points: state.points, angle: state.angle),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
