import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/models/point/point.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/point_notifier.dart';
import 'package:timeline/providers/viewrange_notifier.dart';
import 'package:timeline/services/drag_service.dart';

///LineDragTarget is a StatefulWidget that scrolls line as user drags signpost
///
///LineDragTarget wraps the given child in a drag target that will listen for
///drag events made by signposts
///
///The drag events will be handled by the [dragHelper] function imported from the
///drag_service.dart file: as it listens to the position of the moving
///signpost to see if it is approaching the edge of the screen, and it will
///scroll the screen appropriately.
class LineDragTarget extends StatefulWidget {
  final Widget child;
  final BoxConstraints constraints;
  final StateNotifierProvider<ViewRangeNotifier, ViewRange> viewRangeNotifier;
  final String group;
  final ChangeNotifierProvider<PointNotifier> pointNotifier;
  const LineDragTarget(
      {super.key,
      required this.child,
      required this.constraints,
      required this.viewRangeNotifier,
      required this.group,
      required this.pointNotifier});

  @override
  State<LineDragTarget> createState() => _LineDragTargetState();
}

class _LineDragTargetState extends State<LineDragTarget> {
  double dragDirection = 0;
  double dragScale = 0;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return DragTarget(
        builder: (context, candidateData, rejectedData) => widget.child,
        onMove: (details) => onMove(details, ref),
        onLeave: (details) => onLeave(),
        onAcceptWithDetails: (details) => onAcceptWithDetails(details, ref),
      );
    });
  }

  ///onAcceptWithDetails will update the position of the point being dragged
  void onAcceptWithDetails(DragTargetDetails details, WidgetRef ref) {
    final point = details.data as Point;
    final pos = details.offset.dx;
    final range = ref.read(widget.viewRangeNotifier);
    final viewRangePos = relativePosition(pos, range, widget.constraints);
    onLeave();
    ref
        .read(widget.pointNotifier.notifier)
        .move(point, widget.group, viewRangePos);
  }

  ///dragScroll will scroll the screen based on the draggable's position as
  ///set by [dragDirection]
  void dragScroll(WidgetRef ref) {
    if (dragDirection != 0) {
      dragHelper(
          context: context,
          ref: ref,
          direction: dragDirection,
          viewRangeNotifier: widget.viewRangeNotifier,
          scale: dragScale);
    }
  }

  ///onMove the function that should be used as callback for the drag target
  ///
  ///It first checks to see if the Timer is null, and if it is, it will create
  ///a new Timer and periodically call [dragScroll] to scroll the screen. It
  ///also updates the [dragDirection] based on the position of the draggable
  void onMove(DragTargetDetails details, WidgetRef ref) {
    final pos = details.offset.dx;
    final scrollDetails = dragScrollDirection(pos, widget.constraints);
    setState(() {
      dragDirection = scrollDetails.scrollDir;
      dragScale = scrollDetails.scale;
      timer ??= Timer.periodic(Duration(milliseconds: 5), (timer) {
        dragScroll(ref);
      });
    });
  }

  ///onLeave will cancel the timer and set the [dragDirection] to 0
  void onLeave() {
    setState(() {
      dragDirection = 0;
      timer?.cancel();
      timer = null;
    });
  }
}

class ScrollDirAndScale {
  final double scrollDir;
  final double scale;
  ScrollDirAndScale(this.scrollDir, this.scale);
}

///dragScrollDelta takes in the current scroll position and the constraints,
///and returns the delta that the screen should be scrolled by
///
///It assumes that if the scroll position is within 10% of the right edge of
///the screen, then the screen should be scrolled to the right, and if the
///scroll position is within 10% of the left edge of the screen, then the
///screen should be scrolled to the left.
///
///The scale should increase as the user approaches the edge of the screen,
///up to a maximum of 0.004, and direction is either -1,0, or 1
ScrollDirAndScale dragScrollDirection(double pos, BoxConstraints constraints) {
  final width = constraints.maxWidth;
  final scrollDir = pos < width * 0.1
      ? 1.0
      : pos > width * 0.9
          ? -1.0
          : 0.0;
  final scale =
      scrollDir == 0 ? 0.0 : (pos - width * 0.5).abs() / (width * 0.5) * 0.004;
  return ScrollDirAndScale(scrollDir, scale);
}
