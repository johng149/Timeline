import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeline/models/viewrange/range_difference.dart';

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

  /// determines difference between [this] and [other]
  ///
  /// Suppose we have two ranges: [A], [B]
  /// If [B] is completely within [A], then the difference of [A] from [B] will
  /// result in a [RangeDifference] with null [left] and [right] ranges
  ///
  /// If it were instead [A] completely within [B], then the difference of [A]
  /// from [B] will result in a [RangeDifference] where [left] is from the
  /// start of [B] to the start of [A] and [right] is from the end of [A] to the
  /// end of [B]
  ///
  /// If [B] was partially within [A] but extended beyond the end of [A], then
  /// the difference of [A] from [B] will result in a [RangeDifference] where
  /// [left] is null and [right] is from the end of [A] to the end of [B]
  RangeDifference difference(ViewRange other) {
    if (other.start >= start && other.end <= end) {
      return RangeDifference(left: null, right: null);
    } else if (other.start < start && other.end > end) {
      return RangeDifference(
          left: ViewRange(start: other.start, end: start),
          right: ViewRange(start: end, end: other.end));
    } else if (other.start >= start && other.end > end) {
      return RangeDifference(
          left: null, right: ViewRange(start: end, end: other.end));
    } else if (other.start < start && other.end <= end) {
      return RangeDifference(
          left: ViewRange(start: other.start, end: start), right: null);
    } else {
      throw Exception('This should never happen');
    }
  }
}
