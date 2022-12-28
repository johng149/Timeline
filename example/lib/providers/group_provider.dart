import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/providers/group_notifier.dart';

final groupProvider = StateNotifierProvider<GroupNotifier, List<String>>(
  (ref) => GroupNotifier(),
);
