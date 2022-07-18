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
mixin _$LoadParams<Key> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() refresh,
    required TResult Function(Key key) prepend,
    required TResult Function(Key key) append,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? refresh,
    TResult Function(Key key)? prepend,
    TResult Function(Key key)? append,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? refresh,
    TResult Function(Key key)? prepend,
    TResult Function(Key key)? append,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadParamsRefresh<Key> value) refresh,
    required TResult Function(_LoadParamsPrepend<Key> value) prepend,
    required TResult Function(_LoadParamsAppend<Key> value) append,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LoadParamsRefresh<Key> value)? refresh,
    TResult Function(_LoadParamsPrepend<Key> value)? prepend,
    TResult Function(_LoadParamsAppend<Key> value)? append,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadParamsRefresh<Key> value)? refresh,
    TResult Function(_LoadParamsPrepend<Key> value)? prepend,
    TResult Function(_LoadParamsAppend<Key> value)? append,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoadParamsCopyWith<Key, $Res> {
  factory $LoadParamsCopyWith(
          LoadParams<Key> value, $Res Function(LoadParams<Key>) then) =
      _$LoadParamsCopyWithImpl<Key, $Res>;
}

/// @nodoc
class _$LoadParamsCopyWithImpl<Key, $Res>
    implements $LoadParamsCopyWith<Key, $Res> {
  _$LoadParamsCopyWithImpl(this._value, this._then);

  final LoadParams<Key> _value;
  // ignore: unused_field
  final $Res Function(LoadParams<Key>) _then;
}

/// @nodoc
abstract class _$$_LoadParamsRefreshCopyWith<Key, $Res> {
  factory _$$_LoadParamsRefreshCopyWith(_$_LoadParamsRefresh<Key> value,
          $Res Function(_$_LoadParamsRefresh<Key>) then) =
      __$$_LoadParamsRefreshCopyWithImpl<Key, $Res>;
}

/// @nodoc
class __$$_LoadParamsRefreshCopyWithImpl<Key, $Res>
    extends _$LoadParamsCopyWithImpl<Key, $Res>
    implements _$$_LoadParamsRefreshCopyWith<Key, $Res> {
  __$$_LoadParamsRefreshCopyWithImpl(_$_LoadParamsRefresh<Key> _value,
      $Res Function(_$_LoadParamsRefresh<Key>) _then)
      : super(_value, (v) => _then(v as _$_LoadParamsRefresh<Key>));

  @override
  _$_LoadParamsRefresh<Key> get _value =>
      super._value as _$_LoadParamsRefresh<Key>;
}

/// @nodoc

class _$_LoadParamsRefresh<Key>
    with DiagnosticableTreeMixin
    implements _LoadParamsRefresh<Key> {
  const _$_LoadParamsRefresh();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadParams<$Key>.refresh()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'LoadParams<$Key>.refresh'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoadParamsRefresh<Key>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() refresh,
    required TResult Function(Key key) prepend,
    required TResult Function(Key key) append,
  }) {
    return refresh();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? refresh,
    TResult Function(Key key)? prepend,
    TResult Function(Key key)? append,
  }) {
    return refresh?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? refresh,
    TResult Function(Key key)? prepend,
    TResult Function(Key key)? append,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadParamsRefresh<Key> value) refresh,
    required TResult Function(_LoadParamsPrepend<Key> value) prepend,
    required TResult Function(_LoadParamsAppend<Key> value) append,
  }) {
    return refresh(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LoadParamsRefresh<Key> value)? refresh,
    TResult Function(_LoadParamsPrepend<Key> value)? prepend,
    TResult Function(_LoadParamsAppend<Key> value)? append,
  }) {
    return refresh?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadParamsRefresh<Key> value)? refresh,
    TResult Function(_LoadParamsPrepend<Key> value)? prepend,
    TResult Function(_LoadParamsAppend<Key> value)? append,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh(this);
    }
    return orElse();
  }
}

abstract class _LoadParamsRefresh<Key> implements LoadParams<Key> {
  const factory _LoadParamsRefresh() = _$_LoadParamsRefresh<Key>;
}

/// @nodoc
abstract class _$$_LoadParamsPrependCopyWith<Key, $Res> {
  factory _$$_LoadParamsPrependCopyWith(_$_LoadParamsPrepend<Key> value,
          $Res Function(_$_LoadParamsPrepend<Key>) then) =
      __$$_LoadParamsPrependCopyWithImpl<Key, $Res>;
  $Res call({Key key});
}

/// @nodoc
class __$$_LoadParamsPrependCopyWithImpl<Key, $Res>
    extends _$LoadParamsCopyWithImpl<Key, $Res>
    implements _$$_LoadParamsPrependCopyWith<Key, $Res> {
  __$$_LoadParamsPrependCopyWithImpl(_$_LoadParamsPrepend<Key> _value,
      $Res Function(_$_LoadParamsPrepend<Key>) _then)
      : super(_value, (v) => _then(v as _$_LoadParamsPrepend<Key>));

  @override
  _$_LoadParamsPrepend<Key> get _value =>
      super._value as _$_LoadParamsPrepend<Key>;

  @override
  $Res call({
    Object? key = freezed,
  }) {
    return _then(_$_LoadParamsPrepend<Key>(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as Key,
    ));
  }
}

/// @nodoc

class _$_LoadParamsPrepend<Key>
    with DiagnosticableTreeMixin
    implements _LoadParamsPrepend<Key> {
  const _$_LoadParamsPrepend({required this.key});

  @override
  final Key key;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadParams<$Key>.prepend(key: $key)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoadParams<$Key>.prepend'))
      ..add(DiagnosticsProperty('key', key));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoadParamsPrepend<Key> &&
            const DeepCollectionEquality().equals(other.key, key));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(key));

  @JsonKey(ignore: true)
  @override
  _$$_LoadParamsPrependCopyWith<Key, _$_LoadParamsPrepend<Key>> get copyWith =>
      __$$_LoadParamsPrependCopyWithImpl<Key, _$_LoadParamsPrepend<Key>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() refresh,
    required TResult Function(Key key) prepend,
    required TResult Function(Key key) append,
  }) {
    return prepend(key);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? refresh,
    TResult Function(Key key)? prepend,
    TResult Function(Key key)? append,
  }) {
    return prepend?.call(key);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? refresh,
    TResult Function(Key key)? prepend,
    TResult Function(Key key)? append,
    required TResult orElse(),
  }) {
    if (prepend != null) {
      return prepend(key);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadParamsRefresh<Key> value) refresh,
    required TResult Function(_LoadParamsPrepend<Key> value) prepend,
    required TResult Function(_LoadParamsAppend<Key> value) append,
  }) {
    return prepend(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LoadParamsRefresh<Key> value)? refresh,
    TResult Function(_LoadParamsPrepend<Key> value)? prepend,
    TResult Function(_LoadParamsAppend<Key> value)? append,
  }) {
    return prepend?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadParamsRefresh<Key> value)? refresh,
    TResult Function(_LoadParamsPrepend<Key> value)? prepend,
    TResult Function(_LoadParamsAppend<Key> value)? append,
    required TResult orElse(),
  }) {
    if (prepend != null) {
      return prepend(this);
    }
    return orElse();
  }
}

abstract class _LoadParamsPrepend<Key> implements LoadParams<Key> {
  const factory _LoadParamsPrepend({required final Key key}) =
      _$_LoadParamsPrepend<Key>;

  Key get key;
  @JsonKey(ignore: true)
  _$$_LoadParamsPrependCopyWith<Key, _$_LoadParamsPrepend<Key>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_LoadParamsAppendCopyWith<Key, $Res> {
  factory _$$_LoadParamsAppendCopyWith(_$_LoadParamsAppend<Key> value,
          $Res Function(_$_LoadParamsAppend<Key>) then) =
      __$$_LoadParamsAppendCopyWithImpl<Key, $Res>;
  $Res call({Key key});
}

/// @nodoc
class __$$_LoadParamsAppendCopyWithImpl<Key, $Res>
    extends _$LoadParamsCopyWithImpl<Key, $Res>
    implements _$$_LoadParamsAppendCopyWith<Key, $Res> {
  __$$_LoadParamsAppendCopyWithImpl(_$_LoadParamsAppend<Key> _value,
      $Res Function(_$_LoadParamsAppend<Key>) _then)
      : super(_value, (v) => _then(v as _$_LoadParamsAppend<Key>));

  @override
  _$_LoadParamsAppend<Key> get _value =>
      super._value as _$_LoadParamsAppend<Key>;

  @override
  $Res call({
    Object? key = freezed,
  }) {
    return _then(_$_LoadParamsAppend<Key>(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as Key,
    ));
  }
}

/// @nodoc

class _$_LoadParamsAppend<Key>
    with DiagnosticableTreeMixin
    implements _LoadParamsAppend<Key> {
  const _$_LoadParamsAppend({required this.key});

  @override
  final Key key;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadParams<$Key>.append(key: $key)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoadParams<$Key>.append'))
      ..add(DiagnosticsProperty('key', key));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoadParamsAppend<Key> &&
            const DeepCollectionEquality().equals(other.key, key));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(key));

  @JsonKey(ignore: true)
  @override
  _$$_LoadParamsAppendCopyWith<Key, _$_LoadParamsAppend<Key>> get copyWith =>
      __$$_LoadParamsAppendCopyWithImpl<Key, _$_LoadParamsAppend<Key>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() refresh,
    required TResult Function(Key key) prepend,
    required TResult Function(Key key) append,
  }) {
    return append(key);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? refresh,
    TResult Function(Key key)? prepend,
    TResult Function(Key key)? append,
  }) {
    return append?.call(key);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? refresh,
    TResult Function(Key key)? prepend,
    TResult Function(Key key)? append,
    required TResult orElse(),
  }) {
    if (append != null) {
      return append(key);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadParamsRefresh<Key> value) refresh,
    required TResult Function(_LoadParamsPrepend<Key> value) prepend,
    required TResult Function(_LoadParamsAppend<Key> value) append,
  }) {
    return append(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LoadParamsRefresh<Key> value)? refresh,
    TResult Function(_LoadParamsPrepend<Key> value)? prepend,
    TResult Function(_LoadParamsAppend<Key> value)? append,
  }) {
    return append?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadParamsRefresh<Key> value)? refresh,
    TResult Function(_LoadParamsPrepend<Key> value)? prepend,
    TResult Function(_LoadParamsAppend<Key> value)? append,
    required TResult orElse(),
  }) {
    if (append != null) {
      return append(this);
    }
    return orElse();
  }
}

abstract class _LoadParamsAppend<Key> implements LoadParams<Key> {
  const factory _LoadParamsAppend({required final Key key}) =
      _$_LoadParamsAppend<Key>;

  Key get key;
  @JsonKey(ignore: true)
  _$$_LoadParamsAppendCopyWith<Key, _$_LoadParamsAppend<Key>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PageData<Value, Key> {
  List<Value> get data => throw _privateConstructorUsedError;
  Key? get prependKey => throw _privateConstructorUsedError;
  Key? get appendKey => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PageDataCopyWith<Value, Key, PageData<Value, Key>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageDataCopyWith<Value, Key, $Res> {
  factory $PageDataCopyWith(PageData<Value, Key> value,
          $Res Function(PageData<Value, Key>) then) =
      _$PageDataCopyWithImpl<Value, Key, $Res>;
  $Res call({List<Value> data, Key? prependKey, Key? appendKey});
}

/// @nodoc
class _$PageDataCopyWithImpl<Value, Key, $Res>
    implements $PageDataCopyWith<Value, Key, $Res> {
  _$PageDataCopyWithImpl(this._value, this._then);

  final PageData<Value, Key> _value;
  // ignore: unused_field
  final $Res Function(PageData<Value, Key>) _then;

  @override
  $Res call({
    Object? data = freezed,
    Object? prependKey = freezed,
    Object? appendKey = freezed,
  }) {
    return _then(_value.copyWith(
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Value>,
      prependKey: prependKey == freezed
          ? _value.prependKey
          : prependKey // ignore: cast_nullable_to_non_nullable
              as Key?,
      appendKey: appendKey == freezed
          ? _value.appendKey
          : appendKey // ignore: cast_nullable_to_non_nullable
              as Key?,
    ));
  }
}

/// @nodoc
abstract class _$$_PageDataCopyWith<Value, Key, $Res>
    implements $PageDataCopyWith<Value, Key, $Res> {
  factory _$$_PageDataCopyWith(_$_PageData<Value, Key> value,
          $Res Function(_$_PageData<Value, Key>) then) =
      __$$_PageDataCopyWithImpl<Value, Key, $Res>;
  @override
  $Res call({List<Value> data, Key? prependKey, Key? appendKey});
}

/// @nodoc
class __$$_PageDataCopyWithImpl<Value, Key, $Res>
    extends _$PageDataCopyWithImpl<Value, Key, $Res>
    implements _$$_PageDataCopyWith<Value, Key, $Res> {
  __$$_PageDataCopyWithImpl(_$_PageData<Value, Key> _value,
      $Res Function(_$_PageData<Value, Key>) _then)
      : super(_value, (v) => _then(v as _$_PageData<Value, Key>));

  @override
  _$_PageData<Value, Key> get _value => super._value as _$_PageData<Value, Key>;

  @override
  $Res call({
    Object? data = freezed,
    Object? prependKey = freezed,
    Object? appendKey = freezed,
  }) {
    return _then(_$_PageData<Value, Key>(
      data: data == freezed
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Value>,
      prependKey: prependKey == freezed
          ? _value.prependKey
          : prependKey // ignore: cast_nullable_to_non_nullable
              as Key?,
      appendKey: appendKey == freezed
          ? _value.appendKey
          : appendKey // ignore: cast_nullable_to_non_nullable
              as Key?,
    ));
  }
}

/// @nodoc

class _$_PageData<Value, Key>
    with DiagnosticableTreeMixin
    implements _PageData<Value, Key> {
  const _$_PageData(
      {final List<Value> data = const [], this.prependKey, this.appendKey})
      : _data = data;

  final List<Value> _data;
  @override
  @JsonKey()
  List<Value> get data {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final Key? prependKey;
  @override
  final Key? appendKey;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PageData<$Value, $Key>(data: $data, prependKey: $prependKey, appendKey: $appendKey)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PageData<$Value, $Key>'))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('prependKey', prependKey))
      ..add(DiagnosticsProperty('appendKey', appendKey));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PageData<Value, Key> &&
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
  _$$_PageDataCopyWith<Value, Key, _$_PageData<Value, Key>> get copyWith =>
      __$$_PageDataCopyWithImpl<Value, Key, _$_PageData<Value, Key>>(
          this, _$identity);
}

abstract class _PageData<Value, Key> implements PageData<Value, Key> {
  const factory _PageData(
      {final List<Value> data,
      final Key? prependKey,
      final Key? appendKey}) = _$_PageData<Value, Key>;

  @override
  List<Value> get data;
  @override
  Key? get prependKey;
  @override
  Key? get appendKey;
  @override
  @JsonKey(ignore: true)
  _$$_PageDataCopyWith<Value, Key, _$_PageData<Value, Key>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LoadResult<Value, Key> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PageData<Value, Key> page) success,
    required TResult Function(Exception? e) failure,
    required TResult Function() none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(PageData<Value, Key> page)? success,
    TResult Function(Exception? e)? failure,
    TResult Function()? none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PageData<Value, Key> page)? success,
    TResult Function(Exception? e)? failure,
    TResult Function()? none,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadResultSuccess<Value, Key> value) success,
    required TResult Function(_LoadResultFailure<Value, Key> value) failure,
    required TResult Function(_LoadResultNone<Value, Key> value) none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LoadResultSuccess<Value, Key> value)? success,
    TResult Function(_LoadResultFailure<Value, Key> value)? failure,
    TResult Function(_LoadResultNone<Value, Key> value)? none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadResultSuccess<Value, Key> value)? success,
    TResult Function(_LoadResultFailure<Value, Key> value)? failure,
    TResult Function(_LoadResultNone<Value, Key> value)? none,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoadResultCopyWith<Value, Key, $Res> {
  factory $LoadResultCopyWith(LoadResult<Value, Key> value,
          $Res Function(LoadResult<Value, Key>) then) =
      _$LoadResultCopyWithImpl<Value, Key, $Res>;
}

/// @nodoc
class _$LoadResultCopyWithImpl<Value, Key, $Res>
    implements $LoadResultCopyWith<Value, Key, $Res> {
  _$LoadResultCopyWithImpl(this._value, this._then);

  final LoadResult<Value, Key> _value;
  // ignore: unused_field
  final $Res Function(LoadResult<Value, Key>) _then;
}

/// @nodoc
abstract class _$$_LoadResultSuccessCopyWith<Value, Key, $Res> {
  factory _$$_LoadResultSuccessCopyWith(_$_LoadResultSuccess<Value, Key> value,
          $Res Function(_$_LoadResultSuccess<Value, Key>) then) =
      __$$_LoadResultSuccessCopyWithImpl<Value, Key, $Res>;
  $Res call({PageData<Value, Key> page});

  $PageDataCopyWith<Value, Key, $Res> get page;
}

/// @nodoc
class __$$_LoadResultSuccessCopyWithImpl<Value, Key, $Res>
    extends _$LoadResultCopyWithImpl<Value, Key, $Res>
    implements _$$_LoadResultSuccessCopyWith<Value, Key, $Res> {
  __$$_LoadResultSuccessCopyWithImpl(_$_LoadResultSuccess<Value, Key> _value,
      $Res Function(_$_LoadResultSuccess<Value, Key>) _then)
      : super(_value, (v) => _then(v as _$_LoadResultSuccess<Value, Key>));

  @override
  _$_LoadResultSuccess<Value, Key> get _value =>
      super._value as _$_LoadResultSuccess<Value, Key>;

  @override
  $Res call({
    Object? page = freezed,
  }) {
    return _then(_$_LoadResultSuccess<Value, Key>(
      page: page == freezed
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as PageData<Value, Key>,
    ));
  }

  @override
  $PageDataCopyWith<Value, Key, $Res> get page {
    return $PageDataCopyWith<Value, Key, $Res>(_value.page, (value) {
      return _then(_value.copyWith(page: value));
    });
  }
}

/// @nodoc

class _$_LoadResultSuccess<Value, Key>
    with DiagnosticableTreeMixin
    implements _LoadResultSuccess<Value, Key> {
  const _$_LoadResultSuccess({required this.page});

  @override
  final PageData<Value, Key> page;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadResult<$Value, $Key>.success(page: $page)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoadResult<$Value, $Key>.success'))
      ..add(DiagnosticsProperty('page', page));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoadResultSuccess<Value, Key> &&
            const DeepCollectionEquality().equals(other.page, page));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(page));

  @JsonKey(ignore: true)
  @override
  _$$_LoadResultSuccessCopyWith<Value, Key, _$_LoadResultSuccess<Value, Key>>
      get copyWith => __$$_LoadResultSuccessCopyWithImpl<Value, Key,
          _$_LoadResultSuccess<Value, Key>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PageData<Value, Key> page) success,
    required TResult Function(Exception? e) failure,
    required TResult Function() none,
  }) {
    return success(page);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(PageData<Value, Key> page)? success,
    TResult Function(Exception? e)? failure,
    TResult Function()? none,
  }) {
    return success?.call(page);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PageData<Value, Key> page)? success,
    TResult Function(Exception? e)? failure,
    TResult Function()? none,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(page);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadResultSuccess<Value, Key> value) success,
    required TResult Function(_LoadResultFailure<Value, Key> value) failure,
    required TResult Function(_LoadResultNone<Value, Key> value) none,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LoadResultSuccess<Value, Key> value)? success,
    TResult Function(_LoadResultFailure<Value, Key> value)? failure,
    TResult Function(_LoadResultNone<Value, Key> value)? none,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadResultSuccess<Value, Key> value)? success,
    TResult Function(_LoadResultFailure<Value, Key> value)? failure,
    TResult Function(_LoadResultNone<Value, Key> value)? none,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _LoadResultSuccess<Value, Key>
    implements LoadResult<Value, Key> {
  const factory _LoadResultSuccess({required final PageData<Value, Key> page}) =
      _$_LoadResultSuccess<Value, Key>;

  PageData<Value, Key> get page;
  @JsonKey(ignore: true)
  _$$_LoadResultSuccessCopyWith<Value, Key, _$_LoadResultSuccess<Value, Key>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_LoadResultFailureCopyWith<Value, Key, $Res> {
  factory _$$_LoadResultFailureCopyWith(_$_LoadResultFailure<Value, Key> value,
          $Res Function(_$_LoadResultFailure<Value, Key>) then) =
      __$$_LoadResultFailureCopyWithImpl<Value, Key, $Res>;
  $Res call({Exception? e});
}

/// @nodoc
class __$$_LoadResultFailureCopyWithImpl<Value, Key, $Res>
    extends _$LoadResultCopyWithImpl<Value, Key, $Res>
    implements _$$_LoadResultFailureCopyWith<Value, Key, $Res> {
  __$$_LoadResultFailureCopyWithImpl(_$_LoadResultFailure<Value, Key> _value,
      $Res Function(_$_LoadResultFailure<Value, Key>) _then)
      : super(_value, (v) => _then(v as _$_LoadResultFailure<Value, Key>));

  @override
  _$_LoadResultFailure<Value, Key> get _value =>
      super._value as _$_LoadResultFailure<Value, Key>;

  @override
  $Res call({
    Object? e = freezed,
  }) {
    return _then(_$_LoadResultFailure<Value, Key>(
      e: e == freezed
          ? _value.e
          : e // ignore: cast_nullable_to_non_nullable
              as Exception?,
    ));
  }
}

/// @nodoc

class _$_LoadResultFailure<Value, Key>
    with DiagnosticableTreeMixin
    implements _LoadResultFailure<Value, Key> {
  const _$_LoadResultFailure({required this.e});

  @override
  final Exception? e;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadResult<$Value, $Key>.failure(e: $e)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoadResult<$Value, $Key>.failure'))
      ..add(DiagnosticsProperty('e', e));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoadResultFailure<Value, Key> &&
            const DeepCollectionEquality().equals(other.e, e));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(e));

  @JsonKey(ignore: true)
  @override
  _$$_LoadResultFailureCopyWith<Value, Key, _$_LoadResultFailure<Value, Key>>
      get copyWith => __$$_LoadResultFailureCopyWithImpl<Value, Key,
          _$_LoadResultFailure<Value, Key>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PageData<Value, Key> page) success,
    required TResult Function(Exception? e) failure,
    required TResult Function() none,
  }) {
    return failure(e);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(PageData<Value, Key> page)? success,
    TResult Function(Exception? e)? failure,
    TResult Function()? none,
  }) {
    return failure?.call(e);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PageData<Value, Key> page)? success,
    TResult Function(Exception? e)? failure,
    TResult Function()? none,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(e);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadResultSuccess<Value, Key> value) success,
    required TResult Function(_LoadResultFailure<Value, Key> value) failure,
    required TResult Function(_LoadResultNone<Value, Key> value) none,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LoadResultSuccess<Value, Key> value)? success,
    TResult Function(_LoadResultFailure<Value, Key> value)? failure,
    TResult Function(_LoadResultNone<Value, Key> value)? none,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadResultSuccess<Value, Key> value)? success,
    TResult Function(_LoadResultFailure<Value, Key> value)? failure,
    TResult Function(_LoadResultNone<Value, Key> value)? none,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _LoadResultFailure<Value, Key>
    implements LoadResult<Value, Key> {
  const factory _LoadResultFailure({required final Exception? e}) =
      _$_LoadResultFailure<Value, Key>;

  Exception? get e;
  @JsonKey(ignore: true)
  _$$_LoadResultFailureCopyWith<Value, Key, _$_LoadResultFailure<Value, Key>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_LoadResultNoneCopyWith<Value, Key, $Res> {
  factory _$$_LoadResultNoneCopyWith(_$_LoadResultNone<Value, Key> value,
          $Res Function(_$_LoadResultNone<Value, Key>) then) =
      __$$_LoadResultNoneCopyWithImpl<Value, Key, $Res>;
}

/// @nodoc
class __$$_LoadResultNoneCopyWithImpl<Value, Key, $Res>
    extends _$LoadResultCopyWithImpl<Value, Key, $Res>
    implements _$$_LoadResultNoneCopyWith<Value, Key, $Res> {
  __$$_LoadResultNoneCopyWithImpl(_$_LoadResultNone<Value, Key> _value,
      $Res Function(_$_LoadResultNone<Value, Key>) _then)
      : super(_value, (v) => _then(v as _$_LoadResultNone<Value, Key>));

  @override
  _$_LoadResultNone<Value, Key> get _value =>
      super._value as _$_LoadResultNone<Value, Key>;
}

/// @nodoc

class _$_LoadResultNone<Value, Key>
    with DiagnosticableTreeMixin
    implements _LoadResultNone<Value, Key> {
  const _$_LoadResultNone();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadResult<$Value, $Key>.none()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'LoadResult<$Value, $Key>.none'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoadResultNone<Value, Key>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PageData<Value, Key> page) success,
    required TResult Function(Exception? e) failure,
    required TResult Function() none,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(PageData<Value, Key> page)? success,
    TResult Function(Exception? e)? failure,
    TResult Function()? none,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PageData<Value, Key> page)? success,
    TResult Function(Exception? e)? failure,
    TResult Function()? none,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadResultSuccess<Value, Key> value) success,
    required TResult Function(_LoadResultFailure<Value, Key> value) failure,
    required TResult Function(_LoadResultNone<Value, Key> value) none,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LoadResultSuccess<Value, Key> value)? success,
    TResult Function(_LoadResultFailure<Value, Key> value)? failure,
    TResult Function(_LoadResultNone<Value, Key> value)? none,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadResultSuccess<Value, Key> value)? success,
    TResult Function(_LoadResultFailure<Value, Key> value)? failure,
    TResult Function(_LoadResultNone<Value, Key> value)? none,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class _LoadResultNone<Value, Key> implements LoadResult<Value, Key> {
  const factory _LoadResultNone() = _$_LoadResultNone<Value, Key>;
}
