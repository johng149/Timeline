import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeline/timeline.dart' show Point;

part 'custom_point.freezed.dart';
part 'custom_point.g.dart';

///Has the [Point] mixin which allows it to be used as a point in the timeline
@freezed
class CustomPoint with _$CustomPoint, Point {
  ///Has the [Point] mixin which allows it to be used as a point in the timeline
  const factory CustomPoint({
    ///The id of the point
    required String id,

    ///The position of the point
    required double position,

    ///The group of the point
    required String group,
  }) = _CustomPoint;

  ///Has the [Point] mixin which allows it to be used as a point in the timeline
  const CustomPoint._();

  ///Has the [Point] mixin which allows it to be used as a point in the timeline
  factory CustomPoint.fromJson(Map<String, dynamic> json) =>
      _$CustomPointFromJson(json);

  ///Has the [Point] mixin which allows it to be used as a point in the timeline
  @override
  Widget child(BuildContext context) => SizedBox(
        height: 100,
        width: 100,
        child: Card(child: Text(id)),
      );

  @override
  double get height => 100;

  @override
  double get width => 100;

  @override
  CustomPoint move(String newGroup, double newPosition) => copyWith(
        group: newGroup,
        position: newPosition,
      );
}
