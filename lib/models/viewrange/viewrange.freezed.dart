// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'viewrange.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ViewRange _$ViewRangeFromJson(Map<String, dynamic> json) {
  return _ViewRange.fromJson(json);
}

/// @nodoc
mixin _$ViewRange {
  double get start => throw _privateConstructorUsedError;
  double get end => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ViewRangeCopyWith<ViewRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViewRangeCopyWith<$Res> {
  factory $ViewRangeCopyWith(ViewRange value, $Res Function(ViewRange) then) =
      _$ViewRangeCopyWithImpl<$Res, ViewRange>;
  @useResult
  $Res call({double start, double end});
}

/// @nodoc
class _$ViewRangeCopyWithImpl<$Res, $Val extends ViewRange>
    implements $ViewRangeCopyWith<$Res> {
  _$ViewRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_value.copyWith(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as double,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ViewRangeCopyWith<$Res> implements $ViewRangeCopyWith<$Res> {
  factory _$$_ViewRangeCopyWith(
          _$_ViewRange value, $Res Function(_$_ViewRange) then) =
      __$$_ViewRangeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double start, double end});
}

/// @nodoc
class __$$_ViewRangeCopyWithImpl<$Res>
    extends _$ViewRangeCopyWithImpl<$Res, _$_ViewRange>
    implements _$$_ViewRangeCopyWith<$Res> {
  __$$_ViewRangeCopyWithImpl(
      _$_ViewRange _value, $Res Function(_$_ViewRange) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_$_ViewRange(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as double,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ViewRange extends _ViewRange {
  const _$_ViewRange({this.start = 0, this.end = 100}) : super._();

  factory _$_ViewRange.fromJson(Map<String, dynamic> json) =>
      _$$_ViewRangeFromJson(json);

  @override
  @JsonKey()
  final double start;
  @override
  @JsonKey()
  final double end;

  @override
  String toString() {
    return 'ViewRange(start: $start, end: $end)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewRange &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViewRangeCopyWith<_$_ViewRange> get copyWith =>
      __$$_ViewRangeCopyWithImpl<_$_ViewRange>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ViewRangeToJson(
      this,
    );
  }
}

abstract class _ViewRange extends ViewRange {
  const factory _ViewRange({final double start, final double end}) =
      _$_ViewRange;
  const _ViewRange._() : super._();

  factory _ViewRange.fromJson(Map<String, dynamic> json) =
      _$_ViewRange.fromJson;

  @override
  double get start;
  @override
  double get end;
  @override
  @JsonKey(ignore: true)
  _$$_ViewRangeCopyWith<_$_ViewRange> get copyWith =>
      throw _privateConstructorUsedError;
}
