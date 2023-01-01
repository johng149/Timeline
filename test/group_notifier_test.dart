import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeline/providers/group_notifier.dart';

void main() {
  group("group notifier", () {
    test("add group", () {
      final groupProvider =
          StateNotifierProvider<GroupIdNotifier, List<String>>(
              (ref) => GroupIdNotifier());
      final container = ProviderContainer();
      final notifier = container.read(groupProvider.notifier);
      const group1 = "test group";
      notifier.add(group1);

      final state = container.read(groupProvider);
      expect(state, [group1]);
    });

    test("remove group", () {
      final groupProvider =
          StateNotifierProvider<GroupIdNotifier, List<String>>(
              (ref) => GroupIdNotifier());
      final container = ProviderContainer();
      final notifier = container.read(groupProvider.notifier);
      const group1 = "test group";
      notifier.add(group1);
      notifier.remove(group1);

      final state = container.read(groupProvider);
      expect(state, []);
    });

    test("move group", () {
      final groupProvider =
          StateNotifierProvider<GroupIdNotifier, List<String>>(
              (ref) => GroupIdNotifier());
      final container = ProviderContainer();
      final notifier = container.read(groupProvider.notifier);
      const group1 = "test group 1";
      const group2 = "test group 2";
      notifier.add(group1);
      notifier.add(group2);
      notifier.move(1, 0);

      final state = container.read(groupProvider);
      expect(state, [group2, group1]);
    });
  });
}
