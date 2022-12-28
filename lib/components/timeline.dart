import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/components/action_bar.dart';
import 'package:timeline/models/point/point.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/group_notifier.dart';
import 'package:timeline/providers/point_notifier.dart';
import 'package:timeline/providers/viewrange_notifier.dart';

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
  final StateNotifierProvider<GroupNotifier, List<String>> groupNotifier;
  final ChangeNotifierProvider<PointNotifier> pointNotifier;
  final StateNotifierProvider<ViewRangeNotifier, ViewRange> viewRangeNotifier;

  const Timeline(
      {Key? key,
      required this.minActionBarHeight,
      required this.maxActionBarHeight,
      required this.actionBarHeightFraction,
      required this.groupNotifier,
      required this.viewRangeNotifier,
      required this.pointNotifier})
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
                  constraints, ref, group, points.points(group), viewRange);
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
Widget line(BoxConstraints constraints, WidgetRef ref, String group,
    List<Point> points, ViewRange viewRange) {
  return Placeholder();
}
