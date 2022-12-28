import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/viewrange_notifier.dart';

final viewRangeProvider = StateNotifierProvider<ViewRangeNotifier, ViewRange>(
  (ref) => ViewRangeNotifier(),
);
