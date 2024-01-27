import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/components/action_bar.dart';
import 'package:timeline/components/background_line.dart';
import 'package:timeline/components/interaction_detector.dart';
import 'package:timeline/components/line_drag_target.dart';
import 'package:timeline/components/signpost.dart';
import 'package:timeline/definitions/action_maker.dart';
import 'package:timeline/definitions/create_point.dart';
import 'package:timeline/definitions/group_indicator_maker.dart';
import 'package:timeline/definitions/point_clicked.dart';
import 'package:timeline/models/point/point.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/group_notifier.dart';
import 'package:timeline/providers/point_notifier.dart';
import 'package:timeline/providers/point_selection_notifier.dart';
import 'package:timeline/providers/viewrange_notifier.dart';
import 'package:timeline/services/overlap_service.dart';
import 'package:timeline/timeline.dart';

///A widget that displays zero or more points of interest on parallel lines
///
///The [Timeline] widget determines which points should be considered for
///rendering based on given [GroupIdNotifier] and [PointNotifier] providers,
///along with which points are visible based on the given [ViewRangeNotifier]
///provider. The [Timeline] widget also determines the position of each point
///on the screen based on the view range and the constraints of the screen
///as provided by a LayoutBuilder.
///
///[Timeline] will also ensure that its action bar size is at least the given
///[minActionBarHeight] and not greater than the given [maxActionBarHeight],
///and will attempt to keep the action bar's size a given fraction of the
///screen's height, as specified by [actionBarHeightFraction].
class Timeline extends StatefulWidget {
  final double minActionBarHeight;
  final double maxActionBarHeight;
  final double actionBarHeightFraction;
  final double minLineHeight;
  final StateNotifierProvider<GroupIdNotifier, List<String>> groupIdNotifier;
  final ChangeNotifierProvider<GroupNameNotifier> groupNameNotifier;
  final ChangeNotifierProvider<PointNotifier> pointNotifier;
  final StateNotifierProvider<ViewRangeNotifier, ViewRange> viewRangeNotifier;
  final StateProvider<Point?> selectedPointProvider;
  final GroupIndicator indicator;
  final double indicatorWidth;
  final CreatePoint createPoint;
  final double signpostHeight = 10;
  final double backgroundBottomPadding = 10;
  final List<ActionMaker> actions;
  final PointClicked? pointClicked;
  const Timeline(
      {Key? key,
      required this.minActionBarHeight,
      required this.maxActionBarHeight,
      required this.actionBarHeightFraction,
      required this.groupIdNotifier,
      required this.groupNameNotifier,
      required this.viewRangeNotifier,
      required this.pointNotifier,
      required this.selectedPointProvider,
      required this.createPoint,
      required this.minLineHeight,
      required this.indicator,
      this.indicatorWidth = 130,
      this.pointClicked,
      this.actions = const []})
      : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  bool allowScrolling = true;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [bar(constraints, ref), lines(constraints, ref)],
        );
      });
    });
  }

  ///lines is the list of lines (and their points) to be rendered
  Widget lines(BoxConstraints constraints, WidgetRef ref) {
    final groupIds = ref.watch(widget.groupIdNotifier);
    final groupNames = ref.watch(widget.groupNameNotifier);
    final points = ref.watch(widget.pointNotifier);
    final viewRange = ref.watch(widget.viewRangeNotifier);
    return Expanded(
        child: ReorderableListView.builder(
            physics: allowScrolling ? null : NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIndex) {
              ref
                  .read(widget.groupIdNotifier.notifier)
                  .move(oldIndex, newIndex);
            },
            itemCount: groupIds.length,
            itemBuilder: (context, index) {
              final groupId = groupIds[index];
              final groupName = groupNames.name(groupId) ?? "Unnamed Group";
              return line(
                  constraints: constraints,
                  ref: ref,
                  groupId: groupId,
                  groupName: groupName,
                  points: points.points(groupId),
                  viewRange: viewRange,
                  context: context,
                  index: index);
            }));
  }

  ///barHeight is the height of the action bar given the current constraints
  double barHeight(BoxConstraints constraints) {
    return min(
        max(constraints.maxHeight * widget.actionBarHeightFraction,
            widget.minActionBarHeight),
        widget.maxActionBarHeight);
  }

  ///bar is the action bar widget
  Widget bar(BoxConstraints constraints, WidgetRef ref) {
    final height = barHeight(constraints);
    return SingleChildScrollView(
      child: SizedBox(
          height: height,
          child: ActionBar(
            height: height,
            groupNotifier: widget.groupIdNotifier,
            viewRangeNotifier: widget.viewRangeNotifier,
            pointNotifier: widget.pointNotifier,
            ref: ref,
            actions: widget.actions,
          )),
    );
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
      required String groupId,
      required String groupName,
      required int index,
      required List<Point> points,
      required ViewRange viewRange,
      required BuildContext context}) {
    final visiblePoints = visible(points, viewRange);
    final service = overlapService(visiblePoints, constraints, viewRange,
        widget.signpostHeight, widget.backgroundBottomPadding);
    final lineHeight = max(service.height, widget.minLineHeight);
    final positioned = signposts(
        visiblePoints,
        service,
        constraints,
        viewRange,
        lineHeight,
        context,
        widget.backgroundBottomPadding,
        widget.signpostHeight,
        widget.pointClicked,
        widget.selectedPointProvider);
    final indicator = groupIndicator(
        groupId: groupId,
        groupName: groupName,
        groupIndex: index,
        height: lineHeight,
        width: widget.indicatorWidth);
    final interactionDetector = TimelineGestures(
      groupId: groupId,
      constraints: constraints,
      height: lineHeight,
      viewRangeNotifier: widget.viewRangeNotifier,
      pointNotifier: widget.pointNotifier,
      createPoint: widget.createPoint,
      scrollStopper: () {
        if (allowScrolling) {
          setState(() {
            allowScrolling = false;
          });
        }
      },
    );
    final background = backgroundLine(
        constraints, 15, lineHeight, widget.backgroundBottomPadding);
    final renderStack = Stack(
      children: [
        interactionDetector,
        background,
        ...positioned,
        indicator,
        zoomPadder(height: lineHeight, width: widget.indicatorWidth)
      ],
    );
    final target = LineDragTarget(
        constraints: constraints,
        viewRangeNotifier: widget.viewRangeNotifier,
        group: groupId,
        pointNotifier: widget.pointNotifier,
        child: renderStack);
    return SizedBox(
      key: Key('$index'),
      height: lineHeight,
      width: constraints.maxWidth,
      child: target,
    );
  }

  ///indicator of which group the line is displaying
  Widget groupIndicator(
      {required String groupId,
      required String groupName,
      required int groupIndex,
      required double height,
      double width = 130}) {
    return ReorderableDragStartListener(
      index: groupIndex,
      child: Card(
        child: SizedBox(
          width: width,
          height: height,
          child: widget.indicator(groupId, groupName),
        ),
      ),
    );
  }

  ///gesture detector to enable scrolling when the user is not zooming
  ///
  ///user is considered to be not zooming when the user is scrolling
  ///mouse wheel in the specified area
  Widget zoomPadder({
    required double height,
    required double width,
  }) {
    // color is semi-transparent
    return Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent && !allowScrolling) {
            setState(() {
              allowScrolling = true;
            });
          }
        },
        child: Container(
          height: height,
          width: width,
          color: Colors.transparent,
        ));
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
    double signpostHeight,
    PointClicked? pointClicked,
    StateProvider<Point?> selectedPointProvider) {
  final positioned = points
      .map((point) => signpost(
          point,
          service,
          constraints,
          range,
          lineHeight,
          context,
          backgroundBottomPadding,
          signpostHeight,
          pointClicked,
          selectedPointProvider))
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
    double signpostHeight,
    PointClicked? pointClicked,
    StateProvider<Point?> selectedPointProvider) {
  final height = service.heightOfPoint(point);
  final signpost = Signpost(
      width: 2,
      height: height,
      point: point,
      onPointClicked: pointClicked,
      selectedPointProvider: selectedPointProvider);
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
