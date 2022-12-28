import 'package:flutter/cupertino.dart';
import 'package:timeline/models/claimed_region/claimed_region.dart';
import 'package:timeline/models/point/point.dart';
import 'package:timeline/models/viewrange/viewrange.dart';

///pointToRegion is a helper function that converts a [point] to a
///[ClaimedRegion] given the [constraints] and [range]
ClaimedRegion pointToRegion(
    Point point, BoxConstraints constraints, ViewRange range) {
  final relativePos = point.relativePosition(constraints, range);
  final width = point.width;
  return ClaimedRegion(relativePos, relativePos + width);
}

///A helper service class that is used by [OverlapService] to track overlaps
///
///It contains a list of pairs of starting and end locations which have already
///been used by other points, and the current maximum height.
class OverlapLayer {
  final List<ClaimedRegion> _claimedRegions = [];
  double _maxHeight = 0;

  OverlapLayer();

  ///overlap is true if the [region] overlaps with any claimed region,else false
  ///
  ///[constraints] and [range] is also needed since overlap is not based on the
  ///true position of a point. Rather, it is based on where the point would
  ///appear on the screen if it were rendered given the [range]
  bool overlap(
      ClaimedRegion region, BoxConstraints constraints, ViewRange range) {
    return _claimedRegions.any((element) => element.overlap(region));
  }

  ///Adds [region] to the list of claimed regions
  ///
  ///The respective point of [region] has given [height]
  void addRegion(ClaimedRegion region, double height) {
    _claimedRegions.add(region);
    _maxHeight = _maxHeight < height ? height : _maxHeight;
  }

  double get maxHeight => _maxHeight;
}

///Used to detect if [point] overlaps with any other known points
///
///This is used to detect if a point overlaps with other known points, and
///keep track of the current known points. It also provides the recommended
///height each point should be rendered at to prevent overlaps by mapping
///point id to heights. This recommended height is known as a "layer"
///
///It also has a way to calculate the height for the parent widget to have
///such that all points will be rendered without overlaps
class OverlapService {
  final Map<String, int> _pointToLayer = {};
  final List<OverlapLayer> _layers = [];

  ///Updates this service's state to reflect the addition of [point]
  ///
  ///[constraints] and [range] is also needed since overlap is not based on the
  ///true position of a point. Rather, it is based on where the point would
  ///appear on the screen if it were rendered given the [range]
  void addPoint(Point point, BoxConstraints constraints, ViewRange range) {
    final region = pointToRegion(point, constraints, range);
    for (int i = 0; i < _layers.length; i++) {
      final layer = _layers[i];
      if (!layer.overlap(region, constraints, range)) {
        _pointToLayer[point.id] = i;
        layer.addRegion(region, point.height);
        return;
      }
    }
    _pointToLayer[point.id] = _layers.length;
    _layers.add(OverlapLayer()..addRegion(region, point.height));
  }

  ///Recommended height for the parent widget to have
  double get height =>
      _layers.fold(0, (value, element) => value + element._maxHeight);

  ///Recommended height for the given [point] to be rendered at, or 0 if
  ///the [point] is not known
  double heightOfPoint(Point point) {
    final layer = _pointToLayer[point.id];
    if (layer == null) return 0;

    //knowing the layer the point is in is not enough to determine the height,
    //we also need to know the floor, which is the sum of all max heights of the
    //layers below the point's layer
    final floor = _layers
        .sublist(0, layer)
        .fold(0.0, (value, element) => value + element._maxHeight);

    return floor;
  }
}
