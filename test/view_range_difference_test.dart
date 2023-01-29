import 'package:flutter_test/flutter_test.dart';
import 'package:timeline/models/viewrange/viewrange.dart';

void main() {
  test("other range is completely within current range", () {
    final current = ViewRange(start: 0, end: 100);
    final other = ViewRange(start: 10, end: 90);
    final difference = current.difference(other);
    expect(difference.left, null);
    expect(difference.right, null);
  });

  test("current range is completely within other range", () {
    final current = ViewRange(start: 10, end: 90);
    final other = ViewRange(start: 0, end: 100);
    final difference = current.difference(other);

    final expectedLeft = ViewRange(start: 0, end: 10);
    final expectedRight = ViewRange(start: 90, end: 100);

    expect(difference.left, expectedLeft);
    expect(difference.right, expectedRight);
  });

  test("other is extending beyond left of current", () {
    final current = ViewRange(start: 10, end: 90);
    final other = ViewRange(start: 0, end: 50);
    final difference = current.difference(other);

    final expectedLeft = ViewRange(start: 0, end: 10);

    expect(difference.left, expectedLeft);
    expect(difference.right, null);
  });

  test("other is extending beyond right of current", () {
    final current = ViewRange(start: 10, end: 90);
    final other = ViewRange(start: 50, end: 100);
    final difference = current.difference(other);

    final expectedRight = ViewRange(start: 90, end: 100);

    expect(difference.left, null);
    expect(difference.right, expectedRight);
  });
}
