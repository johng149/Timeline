//contains functions/values/classes that are used in multiple tests

import 'package:flutter/material.dart';
import 'package:timeline/models/point/point.dart';
import 'package:timeline/models/viewrange/viewrange.dart';

class TestPoint with Point {
  final _height = 100.0;
  final _width = 100.0;
  final String _id;
  final double _position;
  final String _group;

  TestPoint(this._id, this._position, this._group);

  @override
  Widget get child => SizedBox(
        height: _height,
        width: _width,
        child: const Placeholder(),
      );

  @override
  double get height => _height;

  @override
  String get id => _id;

  @override
  double get position => _position;

  @override
  double get width => _width;

  @override
  String toString() {
    return "id: $_id, position: $_position";
  }

  @override
  String get group => _group;
}
