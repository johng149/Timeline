import 'package:flutter_test/flutter_test.dart';
import 'package:timeline/providers/point_notifier.dart';

import 'helper.dart';

void main() {
  group("binary search", () {
    test("search on empty list", () {
      final point1 = TestPoint("1", 1.0);
      final list = <TestPoint>[];
      final index = binarySearch(list, point1);
      expect(index, 0);
    });

    test("search on list with one element", () {
      final point1 = TestPoint("1", 1.0);
      final point2 = TestPoint("2", 2.0);
      final list = <TestPoint>[point1];
      final index = binarySearch(list, point2);
      expect(index, 1);
    });

    test("search on list with two elements, add to start", () {
      final point1 = TestPoint("1", 1.0);
      final point2 = TestPoint("2", 2.0);
      final point3 = TestPoint("3", 3.0);
      final list = <TestPoint>[point2, point3];
      final index = binarySearch(list, point1);
      expect(index, 0);
    });

    test("search on list with two elements, add to middle", () {
      final point1 = TestPoint("1", 1.0);
      final point2 = TestPoint("2", 2.0);
      final point3 = TestPoint("3", 3.0);
      final list = <TestPoint>[point1, point3];
      final index = binarySearch(list, point2);
      expect(index, 1);
    });

    test("search on list with two elements, add to end", () {
      final point1 = TestPoint("1", 1.0);
      final point2 = TestPoint("2", 2.0);
      final point3 = TestPoint("3", 3.0);
      final list = <TestPoint>[point1, point2];
      final index = binarySearch(list, point3);
      expect(index, 2);
    });
  });
}
