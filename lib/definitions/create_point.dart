import 'package:timeline/models/point/point.dart';

///a typedef for a function that creates a [Point?]
///
///This function is used when the user double taps to create a point on
///the timeline. The position that the [Point] should have is given along
///with the [group] that the point should be associated with
///
///If the user cancels, the function returns null
typedef CreatePoint = Point? Function(double position, String group);
