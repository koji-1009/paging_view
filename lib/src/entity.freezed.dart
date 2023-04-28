// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PageData<PageKey, Value> {
  List<Value> get data => throw _privateConstructorUsedError;
  PageKey? get prependKey => throw _privateConstructorUsedError;
  PageKey? get appendKey => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PageDataCopyWith<PageKey, Value, PageData<PageKey, Value>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageDataCopyWith<PageKey, Value, $Res> {
  factory $PageDataCopyWith(PageData<PageKey, Value> value,
          $Res Function(PageData<PageKey, Value>) then) =
      _$PageDataCopyWithImpl<PageKey, Value, $Res, PageData<PageKey, Value>>;
  @useResult
  $Res call({List<Value> data, PageKey? prependKey, PageKey? appendKey});
}

/// @nodoc
class _$PageDataCopyWithImpl<PageKey, Value, $Res,
        $Val extends PageData<PageKey, Value>>
    implements $PageDataCopyWith<PageKey, Value, $Res> {
  _$PageDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? prependKey = freezed,
    Object? appendKey = freezed,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Value>,
      prependKey: freezed == prependKey
          ? _value.prependKey
          : prependKey // ignore: cast_nullable_to_non_nullable
              as PageKey?,
      appendKey: freezed == appendKey
          ? _value.appendKey
          : appendKey // ignore: cast_nullable_to_non_nullable
              as PageKey?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PageDataCopyWith<PageKey, Value, $Res>
    implements $PageDataCopyWith<PageKey, Value, $Res> {
  factory _$$_PageDataCopyWith(_$_PageData<PageKey, Value> value,
          $Res Function(_$_PageData<PageKey, Value>) then) =
      __$$_PageDataCopyWithImpl<PageKey, Value, $Res>;
  @override
  @useResult
  $Res call({List<Value> data, PageKey? prependKey, PageKey? appendKey});
}

/// @nodoc
class __$$_PageDataCopyWithImpl<PageKey, Value, $Res>
    extends _$PageDataCopyWithImpl<PageKey, Value, $Res,
        _$_PageData<PageKey, Value>>
    implements _$$_PageDataCopyWith<PageKey, Value, $Res> {
  __$$_PageDataCopyWithImpl(_$_PageData<PageKey, Value> _value,
      $Res Function(_$_PageData<PageKey, Value>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? prependKey = freezed,
    Object? appendKey = freezed,
  }) {
    return _then(_$_PageData<PageKey, Value>(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Value>,
      prependKey: freezed == prependKey
          ? _value.prependKey
          : prependKey // ignore: cast_nullable_to_non_nullable
              as PageKey?,
      appendKey: freezed == appendKey
          ? _value.appendKey
          : appendKey // ignore: cast_nullable_to_non_nullable
              as PageKey?,
    ));
  }
}

/// @nodoc

class _$_PageData<PageKey, Value>
    with DiagnosticableTreeMixin
    implements _PageData<PageKey, Value> {
  const _$_PageData(
      {final List<Value> data = const [], this.prependKey, this.appendKey})
      : _data = data;

  final List<Value> _data;
  @override
  @JsonKey()
  List<Value> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PageKey? prependKey;
  @override
  final PageKey? appendKey;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PageData<$PageKey, $Value>(data: $data, prependKey: $prependKey, appendKey: $appendKey)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PageData<$PageKey, $Value>'))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('prependKey', prependKey))
      ..add(DiagnosticsProperty('appendKey', appendKey));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PageData<PageKey, Value> &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality()
                .equals(other.prependKey, prependKey) &&
            const DeepCollectionEquality().equals(other.appendKey, appendKey));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      const DeepCollectionEquality().hash(prependKey),
      const DeepCollectionEquality().hash(appendKey));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PageDataCopyWith<PageKey, Value, _$_PageData<PageKey, Value>>
      get copyWith => __$$_PageDataCopyWithImpl<PageKey, Value,
          _$_PageData<PageKey, Value>>(this, _$identity);
}

abstract class _PageData<PageKey, Value> implements PageData<PageKey, Value> {
  const factory _PageData(
      {final List<Value> data,
      final PageKey? prependKey,
      final PageKey? appendKey}) = _$_PageData<PageKey, Value>;

  @override
  List<Value> get data;
  @override
  PageKey? get prependKey;
  @override
  PageKey? get appendKey;
  @override
  @JsonKey(ignore: true)
  _$$_PageDataCopyWith<PageKey, Value, _$_PageData<PageKey, Value>>
      get copyWith => throw _privateConstructorUsedError;
}
