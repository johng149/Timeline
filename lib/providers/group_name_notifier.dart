import 'package:flutter/material.dart';

class GroupNameNotifier extends ChangeNotifier {
  Map<String, String> _groupNames = {};

  Map<String, String> get groupNames => _groupNames;

  void initialize(Map<String, String> groupNames) {
    _groupNames = groupNames;
    notifyListeners();
  }

  void add(String groupId, String groupName) {
    _groupNames[groupId] = groupName;
    notifyListeners();
  }

  void remove(String groupId) {
    _groupNames.remove(groupId);
    notifyListeners();
  }

  void update(String groupId, String groupName) {
    _groupNames[groupId] = groupName;
    notifyListeners();
  }

  String? name(String groupId) {
    return _groupNames[groupId];
  }
}
