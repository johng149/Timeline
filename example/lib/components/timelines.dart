import 'package:example/model/custom_point.dart';
import 'package:example/providers/group_id_provider.dart';
import 'package:example/providers/group_name_provider.dart';
import 'package:example/providers/point_provider.dart';
import 'package:example/providers/view_range_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/providers/point_selection_notifier.dart';
import 'package:timeline/timeline.dart';
import 'package:uuid/uuid.dart';

class Timelines extends ConsumerWidget {
  static const uuid = Uuid();
  const Timelines({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Timeline(
        minActionBarHeight: 40,
        maxActionBarHeight: 50,
        actionBarHeightFraction: 0.1,
        groupIdNotifier: groupIdProvider,
        groupNameNotifier: groupNameProvider,
        viewRangeNotifier: viewRangeProvider,
        pointNotifier: pointProvider,
        selectedPointProvider: selectedPointProvider,
        createPoint: createPoint,
        minLineHeight: 75,
        actions: [addGroup],
        pointClicked: (point) => onPointClicked(point, ref),
        indicator: indicator);
  }

  Widget indicator(String groupId, String groupName) {
    return Center(child: Text("id: $groupId, name: $groupName"));
  }

  void onPointClicked(Point point, WidgetRef ref) {
    ref.read(selectedPointProvider.notifier).update((_) => point);
    print("Id of point clicked: ${point.id}");
  }

  ///creates a point given [position] and [group]
  Future<Point?> createPoint(double position, String group) {
    final point = CustomPoint(id: uuid.v4(), position: position, group: group);
    return Future.value(point);
  }

  ///addGroup is a button that will add a group to the timeline
  Widget addGroup(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () {
          Future<String?> groupName = stringDialogSimple(
              context: context, title: 'Add Group', content: 'Group Name');
          groupName.then((value) {
            if (value != null) {
              final id = uuid.v4();
              ref.read(groupIdProvider.notifier).add(id);
              ref.read(groupNameProvider.notifier).add(id, value);
            }
          });
        },
        icon: const Icon(Icons.add));
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
