import 'package:timeline/models/point/point.dart';

int binarySearchHelper(List<Point> list, double targetPosition) {
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
    if (targetPosition.compareTo(list[mid].position) < 0) {
      max = mid - 1;
    } else if (targetPosition.compareTo(list[mid].position) > 0) {
      min = mid + 1;
    } else {
      return mid;
    }
    mid = (min + max) ~/ 2;
  }

  return min;
}
