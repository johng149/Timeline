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
                  constraints,
                  ref,
                  group,
                  points.points(group),
                  viewRange,
                  viewRangeNotifier,
                  pointNotifier,
                  createPoint,
                  context,
                  minLineHeight,
                  signpostHeight,
                  backgroundBottomPadding);
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
}

///line is a single line of points
///
///Its contents depends on what group the line is supposed to be displaying,
///along with the points that are associated with that group
///and the current viewing range.
///
///These values are provided as parameters to the [line] function.
Widget line(
    BoxConstraints constraints,
    WidgetRef ref,
    String group,
    List<Point> points,
    ViewRange viewRange,
    StateNotifierProvider<ViewRangeNotifier, ViewRange> viewRangeNotifier,
    ChangeNotifierProvider<PointNotifier> pointNotifier,
    CreatePoint createPoint,
    BuildContext context,
    double minLineHeight,
    double signpostHeight,
    double backgroundBottomPadding) {
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
  return SizedBox(
    height: lineHeight,
    width: constraints.maxWidth,
    child: renderStack,
  );
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
      Signpost(width: 2, height: height, child: point.child(context));
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
