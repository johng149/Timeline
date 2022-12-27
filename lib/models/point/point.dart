import 'package:flutter/material.dart';
import 'package:timeline/models/viewrange/viewrange.dart';

///Point is an abstract class that describes what is needed to properly render
///a point (and its child) on a line for a timeline
abstract class Point {
  double get position;

  ///relativePosition is the position of the point on the screen
  ///
  ///It is calculated by taking the position of the point, determining its
  ///ratio with respect to the given [range] and then multiplying that ratio
  ///by the width of the screen as specified by [constraints]
  double relativePosition(BoxConstraints constraints, ViewRange range) {
    final ratio = (position - range.start) / range.range;
    return ratio * constraints.maxWidth;
  }

  double get width;
  double get height;
  Widget get child;
  String get id;
}
