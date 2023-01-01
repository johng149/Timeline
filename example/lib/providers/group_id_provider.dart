import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/providers/group_notifier.dart';

final groupIdProvider = StateNotifierProvider<GroupIdNotifier, List<String>>(
  (ref) => GroupIdNotifier(),
);
