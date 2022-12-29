import 'package:flutter_test/flutter_test.dart';
import 'package:timeline/components/timeline.dart';
import 'package:timeline/models/viewrange/viewrange.dart';

import 'helper.dart';

//10 test points, like TestPoint("1", 0, "some group")
final testPoints = [
  TestPoint("1", 0, "some group"),
  TestPoint("2", 1, "some group"),
  TestPoint("3", 32, "some group"),
  TestPoint("4", 50, "some group"),
  TestPoint("5", 58, "some group"),
  TestPoint("6", 300, "some group"),
  TestPoint("7", 305, "some group"),
  TestPoint("8", 428, "some group"),
  TestPoint("9", 1000, "some group"),
  TestPoint("10", 9999, "some group"),
];

void main() {
  group("visibility", () {
    test("all visible", () {
      const viewRange = ViewRange(start: 0, end: 10000);
      final visiblePoints = visible(testPoints, viewRange);
      expect(visiblePoints, testPoints);
    });

    test("all invisible", () {
      const viewRange = ViewRange(start: -2, end: -1);
      final visiblePoints = visible(testPoints, viewRange);
      expect(visiblePoints, []);
    });

    test("some visible", () {
      const viewRange = ViewRange(start: 99, end: 500);
      final visiblePoints = visible(testPoints, viewRange);
      expect(visiblePoints, [
        testPoints[0],
        testPoints[1],
        testPoints[2],
        testPoints[3],
        testPoints[4],
        testPoints[5],
        testPoints[6],
        testPoints[7]
      ]);
    });
  });
}
