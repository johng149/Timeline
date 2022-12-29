import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/viewrange_notifier.dart';

///dragHelper updates the view range based on the given drag details
void dragHelper(
    {required BuildContext context,
    required WidgetRef ref,
    required double delta,
    required StateNotifierProvider<ViewRangeNotifier, ViewRange>
        viewRangeNotifier,
    double scale = 0.1}) {
  final scaledDelta = delta * scale;
  final range = ref.read(viewRangeNotifier);
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
