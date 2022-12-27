import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeline/models/viewrange/viewrange.dart';
import 'package:timeline/providers/viewrange_notifier.dart';

void main() {
  group("viewrange notifier", () {
    test("set viewrange", () {
      final viewRangeProvider =
          StateNotifierProvider<ViewRangeNotifier, ViewRange>(
              (ref) => ViewRangeNotifier());
      final container = ProviderContainer();
      final notifier = container.read(viewRangeProvider.notifier);
      ViewRange current = container.read(viewRangeProvider);

      expect(current, const ViewRange());

      const viewRange = ViewRange(
        start: 1,
        end: 2,
      );

      notifier.set(viewRange);

      current = container.read(viewRangeProvider);

      expect(current, viewRange);
    });
  });
}
