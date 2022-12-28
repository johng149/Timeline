import 'package:example/model/custom_point.dart';
import 'package:example/providers/group_provider.dart';
import 'package:example/providers/point_provider.dart';
import 'package:example/providers/view_range_provider.dart';
import 'package:flutter/material.dart';
import 'package:timeline/timeline.dart';
import 'package:uuid/uuid.dart';

class Timelines extends StatelessWidget {
  static const uuid = Uuid();
  const Timelines({super.key});

  @override
  Widget build(BuildContext context) {
    return Timeline(
        minActionBarHeight: 25,
        maxActionBarHeight: 50,
        actionBarHeightFraction: 0.1,
        groupNotifier: groupProvider,
        viewRangeNotifier: viewRangeProvider,
        pointNotifier: pointProvider,
        createPoint: createPoint,
        minLineHeight: 75);
  }

  ///creates a point given [position] and [group]
  Point? createPoint(double position, String group) {
    return CustomPoint(id: uuid.v4(), position: position, group: group);
  }
}
