import 'package:flutter/cupertino.dart';
import 'package:timeline/providers/group_notifier.dart';
import 'package:timeline/providers/point_notifier.dart';
import 'package:timeline/providers/viewrange_notifier.dart';

///A widget that provides various buttons for interacting with the timeline
///
///Its size is determined by the given [height], and the various providers
///that it will interact with are given by the [GroupNotifier], [PointNotifier],
///and [ViewRangeNotifier] parameters.
class ActionBar extends StatefulWidget {
  final double height;
  final GroupNotifier groupNotifier;
  final PointNotifier pointNotifier;
  final ViewRangeNotifier viewRangeNotifier;

  const ActionBar(
      {super.key,
      required this.height,
      required this.groupNotifier,
      required this.pointNotifier,
      required this.viewRangeNotifier});

  @override
  State<ActionBar> createState() => _ActionBarState();
}

///the state will be a placeholder for now
class _ActionBarState extends State<ActionBar> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
