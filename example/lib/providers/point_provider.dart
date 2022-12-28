import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/providers/point_notifier.dart';

final pointProvider =
    ChangeNotifierProvider<PointNotifier>((ref) => PointNotifier());
