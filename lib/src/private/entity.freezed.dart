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
mixin _$NotifierState<PageKey, Value> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<PageKey, Value>> data)
        $default, {
    required TResult Function(Exception e) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            NotifierLoadingState state, List<PageData<PageKey, Value>> data)?
        $default, {
    TResult? Function(Exception e)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<PageKey, Value>> data)?
        $default, {
    TResult Function(Exception e)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NotifierState<PageKey, Value> value) $default, {
    required TResult Function(_NotifierStateError<PageKey, Value> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NotifierState<PageKey, Value> value)? $default, {
    TResult? Function(_NotifierStateError<PageKey, Value> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NotifierState<PageKey, Value> value)? $default, {
    TResult Function(_NotifierStateError<PageKey, Value> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotifierStateCopyWith<PageKey, Value, $Res> {
  factory $NotifierStateCopyWith(NotifierState<PageKey, Value> value,
          $Res Function(NotifierState<PageKey, Value>) then) =
      _$NotifierStateCopyWithImpl<PageKey, Value, $Res,
          NotifierState<PageKey, Value>>;
}

/// @nodoc
class _$NotifierStateCopyWithImpl<PageKey, Value, $Res,
        $Val extends NotifierState<PageKey, Value>>
    implements $NotifierStateCopyWith<PageKey, Value, $Res> {
  _$NotifierStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_NotifierStateCopyWith<PageKey, Value, $Res> {
  factory _$$_NotifierStateCopyWith(_$_NotifierState<PageKey, Value> value,
          $Res Function(_$_NotifierState<PageKey, Value>) then) =
      __$$_NotifierStateCopyWithImpl<PageKey, Value, $Res>;
  @useResult
  $Res call({NotifierLoadingState state, List<PageData<PageKey, Value>> data});
}

/// @nodoc
class __$$_NotifierStateCopyWithImpl<PageKey, Value, $Res>
    extends _$NotifierStateCopyWithImpl<PageKey, Value, $Res,
        _$_NotifierState<PageKey, Value>>
    implements _$$_NotifierStateCopyWith<PageKey, Value, $Res> {
  __$$_NotifierStateCopyWithImpl(_$_NotifierState<PageKey, Value> _value,
      $Res Function(_$_NotifierState<PageKey, Value>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? data = null,
  }) {
    return _then(_$_NotifierState<PageKey, Value>(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as NotifierLoadingState,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PageData<PageKey, Value>>,
    ));
  }
}

/// @nodoc

class _$_NotifierState<PageKey, Value>
    with DiagnosticableTreeMixin
    implements _NotifierState<PageKey, Value> {
  const _$_NotifierState(
      {required this.state,
      final List<PageData<PageKey, Value>> data = const []})
      : _data = data;

  @override
  final NotifierLoadingState state;
  final List<PageData<PageKey, Value>> _data;
  @override
  @JsonKey()
  List<PageData<PageKey, Value>> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotifierState<$PageKey, $Value>(state: $state, data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NotifierState<$PageKey, $Value>'))
      ..add(DiagnosticsProperty('state', state))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotifierState<PageKey, Value> &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotifierStateCopyWith<PageKey, Value, _$_NotifierState<PageKey, Value>>
      get copyWith => __$$_NotifierStateCopyWithImpl<PageKey, Value,
          _$_NotifierState<PageKey, Value>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<PageKey, Value>> data)
        $default, {
    required TResult Function(Exception e) error,
  }) {
    return $default(state, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            NotifierLoadingState state, List<PageData<PageKey, Value>> data)?
        $default, {
    TResult? Function(Exception e)? error,
  }) {
    return $default?.call(state, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<PageKey, Value>> data)?
        $default, {
    TResult Function(Exception e)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(state, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NotifierState<PageKey, Value> value) $default, {
    required TResult Function(_NotifierStateError<PageKey, Value> value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NotifierState<PageKey, Value> value)? $default, {
    TResult? Function(_NotifierStateError<PageKey, Value> value)? error,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NotifierState<PageKey, Value> value)? $default, {
    TResult Function(_NotifierStateError<PageKey, Value> value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NotifierState<PageKey, Value>
    implements NotifierState<PageKey, Value> {
  const factory _NotifierState(
          {required final NotifierLoadingState state,
          final List<PageData<PageKey, Value>> data}) =
      _$_NotifierState<PageKey, Value>;

  NotifierLoadingState get state;
  List<PageData<PageKey, Value>> get data;
  @JsonKey(ignore: true)
  _$$_NotifierStateCopyWith<PageKey, Value, _$_NotifierState<PageKey, Value>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_NotifierStateErrorCopyWith<PageKey, Value, $Res> {
  factory _$$_NotifierStateErrorCopyWith(
          _$_NotifierStateError<PageKey, Value> value,
          $Res Function(_$_NotifierStateError<PageKey, Value>) then) =
      __$$_NotifierStateErrorCopyWithImpl<PageKey, Value, $Res>;
  @useResult
  $Res call({Exception e});
}

/// @nodoc
class __$$_NotifierStateErrorCopyWithImpl<PageKey, Value, $Res>
    extends _$NotifierStateCopyWithImpl<PageKey, Value, $Res,
        _$_NotifierStateError<PageKey, Value>>
    implements _$$_NotifierStateErrorCopyWith<PageKey, Value, $Res> {
  __$$_NotifierStateErrorCopyWithImpl(
      _$_NotifierStateError<PageKey, Value> _value,
      $Res Function(_$_NotifierStateError<PageKey, Value>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? e = null,
  }) {
    return _then(_$_NotifierStateError<PageKey, Value>(
      e: null == e
          ? _value.e
          : e // ignore: cast_nullable_to_non_nullable
              as Exception,
    ));
  }
}

/// @nodoc

class _$_NotifierStateError<PageKey, Value>
    with DiagnosticableTreeMixin
    implements _NotifierStateError<PageKey, Value> {
  const _$_NotifierStateError({required this.e});

  @override
  final Exception e;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotifierState<$PageKey, $Value>.error(e: $e)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
          DiagnosticsProperty('type', 'NotifierState<$PageKey, $Value>.error'))
      ..add(DiagnosticsProperty('e', e));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotifierStateError<PageKey, Value> &&
            (identical(other.e, e) || other.e == e));
  }

  @override
  int get hashCode => Object.hash(runtimeType, e);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotifierStateErrorCopyWith<PageKey, Value,
          _$_NotifierStateError<PageKey, Value>>
      get copyWith => __$$_NotifierStateErrorCopyWithImpl<PageKey, Value,
          _$_NotifierStateError<PageKey, Value>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<PageKey, Value>> data)
        $default, {
    required TResult Function(Exception e) error,
  }) {
    return error(e);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            NotifierLoadingState state, List<PageData<PageKey, Value>> data)?
        $default, {
    TResult? Function(Exception e)? error,
  }) {
    return error?.call(e);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<PageKey, Value>> data)?
        $default, {
    TResult Function(Exception e)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(e);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NotifierState<PageKey, Value> value) $default, {
    required TResult Function(_NotifierStateError<PageKey, Value> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NotifierState<PageKey, Value> value)? $default, {
    TResult? Function(_NotifierStateError<PageKey, Value> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NotifierState<PageKey, Value> value)? $default, {
    TResult Function(_NotifierStateError<PageKey, Value> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _NotifierStateError<PageKey, Value>
    implements NotifierState<PageKey, Value> {
  const factory _NotifierStateError({required final Exception e}) =
      _$_NotifierStateError<PageKey, Value>;

  Exception get e;
  @JsonKey(ignore: true)
  _$$_NotifierStateErrorCopyWith<PageKey, Value,
          _$_NotifierStateError<PageKey, Value>>
      get copyWith => throw _privateConstructorUsedError;
}
