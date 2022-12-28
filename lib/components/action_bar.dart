import 'package:flutter/material.dart';
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
    return Consumer(builder: (context, ref, child) {
      return wrapper(actions(context, ref));
    });
  }

  ///actions is a row of buttons that will be used to interact with the timeline
  Widget actions(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [addGroup(context, ref)],
    );
  }

  ///addGroup is a button that will add a group to the timeline
  Widget addGroup(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () {
          Future<String?> groupName = stringDialogSimple(
              context: context, title: 'Add Group', content: 'Group Name');
          groupName.then((value) {
            if (value != null) {
              ref.read(widget.groupNotifier.notifier).add(value);
            }
          });
        },
        icon: const Icon(Icons.add));
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

///Opens dialog with given title and content which asks user to enter string
///or cancel the action, in which case the dialog closes and returns null
Future<String?> stringDialogSimple(
    {required BuildContext context,
    required String title,
    required String content}) async {
  final textController = TextEditingController();

  return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: content),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () => Navigator.of(context).pop(textController.text),
                child: const Text("OK"))
          ],
        );
      });
}
