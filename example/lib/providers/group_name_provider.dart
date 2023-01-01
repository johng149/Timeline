import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/providers/group_name_notifier.dart';

final groupNameProvider = ChangeNotifierProvider<GroupNameNotifier>(
  (ref) => GroupNameNotifier(),
);
