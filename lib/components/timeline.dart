import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/components/action_bar.dart';
import 'package:timeline/components/background_line.dart';
import 'package:timeline/components/interaction_detector.dart';
import 'package:timeline/components/signpost.dart';
import 'package:timeline/definitions/create_point.dart';
import 'package:timeline/models/point/point.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/group_notifier.dart';
import 'package:timeline/providers/point_notifier.dart';
import 'package:timeline/providers/viewrange_notifier.dart';
import 'package:timeline/services/drag_service.dart';
import 'package:timeline/services/overlap_service.dart';

///A widget that displays zero or more points of interest on parallel lines
///
///The [Timeline] widget determines which points should be considered for
///rendering based on given [GroupNotifier] and [PointNotifier] providers,
///along with which points are visible based on the given [ViewRangeNotifier]
///provider. The [Timeline] widget also determines the position of each point
///on the screen based on the view range and the constraints of the screen
///as provided by a LayoutBuilder.
///
///[Timeline] will also ensure that its action bar size is at least the given
///[minActionBarHeight] and not greater than the given [maxActionBarHeight],
///and will attempt to keep the action bar's size a given fraction of the
///screen's height, as specified by [actionBarHeightFraction].
class Timeline extends ConsumerWidget {
  final double minActionBarHeight;
  final double maxActionBarHeight;
  final double actionBarHeightFraction;
  final double minLineHeight;
  final StateNotifierProvider<GroupNotifier, List<String>> groupNotifier;
  final ChangeNotifierProvider<PointNotifier> pointNotifier;
  final StateNotifierProvider<ViewRangeNotifier, ViewRange> viewRangeNotifier;
  final CreatePoint createPoint;
  final double signpostHeight = 10;
  final double backgroundBottomPadding = 10;
  const Timeline(
      {Key? key,
      required this.minActionBarHeight,
      required this.maxActionBarHeight,
      required this.actionBarHeightFraction,
      required this.groupNotifier,
      required this.viewRangeNotifier,
      required this.pointNotifier,
      required this.createPoint,
      required this.minLineHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [bar(constraints, ref), lines(constraints, ref)],
      );
    });
  }

  ///lines is the list of lines (and their points) to be rendered
  Widget lines(BoxConstraints constraints, WidgetRef ref) {
    final groups = ref.watch(groupNotifier);
    final points = ref.watch(pointNotifier);
    final viewRange = ref.watch(viewRangeNotifier);
    return Expanded(
        child: ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return line(
                  constraints: constraints,
                  ref: ref,
                  group: group,
                  points: points.points(group),
                  viewRange: viewRange,
                  context: context);
            }));
  }

  ///barHeight is the height of the action bar given the current constraints
  double barHeight(BoxConstraints constraints) {
    return min(
        max(constraints.maxHeight * actionBarHeightFraction,
            minActionBarHeight),
        maxActionBarHeight);
  }

  ///bar is the action bar widget
  Widget bar(BoxConstraints constraints, WidgetRef ref) {
    final height = barHeight(constraints);
    return SizedBox(
        height: height,
        child: ActionBar(
          height: height,
          groupNotifier: groupNotifier,
          viewRangeNotifier: viewRangeNotifier,
          pointNotifier: pointNotifier,
          ref: ref,
        ));
  }

  ///line is a single line of points
  ///
  ///Its contents depends on what group the line is supposed to be displaying,
  ///along with the points that are associated with that group
  ///and the current viewing range.
  ///
  ///These values are provided as parameters to the [line] function.
  Widget line(
      {required BoxConstraints constraints,
      required WidgetRef ref,
      required String group,
      required List<Point> points,
      required ViewRange viewRange,
      required BuildContext context}) {
    final visiblePoints = visible(points, viewRange);
    final service = overlapService(visiblePoints, constraints, viewRange,
        signpostHeight, backgroundBottomPadding);
    final lineHeight = max(service.height, minLineHeight);
    final positioned = signposts(visiblePoints, service, constraints, viewRange,
        lineHeight, context, backgroundBottomPadding, signpostHeight);
    final indicator = groupIndicator(group, lineHeight);
    final interactionDetector = TimelineGestures(
        groupId: group,
        constraints: constraints,
        height: lineHeight,
        viewRangeNotifier: viewRangeNotifier,
        pointNotifier: pointNotifier,
        createPoint: createPoint);
    final background =
        backgroundLine(constraints, 15, lineHeight, backgroundBottomPadding);
    final renderStack = Stack(
      children: [interactionDetector, background, ...positioned, indicator],
    );
    final target = lineDragTarget(
        child: renderStack,
        constraints: constraints,
        context: context,
        ref: ref,
        group: group,
        range: viewRange);
    return SizedBox(
      height: lineHeight,
      width: constraints.maxWidth,
      child: target,
    );
  }

  ///lineDragTarget wraps the given child in a drag target that will listen for
  ///drag events made by signposts
  ///
  ///The drag events will be handled by the [dragHelper] function imported from the
  ///drag_service.dart file: as it listens to the position of the moving
  ///signpost to see if it is approaching the edge of the screen, and it will
  ///scroll the screen appropriately.
  ///
  ///For example, if the screen's width is 1000, and the signpost is currently
  ///being dragged at position 950 towards the right, then the screen will be
  ///scrolled with delta of -0.08, and as the signpost moves ever closer, the
  ///delta will approach -0.5 (the maximum delta allowed).
  Widget lineDragTarget(
      {required Widget child,
      required BoxConstraints constraints,
      required BuildContext context,
      required WidgetRef ref,
      required String group,
      required ViewRange range}) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) => child,
      onMove: (details) {
        final pos = details.offset.dx;
        final delta = dragScrollDelta(pos, constraints);
        dragHelper(
            context: context,
            ref: ref,
            direction: delta,
            viewRangeNotifier: viewRangeNotifier);
      },
      onAcceptWithDetails: (details) {
        final point = details.data as Point;
        final pos = details.offset.dx;
        final viewRangePos = relativePosition(pos, range, constraints);
        ref.read(pointNotifier.notifier).move(point, group, viewRangePos);
      },
    );
  }
}

///dragScrollDelta takes in the current scroll position and the constraints,
///and returns the delta that the screen should be scrolled by
///
///It assumes that if the scroll position is within 10% of the right edge of
///the screen, then the screen should be scrolled to the right, and if the
///scroll position is within 10% of the left edge of the screen, then the
///screen should be scrolled to the left.
///
///As the postion approaches the edge of the screen, the delta will approach
///-0.5 (the maximum delta allowed) for right scrolling, and 0.5 (the maximum
///delta allowed) for left scrolling.
double dragScrollDelta(double pos, BoxConstraints constraints) {
  final width = constraints.maxWidth;
  final rightEdge = width * 0.9;
  final leftEdge = width * 0.1;
  if (pos > rightEdge) {
    //interpolate such that as pos -> rightEdge, delta -> -0.5 starting from
    //-0.08
    return -0.08 - (((pos - rightEdge) * 0.42) / (width - rightEdge));
  } else if (pos < leftEdge) {
    //interpolate such that as pos -> leftEdge, delta -> 0.5 starting from
    //0.08
    return 0.08 + (((pos - leftEdge) * 0.42) / leftEdge);
  } else {
    return 0;
  }
}

///background line to be drawn behind the points
Widget backgroundLine(BoxConstraints constraints, double leftPadding,
    double lineHeight, double bottomPadding) {
  return Positioned(
      top: lineHeight - bottomPadding,
      child:
          BackgroundLine(constraints: constraints, leftPadding: leftPadding));
}

///indicator of which group the line is displaying
Widget groupIndicator(String group, double height, [double width = 130]) {
  return Card(
    child: SizedBox(
      width: width,
      height: height,
      child: Center(child: Text(group)),
    ),
  );
}

///positioned signposts that has had the child of the given points added
///with appropriate heights as specified by the given overlap service and
///position as specified by the given point
///
///It is sorted such that the positioned widgets with the most negative top
///values are first
List<Positioned> signposts(
    List<Point> points,
    OverlapService service,
    BoxConstraints constraints,
    ViewRange range,
    double lineHeight,
    BuildContext context,
    double backgroundBottomPadding,
    double signpostHeight) {
  final positioned = points
      .map((point) => signpost(point, service, constraints, range, lineHeight,
          context, backgroundBottomPadding, signpostHeight))
      .toList();
  positioned.sort((a, b) => a.top!.compareTo(b.top!));
  return positioned;
}

///single positioned signpost that has had the child of the given point added
///with appropriate height as specified by the given overlap service and
///position as specified by the given point
Positioned signpost(
    Point point,
    OverlapService service,
    BoxConstraints constraints,
    ViewRange range,
    double lineHeight,
    BuildContext context,
    double backgroundBottomPadding,
    double signpostHeight) {
  final height = service.heightOfPoint(point);
  final signpost =
      Signpost(width: 2, height: height, id: point.id, point: point);
  final positioned = Positioned(
      top: lineHeight - height - backgroundBottomPadding - point.height,
      left: point.relativePosition(constraints, range),
      child: signpost);
  return positioned;
}

///a overlap service with the given points already added
///
///This means that the service will have the information necessary to determine
///the recommended height of each point as well as the total height of the line
OverlapService overlapService(List<Point> points, BoxConstraints constraints,
    ViewRange range, double signpostHeight, double bottomPadding) {
  final service = OverlapService(signpostHeight, bottomPadding);
  for (final point in points) {
    service.add(point, constraints, range);
  }
  return service;
}

///visible is a list of points that are visible in the given view range
List<Point> visible(List<Point> points, ViewRange viewRange) {
  return points
      .where((point) =>
          (point.position >= viewRange.start &&
              point.position <= viewRange.end) ||
          (point.position + point.width >= viewRange.start &&
              point.position + point.width <= viewRange.end))
      .toList();
}
