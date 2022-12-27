import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:collection';

import 'package:timeline/providers/point_notifier.dart';

import 'helper.dart';

void main() {
  group("point notifier add", () {
    test("add point", () {
      final pointProvider = ChangeNotifierProvider<PointNotifier>((ref) {
        return PointNotifier();
      });
      final container = ProviderContainer();
      final notifier = container.read(pointProvider);
      const group1 = "test group";
      final point1 = TestPoint("1", 1.0);
      notifier.add(group1, point1);

      final points = notifier.points(group1);
      final expectedPoints = [point1];
      expect(points.length, 1);
      expect(points, expectedPoints);
      expect(notifier.allPoints.length, 1);
      expect(notifier.allPoints, expectedPoints);
    });

    test("add multiple points", () {
      final pointProvider = ChangeNotifierProvider<PointNotifier>((ref) {
        return PointNotifier();
      });
      final container = ProviderContainer();
      final notifier = container.read(pointProvider);
      const group1 = "test group";
      final point1 = TestPoint("1", 1.0);
      final point2 = TestPoint("2", 2.0);
      final point3 = TestPoint("3", 3.0);
      notifier.add(group1, point1);
      notifier.add(group1, point2);
      notifier.add(group1, point3);

      final points = notifier.points(group1);
      final expectedPoints = [point1, point2, point3];
      expect(points.length, 3);
      expect(points, expectedPoints);
      expect(notifier.allPoints.length, 3);
      expect(notifier.allPoints, expectedPoints);
    });

    test("add multiple points to different groups", () {
      final pointProvider = ChangeNotifierProvider<PointNotifier>((ref) {
        return PointNotifier();
      });
      final container = ProviderContainer();
      final notifier = container.read(pointProvider);
      const group1 = "test group 1";
      const group2 = "test group 2";
      final point1 = TestPoint("1", 1.0);
      final point2 = TestPoint("2", 2.0);
      final point3 = TestPoint("3", 3.0);
      notifier.add(group1, point1);
      notifier.add(group1, point2);
      notifier.add(group2, point3);

      final points1 = notifier.points(group1);
      final expectedPoints1 = [point1, point2];
      expect(points1.length, 2);
      expect(points1, expectedPoints1);

      final points2 = notifier.points(group2);
      final expectedPoints2 = [point3];
      expect(points2.length, 1);
      expect(points2, expectedPoints2);

      expect(notifier.allPoints.length, 3);
      expect(notifier.allPoints, [point1, point2, point3]);
    });

    test(
        "adding multiple points to 3 different groups, add order not get order",
        () {
      final pointProvider = ChangeNotifierProvider<PointNotifier>((ref) {
        return PointNotifier();
      });
      final container = ProviderContainer();
      final notifier = container.read(pointProvider);
      const group1 = "test group 1";
      const group2 = "test group 2";
      const group3 = "test group 3";
      final point1 = TestPoint("1", 1.0);
      final point2 = TestPoint("2", 2.0);
      final point3 = TestPoint("3", 3.0);
      final point4 = TestPoint("4", 4.0);
      final point5 = TestPoint("5", 5.0);
      final point6 = TestPoint("6", 6.0);
      notifier.add(group1, point4);
      notifier.add(group1, point1);
      notifier.add(group2, point2);
      notifier.add(group3, point3);
      notifier.add(group2, point5);
      notifier.add(group3, point6);

      final points1 = notifier.points(group1);
      final expectedPoints1 = [point1, point4];
      expect(points1.length, 2);
      expect(points1, expectedPoints1);

      final points2 = notifier.points(group2);
      final expectedPoints2 = [point2, point5];
      expect(points2.length, 2);
      expect(points2, expectedPoints2);

      final points3 = notifier.points(group3);
      final expectedPoints3 = [point3, point6];
      expect(points3.length, 2);
      expect(points3, expectedPoints3);

      expect(notifier.allPoints.length, 6);
      expect(
          notifier.allPoints, [point1, point2, point3, point4, point5, point6]);
    });
  });

  group("point notifier remove", () {
    test("remove point that not exist", () {
      final pointProvider = ChangeNotifierProvider<PointNotifier>((ref) {
        return PointNotifier();
      });
      final container = ProviderContainer();
      final notifier = container.read(pointProvider);
      const group1 = "test group";
      final point1 = TestPoint("1", 1.0);

      expect(notifier.allPoints, []);

      notifier.remove(group1, point1);

      expect(notifier.allPoints, []);
    });

    test("remove point that exist", () {
      final pointProvider = ChangeNotifierProvider<PointNotifier>((ref) {
        return PointNotifier();
      });
      final container = ProviderContainer();
      final notifier = container.read(pointProvider);
      const group1 = "test group";
      final point1 = TestPoint("1", 1.0);
      notifier.add(group1, point1);

      expect(notifier.allPoints, [point1]);

      notifier.remove(group1, point1);

      expect(notifier.allPoints, []);
    });

    test("remove one point with other points left", () {
      final pointProvider = ChangeNotifierProvider<PointNotifier>((ref) {
        return PointNotifier();
      });
      final container = ProviderContainer();
      final notifier = container.read(pointProvider);
      const group1 = "test group";
      final point1 = TestPoint("1", 1.0);
      final point2 = TestPoint("2", 2.0);
      final point3 = TestPoint("3", 3.0);
      notifier.add(group1, point1);
      notifier.add(group1, point2);
      notifier.add(group1, point3);

      expect(notifier.allPoints, [point1, point2, point3]);

      notifier.remove(group1, point2);

      expect(notifier.allPoints, [point1, point3]);
    });
  });
}
