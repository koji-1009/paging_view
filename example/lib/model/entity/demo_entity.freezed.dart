// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demo_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DemoEntity {

 String get word; String get description; String get category;
/// Create a copy of DemoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DemoEntityCopyWith<DemoEntity> get copyWith => _$DemoEntityCopyWithImpl<DemoEntity>(this as DemoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DemoEntity&&(identical(other.word, word) || other.word == word)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,word,description,category);

@override
String toString() {
  return 'DemoEntity(word: $word, description: $description, category: $category)';
}


}

/// @nodoc
abstract mixin class $DemoEntityCopyWith<$Res>  {
  factory $DemoEntityCopyWith(DemoEntity value, $Res Function(DemoEntity) _then) = _$DemoEntityCopyWithImpl;
@useResult
$Res call({
 String word, String description, String category
});




}
/// @nodoc
class _$DemoEntityCopyWithImpl<$Res>
    implements $DemoEntityCopyWith<$Res> {
  _$DemoEntityCopyWithImpl(this._self, this._then);

  final DemoEntity _self;
  final $Res Function(DemoEntity) _then;

/// Create a copy of DemoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? description = null,Object? category = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DemoEntity].
extension DemoEntityPatterns on DemoEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DemoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DemoEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DemoEntity value)  $default,){
final _that = this;
switch (_that) {
case _DemoEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DemoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DemoEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  String description,  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DemoEntity() when $default != null:
return $default(_that.word,_that.description,_that.category);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  String description,  String category)  $default,) {final _that = this;
switch (_that) {
case _DemoEntity():
return $default(_that.word,_that.description,_that.category);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  String description,  String category)?  $default,) {final _that = this;
switch (_that) {
case _DemoEntity() when $default != null:
return $default(_that.word,_that.description,_that.category);case _:
  return null;

}
}

}

/// @nodoc


class _DemoEntity implements DemoEntity {
  const _DemoEntity({required this.word, required this.description, required this.category});
  

@override final  String word;
@override final  String description;
@override final  String category;

/// Create a copy of DemoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DemoEntityCopyWith<_DemoEntity> get copyWith => __$DemoEntityCopyWithImpl<_DemoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemoEntity&&(identical(other.word, word) || other.word == word)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,word,description,category);

@override
String toString() {
  return 'DemoEntity(word: $word, description: $description, category: $category)';
}


}

/// @nodoc
abstract mixin class _$DemoEntityCopyWith<$Res> implements $DemoEntityCopyWith<$Res> {
  factory _$DemoEntityCopyWith(_DemoEntity value, $Res Function(_DemoEntity) _then) = __$DemoEntityCopyWithImpl;
@override @useResult
$Res call({
 String word, String description, String category
});




}
/// @nodoc
class __$DemoEntityCopyWithImpl<$Res>
    implements _$DemoEntityCopyWith<$Res> {
  __$DemoEntityCopyWithImpl(this._self, this._then);

  final _DemoEntity _self;
  final $Res Function(_DemoEntity) _then;

/// Create a copy of DemoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? description = null,Object? category = null,}) {
  return _then(_DemoEntity(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
