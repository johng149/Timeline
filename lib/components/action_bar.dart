import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/group_notifier.dart';
import 'package:timeline/providers/point_notifier.dart';
import 'package:timeline/providers/viewrange_notifier.dart';

///A widget that provides various buttons for interacting with the timeline
///
///Its size is determined by the given [height], and the various providers
///that it will interact with are given by the [GroupNotifier], [PointNotifier],
///and [ViewRangeNotifier] parameters. It interacts using the given [ref]
class ActionBar extends StatefulWidget {
  final double height;
  final StateNotifierProvider<GroupNotifier, List<String>> groupNotifier;
  final ChangeNotifierProvider<PointNotifier> pointNotifier;
  final StateNotifierProvider<ViewRangeNotifier, ViewRange> viewRangeNotifier;
  final WidgetRef ref;

  const ActionBar(
      {super.key,
      required this.height,
      required this.groupNotifier,
      required this.pointNotifier,
      required this.viewRangeNotifier,
      required this.ref});

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
