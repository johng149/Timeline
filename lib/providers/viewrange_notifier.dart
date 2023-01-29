import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/models/viewrange/viewrange.dart';

///Manages a [ViewRange] as its state
///
///It is a StateNotifier and thus its state is immutable
class ViewRangeNotifier extends StateNotifier<ViewRange> {
  ViewRangeNotifier() : super(const ViewRange());

  ///Sets the [ViewRange] to the specified [viewRange]
  void set(ViewRange viewRange) {
    state = viewRange;
  }

  /// resets the [ViewRange] to its default value
  void reset() {
    state = const ViewRange();
  }
}
