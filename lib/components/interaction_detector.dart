import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/definitions/create_point.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/point_notifier.dart';
import 'package:timeline/providers/viewrange_notifier.dart';

///Widget that listens for user interaction with the screen
///
///The [InteractionDetector] widget listens for user touch/click events, and
///scroll/multi-touch events. It will then modify the given [ViewRangeNotifier]
///and [PointNotifier] providers to reflect the user's interaction with the
///screen based on the given [groupId] and [constraints]
///
///The space where detection occurs is determined by the given [constraints] and
///height
class TimelineGestures extends StatefulWidget {
  final String groupId;
  final BoxConstraints constraints;
  final double height;
  final ChangeNotifierProvider<PointNotifier> pointNotifier;
  final StateNotifierProvider<ViewRangeNotifier, ViewRange> viewRangeNotifier;
  final CreatePoint createPoint;
  const TimelineGestures(
      {super.key,
      required this.groupId,
      required this.constraints,
      required this.height,
      required this.viewRangeNotifier,
      required this.pointNotifier,
      required this.createPoint});

  @override
  State<TimelineGestures> createState() => _TimelineGesturesState();
}

class _TimelineGesturesState extends State<TimelineGestures> {
  TapDownDetails? _tapDownDetails;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      return interactionListner(context, ref);
    }));
  }

  ///the gesture detector that listens for dragging, double tapping, and multi-
  ///touch zooming
  Widget gestureDetector(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onHorizontalDragUpdate: (details) => drag(context, ref, details),
        onScaleUpdate: (details) => gestureZoom(context, ref, details),
        onDoubleTapDown: (details) => _tapDownDetails = details,
        onDoubleTap: () => createPoint(context, ref),
        child: Container(
            height: widget.height,
            width: widget.constraints.maxWidth,
            color: Colors.transparent));
  }

  ///listener that detects mouse scroll event
  Widget interactionListner(BuildContext context, WidgetRef ref) {
    return Listener(
        onPointerSignal: (event) => scrollZoom(context, ref, event),
        child: gestureDetector(context, ref));
  }

  ///createPoint creates a point using the [_tapDownDetails]
  ///
  ///If the [_tapDownDetails] is null, nothing happens
  void createPoint(BuildContext context, WidgetRef ref) {
    final details = _tapDownDetails;
    if (details != null) {
      final x = details.localPosition.dx;
      final range = ref.read(widget.viewRangeNotifier);
      final pos = relativePosition(x, range, widget.constraints);
      final point = widget.createPoint(pos, widget.groupId);
      if (point != null) {
        ref.read(widget.pointNotifier.notifier).add(point);
      }
    }
  }

  ///drag updates the view range based on the given drag details
  void drag(BuildContext context, WidgetRef ref, DragUpdateDetails details,
      [double scale = 0.1]) {
    final delta = details.delta.dx * scale;
    final range = ref.read(widget.viewRangeNotifier);
    final newStart = range.start - delta;
    final newEnd = range.end - delta;
    ref
        .read(widget.viewRangeNotifier.notifier)
        .set(ViewRange(start: newStart, end: newEnd));
  }

  ///gestureZoom is zooming when user uses multi-touch
  void gestureZoom(
      BuildContext context, WidgetRef ref, ScaleUpdateDetails details) {
    final zoomLevel = zoomingScaleFromScaleUpdateDetails(details);
    final position = details.focalPoint.dx;
    zoom(context, ref, zoomLevel, position);
  }

  ///scrollZoom is zooming when user uses mouse scroll
  void scrollZoom(
      BuildContext context, WidgetRef ref, PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final zoomLevel = zoomingScaleFromPointerScrollEvent(event);
    final position = event.position.dx;
    zoom(context, ref, zoomLevel, position);
  }

  ///zoom updates the view range based on given zoomLevel and position
  void zoom(
      BuildContext context, WidgetRef ref, double zoomLevel, double position) {
    final range = ref.read(widget.viewRangeNotifier);
    final pos = relativePosition(position, range, widget.constraints);
    final newRange = updateViewRange(range, zoomLevel, pos);
    ref.read(widget.viewRangeNotifier.notifier).set(newRange);
  }
}

///zoomingScaleFromScaleUpdateDetails is a function that returns the zooming
///scale from given [details]
double zoomingScaleFromScaleUpdateDetails(ScaleUpdateDetails details) {
  double raw = 0.0;
  if (details.scale > 1) {
    raw = 1.0;
  } else if (details.scale < 1) {
    raw = -1.0;
  }
  return zoomingScale(raw);
}

///zoomingScaleFromPointerScrollEvent is a function that returns the zooming
///scale from given [event]
double zoomingScaleFromPointerScrollEvent(PointerScrollEvent event) {
  final raw = event.scrollDelta.dy;
  return zoomingScale(raw);
}

///updateViewRange takes the [viewRange], [zoomScale], and [zoomPosition]
///and returns the updated view range.
ViewRange updateViewRange(
    ViewRange viewRange, double zoomScale, double zoomPosition) {
  final newStart = zoomPosition + (viewRange.start - zoomPosition) * zoomScale;
  final newEnd = zoomPosition + (viewRange.end - zoomPosition) * zoomScale;

  return viewRange.copyWith(start: newStart, end: newEnd);
}

///turns position of user interaction on screen to being relative to the
///view range instead of the screen
double relativePosition(
    double position, ViewRange range, BoxConstraints constraints) {
  final ratio = position / constraints.maxWidth;
  return range.start + range.range * ratio;
}

///zoomingScale transforms the given zoomLevel to a scale
double zoomingScale(double zoomLevel) {
  final scale = zoomLevel.sign;
  if (scale == 0) {
    return 0.0;
  }
  return scale > 0 ? 1 + scale / 5 : 1 / (1 - scale / 5);
}
