import 'package:flutter/cupertino.dart';
import 'package:timeline/models/point/point.dart';

///Index where the [target] needs to be inserted into the [list] such that the
///list remains sorted with the smallest element as the first element of list
int binarySearch(List<Point> list, Point target) {
  int min = 0;
  int max = list.length - 1;
  int mid = (min + max) ~/ 2;

  //for each iteration, we compare the [target] to the element at [mid]
  //
  //if the [target] is less than the element at [mid], we now need to search
  //the left half of the list, so we need to set [max] to [mid] - 1
  //
  //if the [target] is greater than the element at [mid], we now need to search
  //the right half of the list, so we need to set [min] to [mid] + 1
  //
  //if the [target] is equal to the element at [mid], we return [mid]
  //
  //we continue this process until [min] is greater than [max]
  //if this happens, we return [min] because that is where the [target] needs
  while (min <= max) {
    if (target.position.compareTo(list[mid].position) < 0) {
      max = mid - 1;
    } else if (target.position.compareTo(list[mid].position) > 0) {
      min = mid + 1;
    } else {
      return mid;
    }
    mid = (min + max) ~/ 2;
  }

  return min;
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
  void add(String groupId, Point point) {
    final targetList = _points[groupId] ??= [];
    final initialLength = targetList.length;
    final index = binarySearch(targetList, point);
    targetList.insert(index, point);
    if (initialLength <= 0) {
      _points[groupId] = targetList;
    }
    notifyListeners();
  }

  ///Removes the [point] from the list of points that belong to the group
  ///specified by [groupId]
  ///
  ///If the group does not exist, nothing will happen
  void remove(String groupId, Point point) {
    final targetList = _points[groupId];
    if (targetList == null) {
      return;
    } else {
      final initialLength = targetList.length;
      targetList.removeWhere((element) => element.id == point.id);
      if (targetList.length != initialLength) {
        notifyListeners();
      }
    }
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
