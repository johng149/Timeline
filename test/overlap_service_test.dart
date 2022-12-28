import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/services/overlap_service.dart';

import 'helper.dart';

void main() {
  group("overlap service", () {
    test('two point overlap, one outside view range', () {
      final service = OverlapService();
      const range = ViewRange(start: 0, end: 100);
      const constraints = BoxConstraints(maxHeight: 300, maxWidth: 300);
      final point1 = TestPoint('1', 10);
      final point2 = TestPoint('2', 12);
      final point3 = TestPoint('3', 300);

      service.add(point1, constraints, range);
      service.add(point2, constraints, range);
      service.add(point3, constraints, range);

      expect(service.heightOfPoint(point1), 0);
      expect(service.heightOfPoint(point2), 100);
      expect(service.heightOfPoint(point3), 0);
    });

    test("no overlap", () {
      final service = OverlapService();
      const range = ViewRange(start: 0, end: 300);
      const constraints = BoxConstraints(maxHeight: 300, maxWidth: 300);
      final point1 = TestPoint('1', 0);
      final point2 = TestPoint('2', 101);
      final point3 = TestPoint('3', 202);

      service.add(point1, constraints, range);
      service.add(point2, constraints, range);
      service.add(point3, constraints, range);

      expect(service.heightOfPoint(point1), 0);
      expect(service.heightOfPoint(point2), 0);
      expect(service.heightOfPoint(point3), 0);
    });

    test("three overlap", () {
      final service = OverlapService();
      const range = ViewRange(start: 0, end: 300);
      const constraints = BoxConstraints(maxHeight: 300, maxWidth: 300);
      final point1 = TestPoint('1', 0);
      final point2 = TestPoint('2', 10);
      final point3 = TestPoint('3', 20);

      service.add(point1, constraints, range);
      service.add(point2, constraints, range);
      service.add(point3, constraints, range);

      expect(service.heightOfPoint(point1), 0);
      expect(service.heightOfPoint(point2), 100);
      expect(service.heightOfPoint(point3), 200);
    });
  });

  group("point to region", () {
    test("point to region", () {
      const range = ViewRange(start: 0, end: 300);
      const constraints = BoxConstraints(maxHeight: 300, maxWidth: 300);
      final point = TestPoint('1', 10);
      final region = pointToRegion(point, constraints, range);
      expect(region.start, 10);
      expect(region.end, 110);
    });

    test("point to region where range neq constraint", () {
      const range = ViewRange(start: 0, end: 300);
      const constraints = BoxConstraints(maxHeight: 300, maxWidth: 600);
      final point = TestPoint('1', 10);
      final region = pointToRegion(point, constraints, range);
      expect(region.start, 20);
      expect(region.end, 120);
    });
  });
}
