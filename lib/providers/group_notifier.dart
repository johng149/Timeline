import 'package:flutter_riverpod/flutter_riverpod.dart';

///Manages list of group ids
///
///It is a StateNotifier and thus its state is immutable
class GroupIdNotifier extends StateNotifier<List<String>> {
  GroupIdNotifier() : super([]);

  void initialize(List<String> groupIds) {
    state = groupIds;
  }

  ///Adds the [groupId] to the list of group ids
  void add(String groupId) {
    state = [...state, groupId];
  }

  ///Removes the [groupId] from the list of group ids
  void remove(String groupId) {
    state = state.where((id) => id != groupId).toList();
  }

  ///Moves the group id at [oldIndex] to [newIndex]
  void move(int oldIndex, int newIndex) {
    final List<String> newState = state;
    final String id = newState.removeAt(oldIndex);
    if (newIndex >= newState.length) {
      newState.add(id);
    } else {
      newState.insert(newIndex, id);
    }
    state = newState;
  }
}
