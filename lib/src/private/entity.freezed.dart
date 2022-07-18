// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotifierState<Value, Key> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<Value, Key>> data)
        $default, {
    required TResult Function(Exception? e) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<Value, Key>> data)?
        $default, {
    TResult Function(Exception? e)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<Value, Key>> data)?
        $default, {
    TResult Function(Exception? e)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NotifierState<Value, Key> value) $default, {
    required TResult Function(_NotifierStateError<Value, Key> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(_NotifierState<Value, Key> value)? $default, {
    TResult Function(_NotifierStateError<Value, Key> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NotifierState<Value, Key> value)? $default, {
    TResult Function(_NotifierStateError<Value, Key> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotifierStateCopyWith<Value, Key, $Res> {
  factory $NotifierStateCopyWith(NotifierState<Value, Key> value,
          $Res Function(NotifierState<Value, Key>) then) =
      _$NotifierStateCopyWithImpl<Value, Key, $Res>;
}

/// @nodoc
class _$NotifierStateCopyWithImpl<Value, Key, $Res>
    implements $NotifierStateCopyWith<Value, Key, $Res> {
  _$NotifierStateCopyWithImpl(this._value, this._then);

  final NotifierState<Value, Key> _value;
  // ignore: unused_field
  final $Res Function(NotifierState<Value, Key>) _then;
}

/// @nodoc
abstract class _$$_NotifierStateCopyWith<Value, Key, $Res> {
  factory _$$_NotifierStateCopyWith(_$_NotifierState<Value, Key> value,
          $Res Function(_$_NotifierState<Value, Key>) then) =
      __$$_NotifierStateCopyWithImpl<Value, Key, $Res>;
  $Res call({NotifierLoadingState state, List<PageData<Value, Key>> data});
}

/// @nodoc
class __$$_NotifierStateCopyWithImpl<Value, Key, $Res>
    extends _$NotifierStateCopyWithImpl<Value, Key, $Res>
    implements _$$_NotifierStateCopyWith<Value, Key, $Res> {
  __$$_NotifierStateCopyWithImpl(_$_NotifierState<Value, Key> _value,
      $Res Function(_$_NotifierState<Value, Key>) _then)
      : super(_value, (v) => _then(v as _$_NotifierState<Value, Key>));

  @override
  _$_NotifierState<Value, Key> get _value =>
      super._value as _$_NotifierState<Value, Key>;

  @override
  $Res call({
    Object? state = freezed,
    Object? data = freezed,
  }) {
    return _then(_$_NotifierState<Value, Key>(
      state: state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as NotifierLoadingState,
      data: data == freezed
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PageData<Value, Key>>,
    ));
  }
}

/// @nodoc

class _$_NotifierState<Value, Key>
    with DiagnosticableTreeMixin
    implements _NotifierState<Value, Key> {
  const _$_NotifierState(
      {required this.state, final List<PageData<Value, Key>> data = const []})
      : _data = data;

  @override
  final NotifierLoadingState state;
  final List<PageData<Value, Key>> _data;
  @override
  @JsonKey()
  List<PageData<Value, Key>> get data {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotifierState<$Value, $Key>(state: $state, data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NotifierState<$Value, $Key>'))
      ..add(DiagnosticsProperty('state', state))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotifierState<Value, Key> &&
            const DeepCollectionEquality().equals(other.state, state) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(state),
      const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  _$$_NotifierStateCopyWith<Value, Key, _$_NotifierState<Value, Key>>
      get copyWith => __$$_NotifierStateCopyWithImpl<Value, Key,
          _$_NotifierState<Value, Key>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<Value, Key>> data)
        $default, {
    required TResult Function(Exception? e) error,
  }) {
    return $default(state, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<Value, Key>> data)?
        $default, {
    TResult Function(Exception? e)? error,
  }) {
    return $default?.call(state, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<Value, Key>> data)?
        $default, {
    TResult Function(Exception? e)? error,
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
    TResult Function(_NotifierState<Value, Key> value) $default, {
    required TResult Function(_NotifierStateError<Value, Key> value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(_NotifierState<Value, Key> value)? $default, {
    TResult Function(_NotifierStateError<Value, Key> value)? error,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NotifierState<Value, Key> value)? $default, {
    TResult Function(_NotifierStateError<Value, Key> value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NotifierState<Value, Key> implements NotifierState<Value, Key> {
  const factory _NotifierState(
      {required final NotifierLoadingState state,
      final List<PageData<Value, Key>> data}) = _$_NotifierState<Value, Key>;

  NotifierLoadingState get state;
  List<PageData<Value, Key>> get data;
  @JsonKey(ignore: true)
  _$$_NotifierStateCopyWith<Value, Key, _$_NotifierState<Value, Key>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_NotifierStateErrorCopyWith<Value, Key, $Res> {
  factory _$$_NotifierStateErrorCopyWith(
          _$_NotifierStateError<Value, Key> value,
          $Res Function(_$_NotifierStateError<Value, Key>) then) =
      __$$_NotifierStateErrorCopyWithImpl<Value, Key, $Res>;
  $Res call({Exception? e});
}

/// @nodoc
class __$$_NotifierStateErrorCopyWithImpl<Value, Key, $Res>
    extends _$NotifierStateCopyWithImpl<Value, Key, $Res>
    implements _$$_NotifierStateErrorCopyWith<Value, Key, $Res> {
  __$$_NotifierStateErrorCopyWithImpl(_$_NotifierStateError<Value, Key> _value,
      $Res Function(_$_NotifierStateError<Value, Key>) _then)
      : super(_value, (v) => _then(v as _$_NotifierStateError<Value, Key>));

  @override
  _$_NotifierStateError<Value, Key> get _value =>
      super._value as _$_NotifierStateError<Value, Key>;

  @override
  $Res call({
    Object? e = freezed,
  }) {
    return _then(_$_NotifierStateError<Value, Key>(
      e: e == freezed
          ? _value.e
          : e // ignore: cast_nullable_to_non_nullable
              as Exception?,
    ));
  }
}

/// @nodoc

class _$_NotifierStateError<Value, Key>
    with DiagnosticableTreeMixin
    implements _NotifierStateError<Value, Key> {
  const _$_NotifierStateError({required this.e});

  @override
  final Exception? e;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotifierState<$Value, $Key>.error(e: $e)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NotifierState<$Value, $Key>.error'))
      ..add(DiagnosticsProperty('e', e));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotifierStateError<Value, Key> &&
            const DeepCollectionEquality().equals(other.e, e));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(e));

  @JsonKey(ignore: true)
  @override
  _$$_NotifierStateErrorCopyWith<Value, Key, _$_NotifierStateError<Value, Key>>
      get copyWith => __$$_NotifierStateErrorCopyWithImpl<Value, Key,
          _$_NotifierStateError<Value, Key>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<Value, Key>> data)
        $default, {
    required TResult Function(Exception? e) error,
  }) {
    return error(e);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<Value, Key>> data)?
        $default, {
    TResult Function(Exception? e)? error,
  }) {
    return error?.call(e);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            NotifierLoadingState state, List<PageData<Value, Key>> data)?
        $default, {
    TResult Function(Exception? e)? error,
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
    TResult Function(_NotifierState<Value, Key> value) $default, {
    required TResult Function(_NotifierStateError<Value, Key> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(_NotifierState<Value, Key> value)? $default, {
    TResult Function(_NotifierStateError<Value, Key> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NotifierState<Value, Key> value)? $default, {
    TResult Function(_NotifierStateError<Value, Key> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _NotifierStateError<Value, Key>
    implements NotifierState<Value, Key> {
  const factory _NotifierStateError({required final Exception? e}) =
      _$_NotifierStateError<Value, Key>;

  Exception? get e;
  @JsonKey(ignore: true)
  _$$_NotifierStateErrorCopyWith<Value, Key, _$_NotifierStateError<Value, Key>>
      get copyWith => throw _privateConstructorUsedError;
}
