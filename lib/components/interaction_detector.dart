import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  const TimelineGestures(
      {super.key,
      required this.groupId,
      required this.constraints,
      required this.height,
      required this.viewRangeNotifier,
      required this.pointNotifier});

  @override
  State<TimelineGestures> createState() => _TimelineGesturesState();
}

class _TimelineGesturesState extends State<TimelineGestures> {
  TapDownDetails? _tapDownDetails;

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
