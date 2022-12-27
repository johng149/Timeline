import 'package:flutter_riverpod/flutter_riverpod.dart';

///Manages list of group ids
///
///It is a StateNotifier and thus its state is immutable
class GroupNotifier extends StateNotifier<List<String>> {
  GroupNotifier() : super([]);

  ///Adds the [groupId] to the list of group ids
  void add(String groupId) {
    state = [...state, groupId];
  }

  ///Removes the [groupId] from the list of group ids
  void remove(String groupId) {
    state = state.where((id) => id != groupId).toList();
  }

  ///Removes the [groupId] from the list of group ids and inserts it at the
  ///specified [index]
  void move(String groupId, int index) {
    state = state.where((id) => id != groupId).toList()..insert(index, groupId);
  }
}
