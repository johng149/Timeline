import 'package:freezed_annotation/freezed_annotation.dart';

part 'viewrange.freezed.dart';
part 'viewrange.g.dart';

///ViewRange is a freezed class that contains two fields: [start] and [end]
///which are the start and end of the viewing range.
///It is used to represent the range of positions user should be able to see
@freezed
class ViewRange with _$ViewRange {
  const ViewRange._();

  const factory ViewRange(
      {@Default(0) double start, @Default(100) double end}) = _ViewRange;

  factory ViewRange.fromJson(Map<String, dynamic> json) =>
      _$ViewRangeFromJson(json);

  ///range returns the difference between [start] and [end]
  double get range => end - start;

  ///approxEq returns true if [other] is a ViewRange and the difference
  ///between [start] and [end] of [this] and [other] is less than [epsilon],
  ///with [epsilon] defaulting to 0.00001
  bool approxEq(dynamic other, {double epsilon = 0.00001}) {
    if (other is! ViewRange) {
      return false;
    }
    return (start - other.start).abs() < epsilon &&
        (end - other.end).abs() < epsilon;
  }
}
