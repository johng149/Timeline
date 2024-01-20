import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline/models/point/point.dart';

final selectedPointProvider = StateProvider<Point?>((ref) => null);
