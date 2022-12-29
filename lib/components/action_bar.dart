import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/definitions/action_maker.dart';
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
  final List<ActionMaker> actions;
  const ActionBar(
      {super.key,
      required this.height,
      required this.groupNotifier,
      required this.pointNotifier,
      required this.viewRangeNotifier,
      required this.ref,
      required this.actions});

  @override
  State<ActionBar> createState() => _ActionBarState();
}

///the state will be a placeholder for now
class _ActionBarState extends State<ActionBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return wrapper(actions(context, ref));
    });
  }

  ///actions is a row of buttons that will be used to interact with the timeline
  Widget actions(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (ActionMaker action in widget.actions) action(context, ref),
      ],
    );
  }

  ///wrapper is a container with box decoration such that it has rounded borders
  ///and child is given
  Widget wrapper(Widget child) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1)
          ]),
      child: child,
    );
  }
}
