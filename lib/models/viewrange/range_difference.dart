import 'package:timeline/models/viewrange/viewrange.dart';

/// It has the [left] and [right] ranges after one range subtracted from another
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
class RangeDifference {
  final ViewRange? left;
  final ViewRange? right;

  RangeDifference({this.left, this.right});
}
