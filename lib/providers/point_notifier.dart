import 'package:flutter/cupertino.dart';
import 'package:timeline/models/point/point.dart';
import 'package:timeline/services/binary_search.dart';

///Index where the [target] needs to be inserted into the [list] such that the
///list remains sorted with the smallest element as the first element of list
int binarySearch(List<Point> list, Point target) {
  return binarySearchHelper(list, target.position);
}

///Manages mapping between group ids and list of points that each group has
///
///Whenever a [point] is added or removed, the [PointNotifier] will ensure that
///the list of points that the [point] belongs to remains ordered by position,
///with the lowest position at the front of the list
///
///The [getEvent] method is list of events that belong to specified group, or
///an empty list if the group does not exist
///
///The [allPoints] method is list of all events that have been added regardless
///of the group they belong to, the resulting list is sorted by position such
///that the lowest position is at the front of the list
class PointNotifier extends ChangeNotifier {
  final Map<String, List<Point>> _points = {};

  ///Adds the [point] to the list of points that belong to the group specified
  ///by [groupId]
  ///
  ///If the group does not exist, it will be created
  void add(Point point, {bool notify = false}) {
    final targetList = _points[point.group] ??= [];
    final initialLength = targetList.length;
    final index = binarySearch(targetList, point);
    targetList.insert(index, point);
    if (initialLength <= 0) {
      _points[point.group] = targetList;
    }
    notifyListeners();
  }

  /// Adds a list of [points]
  void addAll(List<Point> points) {
    for (final point in points) {
      add(point, notify: false);
    }
    notifyListeners();
  }

  ///Removes the [point] from the list of points that belong to the group
  ///specified by [groupId]
  ///
  ///If the group does not exist, nothing will happen
  void remove(Point point, {bool notify = true}) {
    final targetList = _points[point.group];
    if (targetList == null) {
      return;
    } else {
      final initialLength = targetList.length;
      targetList.removeWhere((element) => element.id == point.id);
      if (targetList.length != initialLength && notify) {
        notifyListeners();
      }
    }
  }

  ///move [point] from its current group and position to the new group and
  ///position specified by [newGroup] and [newPosition]
  void move(Point point, String newGroup, double newPosition) {
    remove(point, notify: false);
    final newPoint = point.move(newGroup, newPosition);
    add(newPoint);
  }

  ///Returns the list of points that belong to the group specified by [groupId]
  ///
  ///If the group does not exist, an empty list will be returned
  List<Point> points(String groupId) {
    return _points[groupId] ?? [];
  }

  ///Returns the list of all points that have been added regardless of the
  ///group they belong to
  ///
  ///The resulting list is sorted by position such that the lowest position is
  ///at the front of the list
  List<Point> get allPoints {
    final allPoints = <Point>[];
    _points.forEach((_, points) {
      allPoints.addAll(points);
    });

    allPoints.sort((a, b) => a.position.compareTo(b.position));
    return allPoints;
  }
}
