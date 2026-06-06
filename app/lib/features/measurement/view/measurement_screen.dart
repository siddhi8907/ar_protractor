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

class _MeasurementView extends StatefulWidget {
  final String imagePath;
  const _MeasurementView({required this.imagePath});

  @override
  State<_MeasurementView> createState() => _MeasurementViewState();
}

class _MeasurementViewState extends State<_MeasurementView> {
  int? _activeGripIndex;
  bool _snappingEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Protractor'),
        actions: [
          IconButton(
            icon: Icon(_snappingEnabled ? Icons.grid_on : Icons.grid_off),
            onPressed: () =>
                setState(() => _snappingEnabled = !_snappingEnabled),
            tooltip: _snappingEnabled ? 'Snapping On' : 'Snapping Off',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _activeGripIndex = null;
              });
              context.read<MeasurementBloc>().add(const MeasurementReset());
            },
            tooltip: 'Reset',
          )
        ],
      ),
      body: Center(
        child: BlocBuilder<MeasurementBloc, MeasurementState>(
          builder: (context, state) {
            return GestureDetector(
              onPanStart: (details) {
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final Offset localPos =
                    renderBox.globalToLocal(details.globalPosition);

                // Check if the user's touch is near any existing point (45px radius target)
                for (int i = 0; i < state.points.length; i++) {
                  if ((localPos - state.points[i]).distance <= 45.0) {
                    setState(() {
                      _activeGripIndex = i;
                    });
                    break;
                  }
                }
              },

              onPanUpdate: (details) {
                if (_activeGripIndex != null) {
                  final RenderBox renderBox =
                      context.findRenderObject() as RenderBox;
                  final Offset localPos =
                      renderBox.globalToLocal(details.globalPosition);
                  context.read<MeasurementBloc>().add(
                        PointDragged(
                          index: _activeGripIndex!,
                          newPosition: localPos,
                          snapping: _snappingEnabled, // pass it here
                        ),
                      );
                }
              },
              // Lifted finger: release the active point grip
              onPanEnd: (_) {
                setState(() {
                  _activeGripIndex = null;
                });
              },

              //simple tapping for placing initial lines down
              onTapDown: (details) {
                Offset tapped = details.localPosition;

                // Simple placement snap: if placing point 4 (index 3), snap to vertex (index 1) if close
                if (state.points.length == 3) {
                  if ((tapped - state.points[1]).distance <= 45.0) {
                    tapped = state.points[1];
                  }
                }

                if (state.points.length < 4 && _activeGripIndex == null) {
                  context.read<MeasurementBloc>().add(PointAdded(tapped));
                }
              },
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Image.file(File(widget.imagePath), fit: BoxFit.contain),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: MeasurementPainter(
                        points: state.points,
                        angle: state.angle,
                      ),
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
