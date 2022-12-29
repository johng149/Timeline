import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/viewrange_notifier.dart';

///dragHelper updates the view range based on the given drag direction, which
///should be either -1 or 1. Negative will move view range to the right
void dragHelper(
    {required BuildContext context,
    required WidgetRef ref,
    required double direction,
    required StateNotifierProvider<ViewRangeNotifier, ViewRange>
        viewRangeNotifier,
    double scale = 0.002}) {
  final range = ref.read(viewRangeNotifier);
  final scaledDelta = range.range * direction * scale;
  final newStart = range.start - scaledDelta;
  final newEnd = range.end - scaledDelta;
  ref
      .read(viewRangeNotifier.notifier)
      .set(ViewRange(start: newStart, end: newEnd));
}

///turns position of user interaction on screen to being relative to the
///view range instead of the screen
double relativePosition(
    double position, ViewRange range, BoxConstraints constraints) {
  final ratio = position / constraints.maxWidth;
  return range.start + range.range * ratio;
}
